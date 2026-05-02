"""
System Admin views for DocBot.
Handles user management, doctor management, and admin panel.
"""
from datetime import date
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.utils import timezone
from django.db.models import Q, Avg, Count

from core.decorators import admin_required, superadmin_required
from patient.models import User, Patientprofile
from doctor.models import (
    Doctor, Doctorassistant, Doctoraddress, Doctorschedule, Doctortimeslot,
    Prescription, Prescribedmedication,
)
from doctor.views import _generate_slots_for_schedule
from appointment.models import Doctorappointment, Doctorreview
from systemadmin.models import Measurementtypes, Inheritablediseases
import cloudinary.uploader


# =============================================================================
# Dashboard
# =============================================================================
@admin_required
def dashboard(request):
    context = {
        'total_users': User.objects.filter(deleted_at__isnull=True).count(),
        'total_doctors': Doctor.objects.count(),
        'total_patients': User.objects.filter(role='Patient', deleted_at__isnull=True).count(),
        'total_appointments': Doctorappointment.objects.count(),
        'completed_appointments': Doctorappointment.objects.filter(status='Completed').count(),
        'pending_appointments': Doctorappointment.objects.filter(status='Booked').count(),
        'total_reviews': Doctorreview.objects.count(),
    }
    return render(request, 'systemadmin/dashboard.html', context)


# =============================================================================
# User Management
# =============================================================================
@admin_required
def user_list(request):
    role_filter = request.GET.get('role', '')
    search = request.GET.get('search', '')
    users = User.objects.all().order_by('-date_joined')

    if role_filter:
        users = users.filter(role=role_filter)
    if search:
        users = users.filter(
            Q(username__icontains=search) | Q(first_name__icontains=search) |
            Q(last_name__icontains=search) | Q(email__icontains=search)
        )

    return render(request, 'systemadmin/users.html', {
        'users': users, 'current_role': role_filter, 'search': search,
    })


@superadmin_required
def user_edit_role(request, pk):
    user = get_object_or_404(User, pk=pk)
    if request.method == 'POST':
        new_role = request.POST.get('role')
        if new_role in ('Patient', 'Doctor', 'Doctor_Assistant', 'Moderator', 'Super_Admin'):
            user.role = new_role
            user.save()
            messages.success(request, f'Role updated to {new_role}.')
    return redirect('admin_users')


@admin_required
def user_delete(request, pk):
    user = get_object_or_404(User, pk=pk)
    # Moderator can't delete Super_Admin
    if request.user.role == 'Moderator' and user.role == 'Super_Admin':
        messages.error(request, "Moderators cannot delete Super Admins.")
        return redirect('admin_users')
    if request.method == 'POST':
        user.deleted_at = timezone.now()
        user.is_active = False
        user.save()
        messages.success(request, f'User {user.username} deactivated.')
    return redirect('admin_users')


@admin_required
def user_reactivate(request, pk):
    user = get_object_or_404(User, pk=pk)
    # Moderator can't reactivate Super_Admin
    if request.user.role == 'Moderator' and user.role == 'Super_Admin':
        messages.error(request, "Moderators cannot reactivate Super Admins.")
        return redirect('admin_users')
    if request.method == 'POST':
        user.deleted_at = None
        user.is_active = True
        user.save()
        messages.success(request, f'User {user.username} reactivated.')
    return redirect('admin_users')


# =============================================================================
# Doctor Management
# =============================================================================
@admin_required
def doctor_list(request):
    doctors = Doctor.objects.select_related('user').filter(
        user__deleted_at__isnull=True
    ).annotate(
        avg_rating=Avg('doctorreview__rating'),
        appointment_count=Count('doctorappointment'),
    )
    return render(request, 'systemadmin/doctors.html', {'doctors': doctors})


@superadmin_required
def doctor_add(request):
    if request.method == 'POST':
        # Create user first
        username = request.POST.get('username', '').strip()
        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists.')
            return redirect('admin_doctor_add')

        user = User.objects.create_user(
            username=username,
            email=request.POST.get('email', '').strip(),
            password=request.POST.get('password', ''),
            first_name=request.POST.get('first_name', '').strip(),
            last_name=request.POST.get('last_name', '').strip(),
            phone=request.POST.get('phone', '').strip() or None,
            role='Doctor',
        )
        Doctor.objects.create(
            user=user,
            specialization=request.POST.get('specialization', '').strip(),
            years_of_experience=int(request.POST.get('years_of_experience', 0)),
            price=float(request.POST.get('price', 0)),
            follow_up_price=float(request.POST.get('follow_up_price', 0)),
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, f'Doctor {user.get_full_name()} created.')
        return redirect('admin_doctors')
    return render(request, 'systemadmin/doctor_form.html')


@superadmin_required
def doctor_edit(request, username):
    doctor = get_object_or_404(Doctor.objects.select_related('user'), user__username=username)
    if request.method == 'POST':
        user = doctor.user
        user.first_name = request.POST.get('first_name', '').strip()
        user.last_name = request.POST.get('last_name', '').strip()
        user.email = request.POST.get('email', '').strip()
        user.phone = request.POST.get('phone', '').strip() or None
        user.save()
        doctor.specialization = request.POST.get('specialization', '').strip()
        doctor.years_of_experience = int(request.POST.get('years_of_experience', 0))
        doctor.price = float(request.POST.get('price', 0))
        doctor.follow_up_price = float(request.POST.get('follow_up_price', 0))
        
        if 'image' in request.FILES:
            upload = cloudinary.uploader.upload(request.FILES['image'])
            doctor.image = upload['secure_url']
        elif 'remove_image' in request.POST:
            doctor.image = None
            
        doctor.updated_at = timezone.now()
        doctor.save()
        messages.success(request, 'Doctor profile updated.')
        return redirect('admin_doctors')
    return render(request, 'systemadmin/doctor_form.html', {'doctor': doctor})


@superadmin_required
def doctor_delete(request, username):
    doctor = get_object_or_404(Doctor, user__username=username)
    if request.method == 'POST':
        user = doctor.user
        user.deleted_at = timezone.now()
        user.is_active = False
        user.save()
        messages.success(request, 'Doctor deactivated.')
    return redirect('admin_doctors')


# =============================================================================
# Doctor Addresses
# =============================================================================
@superadmin_required
def doctor_addresses(request, username):
    doctor = get_object_or_404(Doctor.objects.select_related('user'), user__username=username)
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'systemadmin/doctor_addresses.html', {'doctor': doctor, 'addresses': addresses})


@superadmin_required
def doctor_address_add(request, username):
    doctor = get_object_or_404(Doctor, user__username=username)
    if request.method == 'POST':
        Doctoraddress.objects.create(
            doctor=doctor,
            floor=request.POST.get('floor', '').strip() or None,
            building_number=int(request.POST.get('building_number', 0)) or None,
            street=request.POST.get('street', '').strip(),
            governorate=request.POST.get('governorate', '').strip(),
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Address added.')
    return redirect('admin_doctor_addresses', username=username)


@superadmin_required
def doctor_address_edit(request, username, address_id):
    address = get_object_or_404(Doctoraddress, pk=address_id, doctor__user__username=username)
    if request.method == 'POST':
        address.floor = request.POST.get('floor', '').strip() or None
        address.building_number = int(request.POST.get('building_number', 0)) or None
        address.street = request.POST.get('street', '').strip()
        address.governorate = request.POST.get('governorate', '').strip()
        address.updated_at = timezone.now()
        address.save()
        messages.success(request, 'Address updated.')
    return redirect('admin_doctor_addresses', username=username)


@superadmin_required
def doctor_address_delete(request, username, address_id):
    address = get_object_or_404(Doctoraddress, pk=address_id, doctor__user__username=username)
    if request.method == 'POST':
        address.delete()
        messages.success(request, 'Address deleted.')
    return redirect('admin_doctor_addresses', username=username)


# =============================================================================
# Doctor Schedules (Admin)
# =============================================================================
@superadmin_required
def admin_doctor_schedules(request, username):
    doctor = get_object_or_404(Doctor.objects.select_related('user'), user__username=username)
    schedules = Doctorschedule.objects.filter(doctor=doctor).select_related('doctor_address')
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'systemadmin/doctor_schedules.html', {
        'doctor': doctor, 'schedules': schedules, 'addresses': addresses,
    })


@superadmin_required
def admin_doctor_schedule_add(request, username):
    doctor = get_object_or_404(Doctor, user__username=username)
    if request.method == 'POST':
        schedule = Doctorschedule.objects.create(
            doctor=doctor,
            doctor_address_id=request.POST.get('doctor_address'),
            day_of_week=request.POST.get('day_of_week'),
            start_time=request.POST.get('start_time'),
            end_time=request.POST.get('end_time'),
            slot_duration=int(request.POST.get('slot_duration', 30)),
            created_at=timezone.now(), updated_at=timezone.now()
        )
        _generate_slots_for_schedule(schedule)
        messages.success(request, 'Schedule added and slots generated.')
    return redirect('admin_doctor_schedules', username=username)


@superadmin_required
def admin_doctor_schedule_delete(request, username, schedule_id):
    schedule = get_object_or_404(Doctorschedule, pk=schedule_id, doctor__user__username=username)
    if request.method == 'POST':
        Doctortimeslot.objects.filter(schedule=schedule, slot_date__gte=date.today(), is_booked=0).delete()
        schedule.delete()
        messages.success(request, 'Schedule deleted.')
    return redirect('admin_doctor_schedules', username=username)


# =============================================================================
# Doctor Assistant Management
# =============================================================================
@superadmin_required
def assistant_add(request):
    doctors = Doctor.objects.select_related('user').filter(user__deleted_at__isnull=True)
    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists.')
            return render(request, 'systemadmin/assistant_form.html', {'doctors': doctors})

        user = User.objects.create_user(
            username=username,
            email=request.POST.get('email', '').strip(),
            password=request.POST.get('password', ''),
            first_name=request.POST.get('first_name', '').strip(),
            last_name=request.POST.get('last_name', '').strip(),
            phone=request.POST.get('phone', '').strip() or None,
            role='Doctor_Assistant',
        )
        Doctorassistant.objects.create(
            user=user,
            doctor_id=request.POST.get('doctor'),
            created_at=timezone.now(),
        )
        messages.success(request, f'Assistant {user.get_full_name()} created.')
        return redirect('admin_users')
    return render(request, 'systemadmin/assistant_form.html', {'doctors': doctors})


# =============================================================================
# Reviews
# =============================================================================
@admin_required
def reviews_list(request):
    reviews = Doctorreview.objects.select_related(
        'doctor__user', 'patient', 'appointment__slot'
    ).order_by('-created_at')
    return render(request, 'systemadmin/reviews.html', {'reviews': reviews})


@admin_required
def review_delete(request, pk):
    review = get_object_or_404(Doctorreview, pk=pk)
    if request.method == 'POST':
        review.delete()
        messages.success(request, 'Review deleted.')
    return redirect('admin_reviews')


# =============================================================================
# Measurement Types
# =============================================================================
@superadmin_required
def measurement_types(request):
    types = Measurementtypes.objects.all()
    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'add':
            Measurementtypes.objects.create(
                name=request.POST.get('name', '').strip(),
                unit=request.POST.get('unit', '').strip(),
            )
            messages.success(request, 'Measurement type added.')
        elif action == 'delete':
            Measurementtypes.objects.filter(pk=request.POST.get('type_id')).delete()
            messages.success(request, 'Measurement type deleted.')
        return redirect('admin_measurement_types')
    return render(request, 'systemadmin/measurement_types.html', {'types': types})


# =============================================================================
# Inheritable Diseases
# =============================================================================
@superadmin_required
def inheritable_diseases(request):
    diseases = Inheritablediseases.objects.all()
    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'add':
            Inheritablediseases.objects.create(
                disease_name=request.POST.get('disease_name', '').strip(),
            )
            messages.success(request, 'Disease added.')
        elif action == 'delete':
            Inheritablediseases.objects.filter(pk=request.POST.get('disease_id')).delete()
            messages.success(request, 'Disease deleted.')
        return redirect('admin_inheritable_diseases')
    return render(request, 'systemadmin/inheritable_diseases.html', {'diseases': diseases})
