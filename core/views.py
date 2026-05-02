"""
Core views for static pages and guest-accessible pages.
"""
from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.db.models import Avg, Count, Q
from doctor.models import Doctor, Doctoraddress, Doctorschedule, Doctortimeslot
from appointment.models import Doctorreview
from datetime import date


def home(request):
    return render(request, 'core/index.html')


def about(request):
    return render(request, 'core/about.html')


def contact(request):
    return render(request, 'core/contact.html')


def how_it_works(request):
    return render(request, 'core/how_it_works.html')


def services(request):
    return render(request, 'core/services.html')


def why_choose_us(request):
    return render(request, 'core/why_choose_us.html')


@login_required
def chatbot_page(request):
    """Chatbot page - requires login, not doctor or assistant."""
    if request.user.role in ('Doctor', 'Doctor_Assistant'):
        return render(request, 'core/403.html', status=403)
    return render(request, 'core/chatbot.html')


def doctor_listing(request):
    """Public doctor listing with filters."""
    doctors = Doctor.objects.select_related('user').filter(
        user__deleted_at__isnull=True,
        user__is_active=True,
    )

    # Get filter values
    specialization = request.GET.get('specialization', '')
    governorate = request.GET.get('governorate', '')
    min_price = request.GET.get('min_price', '')
    max_price = request.GET.get('max_price', '')

    if specialization:
        doctors = doctors.filter(specialization__icontains=specialization)
    if governorate:
        doctor_ids = Doctoraddress.objects.filter(
            governorate__icontains=governorate
        ).values_list('doctor_id', flat=True)
        doctors = doctors.filter(user_id__in=doctor_ids)
    if min_price:
        try:
            doctors = doctors.filter(price__gte=float(min_price))
        except ValueError:
            pass
    if max_price:
        try:
            doctors = doctors.filter(price__lte=float(max_price))
        except ValueError:
            pass

    # Annotate with average rating
    doctors = doctors.annotate(
        avg_rating=Avg('doctorreview__rating'),
        review_count=Count('doctorreview'),
    )

    # Get unique specializations and governorates for filter dropdowns
    all_specializations = Doctor.objects.values_list(
        'specialization', flat=True
    ).distinct().order_by('specialization')
    all_governorates = Doctoraddress.objects.values_list(
        'governorate', flat=True
    ).distinct().order_by('governorate')

    context = {
        'doctors': doctors,
        'specializations': all_specializations,
        'governorates': all_governorates,
        'current_specialization': specialization,
        'current_governorate': governorate,
        'current_min_price': min_price,
        'current_max_price': max_price,
    }
    return render(request, 'core/doctor_listing.html', context)


def doctor_public_profile(request, doctor_id):
    """Public doctor profile page."""
    doctor = get_object_or_404(
        Doctor.objects.select_related('user'),
        user_id=doctor_id,
        user__deleted_at__isnull=True,
    )
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    schedules = Doctorschedule.objects.filter(doctor=doctor).select_related('doctor_address')
    reviews = Doctorreview.objects.filter(doctor=doctor).select_related('patient')
    avg_rating = reviews.aggregate(avg=Avg('rating'))['avg']

    # Available time slots (future, not booked, available)
    available_slots = Doctortimeslot.objects.filter(
        schedule__doctor=doctor,
        slot_date__gte=date.today(),
        is_booked=0,
        is_available=1,
    ).select_related('schedule', 'schedule__doctor_address').order_by('slot_date', 'start_time')[:20]

    context = {
        'doctor': doctor,
        'addresses': addresses,
        'schedules': schedules,
        'reviews': reviews,
        'avg_rating': avg_rating,
        'review_count': reviews.count(),
        'available_slots': available_slots,
    }
    return render(request, 'core/doctor_profile.html', context)
