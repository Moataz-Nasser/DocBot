"""
System Admin views for DocBot.
Handles user management, doctor management, and admin panel.
"""
from datetime import date
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.utils import timezone
from django.db.models import Q, Avg, Count
from django.db import IntegrityError

from core.decorators import admin_required, superadmin_required
from patient.models import User, Patientprofile
from doctor.models import (
    Doctor, Doctorassistant, Doctoraddress, Doctorschedule, Doctortimeslot,
    Prescription, Prescribedmedication,
)
from doctor.views import _generate_slots_for_schedule, _is_schedule_overlapping
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
        email = request.POST.get('email', '').strip()
        password = request.POST.get('password', '')
        first_name = request.POST.get('first_name', '').strip()
        last_name = request.POST.get('last_name', '').strip()
        phone = request.POST.get('phone', '').strip() or None
        specialization = request.POST.get('specialization', '').strip()
        years_of_experience_str = request.POST.get('years_of_experience', '').strip()
        price_str = request.POST.get('price', '').strip()
        follow_up_price_str = request.POST.get('follow_up_price', '').strip()

        if User.objects.filter(username=username).exists():
            messages.error(request, 'Error: Username already exists.')
            return redirect('admin_doctor_add')

        # Validate name fields (no digits)
        if not first_name or any(char.isdigit() for char in first_name):
            messages.error(request, 'Error: First name is required and must contain letters only, no numbers.')
            return redirect('admin_doctor_add')
        if not last_name or any(char.isdigit() for char in last_name):
            messages.error(request, 'Error: Last name is required and must contain letters only, no numbers.')
            return redirect('admin_doctor_add')
        if not specialization or any(char.isdigit() for char in specialization):
            messages.error(request, 'Error: Specialization must contain letters only, no numbers.')
            return redirect('admin_doctor_add')

        # Validate email
        import re
        if not email or not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|org|edu)(?:\.eg)?$', email):
            messages.error(request, 'Error: Please enter a valid email address (e.g. user@domain.com or user@domain.com.eg).')
            return redirect('admin_doctor_add')
        if User.objects.filter(email=email).exists():
            messages.error(request, 'Error: This email is already registered.')
            return redirect('admin_doctor_add')

        # Validate phone: 11-digit Egyptian phone number
        if phone:
            if not re.match(r'^01[0125]\d{8}$', phone):
                messages.error(request, 'Error: Phone number must be a valid 11-digit Egyptian mobile number (e.g. 01012345678).')
                return redirect('admin_doctor_add')

        # Validate numeric fields: strictly positive integers (> 0, no 0, no negatives, no decimals)
        try:
            years_of_experience = int(years_of_experience_str)
            if years_of_experience <= 0:
                messages.error(request, 'Error: Years of experience must be a positive integer greater than zero.')
                return redirect('admin_doctor_add')
        except ValueError:
            messages.error(request, 'Error: Years of experience must be a valid positive integer (no decimals, no letters).')
            return redirect('admin_doctor_add')

        try:
            price = int(price_str)
            if price <= 0:
                messages.error(request, 'Error: Price must be a positive integer greater than zero.')
                return redirect('admin_doctor_add')
        except ValueError:
            messages.error(request, 'Error: Price must be a valid positive integer (no decimals, no letters).')
            return redirect('admin_doctor_add')

        try:
            follow_up_price = int(follow_up_price_str)
            if follow_up_price < 0:
                messages.error(request, 'Error: Follow up price must be a positive integer .')
                return redirect('admin_doctor_add')
        except ValueError:
            messages.error(request, 'Error: Follow up price must be a valid positive integer (no decimals, no letters).')
            return redirect('admin_doctor_add')

        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            phone=phone,
            role='Doctor',
        )
        Doctor.objects.create(
            user=user,
            specialization=specialization,
            years_of_experience=years_of_experience,
            price=price,
            follow_up_price=follow_up_price,
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
        first_name = request.POST.get('first_name', '').strip()
        last_name = request.POST.get('last_name', '').strip()
        email = request.POST.get('email', '').strip()
        phone = request.POST.get('phone', '').strip() or None
        specialization = request.POST.get('specialization', '').strip()
        years_of_experience_str = request.POST.get('years_of_experience', '').strip()
        price_str = request.POST.get('price', '').strip()
        follow_up_price_str = request.POST.get('follow_up_price', '').strip()

        # Validate name fields (no digits)
        if not first_name or any(char.isdigit() for char in first_name):
            messages.error(request, 'Error: First name is required and must contain letters only, no numbers.')
            return redirect('admin_doctor_edit', username=username)
        if not last_name or any(char.isdigit() for char in last_name):
            messages.error(request, 'Error: Last name is required and must contain letters only, no numbers.')
            return redirect('admin_doctor_edit', username=username)
        if not specialization or any(char.isdigit() for char in specialization):
            messages.error(request, 'Error: Specialization must contain letters only, no numbers.')
            return redirect('admin_doctor_edit', username=username)

        # Validate email
        import re
        if not email or not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|org|edu)(?:\.eg)?$', email):
            messages.error(request, 'Error: Please enter a valid email address (e.g. user@domain.com or user@domain.com.eg).')
            return redirect('admin_doctor_edit', username=username)
        if User.objects.filter(email=email).exclude(pk=user.pk).exists():
            messages.error(request, 'Error: This email is already registered.')
            return redirect('admin_doctor_edit', username=username)

        # Validate phone: 11-digit Egyptian phone number
        if phone:
            if not re.match(r'^01[0125]\d{8}$', phone):
                messages.error(request, 'Error: Phone number must be a valid 11-digit Egyptian mobile number (e.g. 01012345678).')
                return redirect('admin_doctor_edit', username=username)

        # Validate numeric fields: strictly positive integers (> 0, no 0, no negatives, no decimals)
        try:
            years_of_experience = int(years_of_experience_str)
            if years_of_experience <= 0:
                messages.error(request, 'Error: Years of experience must be a positive integer greater than zero.')
                return redirect('admin_doctor_edit', username=username)
        except ValueError:
            messages.error(request, 'Error: Years of experience must be a valid positive integer (no decimals, no letters).')
            return redirect('admin_doctor_edit', username=username)

        try:
            price = int(price_str)
            if price <= 0:
                messages.error(request, 'Error: Price must be a positive integer greater than zero.')
                return redirect('admin_doctor_edit', username=username)
        except ValueError:
            messages.error(request, 'Error: Price must be a valid positive integer (no decimals, no letters).')
            return redirect('admin_doctor_edit', username=username)

        try:
            follow_up_price = int(follow_up_price_str)
            if follow_up_price < 0:
                messages.error(request, 'Error: Follow up price must be a positive integer .')
                return redirect('admin_doctor_edit', username=username)
        except ValueError:
            messages.error(request, 'Error: Follow up price must be a valid positive integer (no decimals, no letters).')
            return redirect('admin_doctor_edit', username=username)

        user.first_name = first_name
        user.last_name = last_name
        user.email = email
        user.phone = phone
        user.save()

        doctor.specialization = specialization
        doctor.years_of_experience = years_of_experience
        doctor.price = price
        doctor.follow_up_price = follow_up_price
        
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
        governorate = request.POST.get('governorate', '').strip()
        street = request.POST.get('street', '').strip()
        building_number_str = request.POST.get('building_number', '').strip()
        floor_str = request.POST.get('floor', '').strip()

        # Validate required fields
        if not governorate or not street:
            messages.error(request, 'Error: Governorate and Street are required fields.')
            return redirect('admin_doctor_addresses', username=username)

        # Validate governorate (no digits)
        if any(char.isdigit() for char in governorate):
            messages.error(request, 'Error: Governorate must contain letters only, no numbers.')
            return redirect('admin_doctor_addresses', username=username)

        # Validate and convert building number
        building_number = None
        if building_number_str:
            try:
                building_number = int(building_number_str)
                if building_number <= 0:
                    messages.error(request, 'Error: Building number must be positive.')
                    return redirect('admin_doctor_addresses', username=username)
            except ValueError:
                messages.error(request, 'Error: Building number must be a valid number.')
                return redirect('admin_doctor_addresses', username=username)

        # Validate and convert floor
        floor = None
        if floor_str:
            try:
                floor_val = int(floor_str)
                if floor_val <= 0:
                    messages.error(request, 'Error: Floor must be positive.')
                    return redirect('admin_doctor_addresses', username=username)
                floor = str(floor_val)
            except ValueError:
                messages.error(request, 'Error: Floor must be a valid number.')
                return redirect('admin_doctor_addresses', username=username)

        Doctoraddress.objects.create(
            doctor=doctor,
            floor=floor,
            building_number=building_number,
            street=street,
            governorate=governorate,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Address added.')
    return redirect('admin_doctor_addresses', username=username)


@superadmin_required
def doctor_address_edit(request, username, address_id):
    address = get_object_or_404(Doctoraddress, pk=address_id, doctor__user__username=username)
    if request.method == 'POST':
        governorate = request.POST.get('governorate', '').strip()
        street = request.POST.get('street', '').strip()
        building_number_str = request.POST.get('building_number', '').strip()
        floor_str = request.POST.get('floor', '').strip()

        # Validate required fields
        if not governorate or not street:
            messages.error(request, 'Error: Governorate and Street are required fields.')
            return redirect('admin_doctor_addresses', username=username)

        # Validate governorate (no digits)
        if any(char.isdigit() for char in governorate):
            messages.error(request, 'Error: Governorate must contain letters only, no numbers.')
            return redirect('admin_doctor_addresses', username=username)

        # Validate and convert building number
        building_number = None
        if building_number_str:
            try:
                building_number = int(building_number_str)
                if building_number <= 0:
                    messages.error(request, 'Error: Building number must be positive.')
                    return redirect('admin_doctor_addresses', username=username)
            except ValueError:
                messages.error(request, 'Error: Building number must be a valid number.')
                return redirect('admin_doctor_addresses', username=username)

        # Validate and convert floor
        floor = None
        if floor_str:
            try:
                floor_val = int(floor_str)
                if floor_val <= 0:
                    messages.error(request, 'Error: Floor must be positive.')
                    return redirect('admin_doctor_addresses', username=username)
                floor = str(floor_val)
            except ValueError:
                messages.error(request, 'Error: Floor must be a valid number.')
                return redirect('admin_doctor_addresses', username=username)

        address.floor = floor
        address.building_number = building_number
        address.street = street
        address.governorate = governorate
        address.updated_at = timezone.now()
        address.save()
        messages.success(request, 'Address updated.')
    return redirect('admin_doctor_addresses', username=username)


@superadmin_required
def doctor_address_delete(request, username, address_id):
    address = get_object_or_404(Doctoraddress, pk=address_id, doctor__user__username=username)
    if request.method == 'POST':
        # Safely prevent deleting an address that is currently used in one or more active doctor schedules
        if Doctorschedule.objects.filter(doctor_address=address).exists():
            messages.error(request, 'Error: Cannot delete this address because it is associated with one or more schedules.')
            return redirect('admin_doctor_addresses', username=username)

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
        doctor_address_id = request.POST.get('doctor_address')
        day_of_week = request.POST.get('day_of_week')
        start_time_str = request.POST.get('start_time')
        end_time_str = request.POST.get('end_time')
        slot_duration_str = request.POST.get('slot_duration', '30')

        # Validate required fields
        if not doctor_address_id or not day_of_week or not start_time_str or not end_time_str:
            messages.error(request, 'Error: All fields are required to add a schedule.')
            return redirect('admin_doctor_schedules', username=username)

        # Verify address belongs to doctor
        address = get_object_or_404(Doctoraddress, pk=doctor_address_id, doctor=doctor)

        # Validate times (must start from 10:00 AM onwards)
        if start_time_str < "10:00":
            messages.error(request, 'Error: Appointments must start from 10:00 AM onwards.')
            return redirect('admin_doctor_schedules', username=username)

        if start_time_str >= end_time_str:
            messages.error(request, 'Error: End time must be after start time.')
            return redirect('admin_doctor_schedules', username=username)

        # Overlap check
        if _is_schedule_overlapping(doctor, day_of_week, start_time_str, end_time_str):
            messages.error(request, 'Error: This schedule overlaps with an existing one on the same day.')
            return redirect('admin_doctor_schedules', username=username)

        try:
            slot_duration = int(slot_duration_str)
            if slot_duration <= 0:
                raise ValueError
        except ValueError:
            messages.error(request, 'Error: Invalid slot duration.')
            return redirect('admin_doctor_schedules', username=username)

        schedule = Doctorschedule.objects.create(
            doctor=doctor,
            doctor_address=address,
            day_of_week=day_of_week,
            start_time=start_time_str,
            end_time=end_time_str,
            slot_duration=slot_duration,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        _generate_slots_for_schedule(schedule)
        messages.success(request, 'Schedule added and slots generated.')
    return redirect('admin_doctor_schedules', username=username)


@superadmin_required
def admin_doctor_schedule_delete(request, username, schedule_id):
    schedule = get_object_or_404(Doctorschedule, pk=schedule_id, doctor__user__username=username)
    if request.method == 'POST':
        # Delete future unbooked slots
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
        first_name = request.POST.get('first_name', '').strip()
        last_name = request.POST.get('last_name', '').strip()
        email = request.POST.get('email', '').strip()
        phone = request.POST.get('phone', '').strip() or None
        doctor_id = request.POST.get('doctor')

        if User.objects.filter(username=username).exists():
            messages.error(request, 'Error: Username already exists.')
            return redirect('admin_assistant_add')

        # Validate name fields (no digits)
        if not first_name or any(char.isdigit() for char in first_name):
            messages.error(request, 'Error: First name is required and must contain letters only, no numbers.')
            return redirect('admin_assistant_add')
        if not last_name or any(char.isdigit() for char in last_name):
            messages.error(request, 'Error: Last name is required and must contain letters only, no numbers.')
            return redirect('admin_assistant_add')

        # Validate email
        import re
        if not email or not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|org|edu)(?:\.eg)?$', email):
            messages.error(request, 'Error: Please enter a valid email address (e.g. user@domain.com or user@domain.com.eg).')
            return redirect('admin_assistant_add')
        if User.objects.filter(email=email).exists():
            messages.error(request, 'Error: This email is already registered.')
            return redirect('admin_assistant_add')

        # Validate phone: 11-digit Egyptian phone number
        if phone:
            if not re.match(r'^01[0125]\d{8}$', phone):
                messages.error(request, 'Error: Phone number must be a valid 11-digit Egyptian mobile number (e.g. 01012345678).')
                return redirect('admin_assistant_add')

        if not doctor_id:
            messages.error(request, 'Error: Doctor is required.')
            return redirect('admin_assistant_add')

        user = User.objects.create_user(
            username=username,
            email=email,
            password=request.POST.get('password', ''),
            first_name=first_name,
            last_name=last_name,
            phone=phone,
            role='Doctor_Assistant',
        )
        Doctorassistant.objects.create(
            user=user,
            doctor_id=doctor_id,
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
            name = request.POST.get('name', '').strip()
            unit = request.POST.get('unit', '').strip()

            if not name or any(char.isdigit() for char in name):
                messages.error(request, 'Error: Measurement type name is required and must contain letters only, no numbers.')
                return redirect('admin_measurement_types')

            if not unit or any(char.isdigit() for char in unit):
                messages.error(request, 'Error: Unit must contain letters only, no numbers.')
                return redirect('admin_measurement_types')

            Measurementtypes.objects.create(
                name=name,
                unit=unit,
            )
            messages.success(request, 'Measurement type added.')
        elif action == 'delete':
            try:
                Measurementtypes.objects.filter(pk=request.POST.get('type_id')).delete()
                messages.success(request, 'Measurement type deleted.')
            except IntegrityError:
                messages.error(request, 'This measurement type cannot be deleted because it is linked to existing patient records.')
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
            disease_name = request.POST.get('disease_name', '').strip()

            if not disease_name or any(char.isdigit() for char in disease_name):
                messages.error(request, 'Error: Disease name is required and must contain letters only, no numbers.')
                return redirect('admin_inheritable_diseases')

            Inheritablediseases.objects.create(
                disease_name=disease_name,
            )
            messages.success(request, 'Disease added.')
        elif action == 'delete':
            Inheritablediseases.objects.filter(pk=request.POST.get('disease_id')).delete()
            messages.success(request, 'Disease deleted.')
        return redirect('admin_inheritable_diseases')
    return render(request, 'systemadmin/inheritable_diseases.html', {'diseases': diseases})
