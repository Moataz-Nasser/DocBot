"""
Doctor views for DocBot.
Includes Doctor views and Doctor Assistant views.
"""
from datetime import date, timedelta, datetime
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.utils import timezone
from django.db.models import Q, Avg, Count

from core.decorators import doctor_required, assistant_required, doctor_or_assistant_required
from config.constants import DOCTOR_PATIENT_ACCESS_DAYS, SLOT_GENERATION_WEEKS
from patient.models import (
    User, Patientprofile, Allergies, Chronicdiseases, Currentmedications,
    Diagnosis, Familyhistory, Formersurgeries, Labtests, Medicalscans,
    Vitalmeasurements,
)
from doctor.models import (
    Doctor, Doctorassistant, Doctoraddress, Doctorschedule, Doctortimeslot,
    Prescription, Prescribedmedication,
)
from appointment.models import Doctorappointment, Appointmentnote, Appointmentsymptoms, Doctorreview
from notification.utils import (
    notify_appointment_status_changed, notify_prescription_created,
    notify_diagnosis_created, notify_followup_allowed,
)
from systemadmin.models import Measurementtypes
import cloudinary.uploader


def _generate_slots_for_schedule(schedule):
    """Generate time slots for a schedule for the next N weeks."""
    today = date.today()
    end_date = today + timedelta(weeks=SLOT_GENERATION_WEEKS)

    day_map = {
        'Monday': 0, 'Tuesday': 1, 'Wednesday': 2, 'Thursday': 3,
        'Friday': 4, 'Saturday': 5, 'Sunday': 6,
    }
    target_weekday = day_map.get(schedule.day_of_week)
    if target_weekday is None:
        return

    current = today
    # Move to the next occurrence of the target weekday
    days_ahead = target_weekday - current.weekday()
    if days_ahead < 0:
        days_ahead += 7
    current = current + timedelta(days=days_ahead)

    while current <= end_date:
        # Generate slots for this date
        slot_start = datetime.combine(current, schedule.start_time)
        slot_end_limit = datetime.combine(current, schedule.end_time)
        duration = timedelta(minutes=schedule.slot_duration)

        while slot_start + duration <= slot_end_limit:
            slot_end = slot_start + duration
            # Skip if already exists
            if not Doctortimeslot.objects.filter(
                schedule=schedule,
                slot_date=current,
                start_time=slot_start.time(),
            ).exists():
                Doctortimeslot.objects.create(
                    schedule=schedule,
                    slot_date=current,
                    start_time=slot_start.time(),
                    end_time=slot_end.time(),
                    is_booked=0,
                    is_available=1,
                    created_at=timezone.now(),
                    updated_at=timezone.now(),
                )
            slot_start = slot_end

        current += timedelta(weeks=1)


def _auto_update_missed_appointments():
    today = date.today()
    past_appointments = Doctorappointment.objects.filter(
        status='Booked',
        slot__slot_date__lt=today
    )
    if past_appointments.exists():
        past_appointments.update(status='No-show', updated_at=timezone.now())


# =============================================================================
# Doctor Dashboard
# =============================================================================
@doctor_required
def dashboard(request):
    _auto_update_missed_appointments()
    doctor = Doctor.objects.get(user=request.user)
    today_appointments = Doctorappointment.objects.filter(
        doctor=doctor,
        slot__slot_date=date.today(),
    ).select_related('patient', 'slot', 'doctor_address').order_by('slot__start_time')

    upcoming = Doctorappointment.objects.filter(
        doctor=doctor, status='Booked',
        slot__slot_date__gte=date.today(),
    ).select_related('patient', 'slot').order_by('slot__slot_date')[:5]

    stats = Doctorappointment.objects.filter(doctor=doctor).aggregate(
        total=Count('id'),
        completed=Count('id', filter=Q(status='Completed')),
        booked=Count('id', filter=Q(status='Booked')),
    )

    avg_rating = Doctorreview.objects.filter(doctor=doctor).aggregate(avg=Avg('rating'))['avg']

    context = {
        'doctor': doctor,
        'today_appointments': today_appointments,
        'upcoming_appointments': upcoming,
        'stats': stats,
        'avg_rating': avg_rating,
    }
    return render(request, 'doctor/dashboard.html', context)


# =============================================================================
# Doctor Profile
# =============================================================================
@doctor_required
def doctor_profile(request):
    doctor = Doctor.objects.select_related('user').get(user=request.user)
    if request.method == 'POST':
        if 'image' in request.FILES:
            upload = cloudinary.uploader.upload(request.FILES['image'])
            doctor.image = upload['secure_url']
            doctor.updated_at = timezone.now()
            doctor.save()
            messages.success(request, 'Profile picture updated successfully.')
            return redirect('doctor_profile')
        elif 'remove_image' in request.POST:
            doctor.image = None
            doctor.updated_at = timezone.now()
            doctor.save()
            messages.success(request, 'Profile picture removed.')
            return redirect('doctor_profile')

    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/profile.html', {'doctor': doctor, 'addresses': addresses})


@doctor_required
def edit_price(request):
    doctor = Doctor.objects.get(user=request.user)
    if request.method == 'POST':
        doctor.price = float(request.POST.get('price', doctor.price))
        doctor.follow_up_price = float(request.POST.get('follow_up_price', doctor.follow_up_price))
        doctor.updated_at = timezone.now()
        doctor.save()
        messages.success(request, 'Prices updated successfully.')
        return redirect('doctor_profile')
    return render(request, 'doctor/edit_price.html', {'doctor': doctor})


# =============================================================================
# Schedule Management
# =============================================================================
@doctor_required
def schedules_list(request):
    doctor = Doctor.objects.get(user=request.user)
    schedules = Doctorschedule.objects.filter(doctor=doctor).select_related('doctor_address')
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/schedules.html', {
        'schedules': schedules, 'addresses': addresses,
    })


@doctor_required
def schedule_add(request):
    doctor = Doctor.objects.get(user=request.user)
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
        messages.success(request, f'Schedule added. Time slots generated for the next {SLOT_GENERATION_WEEKS} weeks.')
        return redirect('doctor_schedules')
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/schedule_form.html', {'addresses': addresses})


@doctor_required
def schedule_edit(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    schedule = get_object_or_404(Doctorschedule, pk=pk, doctor=doctor)
    if request.method == 'POST':
        schedule.doctor_address_id = request.POST.get('doctor_address')
        schedule.day_of_week = request.POST.get('day_of_week')
        schedule.start_time = request.POST.get('start_time')
        schedule.end_time = request.POST.get('end_time')
        schedule.slot_duration = int(request.POST.get('slot_duration', 30))
        schedule.updated_at = timezone.now()
        schedule.save()
        # Regenerate future unbooked slots
        Doctortimeslot.objects.filter(
            schedule=schedule, slot_date__gte=date.today(), is_booked=0
        ).delete()
        _generate_slots_for_schedule(schedule)
        messages.success(request, 'Schedule updated and slots regenerated.')
        return redirect('doctor_schedules')
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/schedule_form.html', {'schedule': schedule, 'addresses': addresses})


@doctor_required
def schedule_delete(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    schedule = get_object_or_404(Doctorschedule, pk=pk, doctor=doctor)
    if request.method == 'POST':
        # Delete future unbooked slots
        Doctortimeslot.objects.filter(
            schedule=schedule, slot_date__gte=date.today(), is_booked=0
        ).delete()
        schedule.delete()
        messages.success(request, 'Schedule deleted.')
    return redirect('doctor_schedules')


# =============================================================================
# Doctor Appointments
# =============================================================================
@doctor_required
def appointments_list(request):
    _auto_update_missed_appointments()
    doctor = Doctor.objects.get(user=request.user)
    status_filter = request.GET.get('status', '')
    date_filter = request.GET.get('date', '')

    appointments = Doctorappointment.objects.filter(
        doctor=doctor
    ).select_related('patient', 'slot', 'doctor_address').order_by('-slot__slot_date', '-slot__start_time')

    if status_filter:
        appointments = appointments.filter(status=status_filter)
    if date_filter:
        appointments = appointments.filter(slot__slot_date=date_filter)

    return render(request, 'doctor/appointments.html', {
        'appointments': appointments,
        'current_status': status_filter,
        'current_date': date_filter,
    })


@doctor_required
def appointment_detail(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(
        Doctorappointment.objects.select_related('patient', 'slot', 'doctor_address'),
        pk=pk, doctor=doctor
    )

    context = {
        'appointment': appointment,
        'symptoms': [],
        'notes': [],
        'prescriptions': [],
        'diagnoses': [],
        'patient_profile': None,
        'can_view_medical': False,
        'can_edit_clinical': False,
    }

    try:
        context['patient_profile'] = Patientprofile.objects.get(user=appointment.patient)
    except Patientprofile.DoesNotExist:
        pass

    # Status-dependent data access
    if appointment.status == 'Booked':
        context['symptoms'] = Appointmentsymptoms.objects.filter(appointment=appointment)

    elif appointment.status == 'In progress':
        context['can_view_medical'] = True
        context['can_edit_clinical'] = True
        context['symptoms'] = Appointmentsymptoms.objects.filter(appointment=appointment)
        context['notes'] = Appointmentnote.objects.filter(appointment=appointment)
        context['prescriptions'] = Prescription.objects.filter(appointment=appointment)
        for p in context['prescriptions']:
            p.medications = Prescribedmedication.objects.filter(prescription=p)
        context['diagnoses'] = Diagnosis.objects.filter(appointment=appointment)
        # Full medical record
        patient = appointment.patient
        context['allergies'] = Allergies.objects.filter(patient=patient)
        context['chronic_diseases'] = Chronicdiseases.objects.filter(patient=patient)
        context['current_medications'] = Currentmedications.objects.filter(patient=patient)
        context['surgeries'] = Formersurgeries.objects.filter(patient=patient)
        context['family_history'] = Familyhistory.objects.filter(patient=patient).select_related('disease')
        context['lab_tests'] = Labtests.objects.filter(patient=patient).order_by('-date')[:10]
        context['scans'] = Medicalscans.objects.filter(patient=patient).order_by('-date')[:10]
        context['vitals'] = Vitalmeasurements.objects.filter(patient=patient).select_related('measurement_type').order_by('-date')[:10]

    elif appointment.status == 'Completed':
        days_since = (date.today() - appointment.slot.slot_date).days
        if days_since <= DOCTOR_PATIENT_ACCESS_DAYS:
            context['notes'] = Appointmentnote.objects.filter(appointment=appointment)
            context['prescriptions'] = Prescription.objects.filter(appointment=appointment)
            for p in context['prescriptions']:
                p.medications = Prescribedmedication.objects.filter(prescription=p)
            context['diagnoses'] = Diagnosis.objects.filter(appointment=appointment)

    return render(request, 'doctor/appointment_detail.html', context)


# =============================================================================
# Appointment Actions
# =============================================================================
@doctor_required
def appointment_start(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='Booked')
    if request.method == 'POST':
        if appointment.slot.slot_date != date.today():
            messages.error(request, 'You can only start an appointment on its scheduled day.')
            return redirect('doctor_appointment_detail', pk=pk)

        appointment.status = 'In progress'
        appointment.updated_at = timezone.now()
        appointment.save()
        notify_appointment_status_changed(appointment, 'In progress')
        messages.success(request, 'Appointment started.')
    return redirect('doctor_appointment_detail', pk=pk)


@doctor_required
def appointment_complete(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='In progress')
    if request.method == 'POST':
        appointment.status = 'Completed'
        appointment.updated_at = timezone.now()
        appointment.save()
        notify_appointment_status_changed(appointment, 'Completed')
        messages.success(request, 'Appointment completed.')
    return redirect('doctor_appointment_detail', pk=pk)


@doctor_required
def appointment_cancel(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='Booked')
    if request.method == 'POST':
        appointment.status = 'Canceled'
        appointment.canceled_by = request.user
        appointment.updated_at = timezone.now()
        appointment.save()
        slot = appointment.slot
        slot.is_booked = 0
        slot.updated_at = timezone.now()
        slot.save()
        notify_appointment_status_changed(appointment, 'Canceled')
        messages.success(request, 'Appointment canceled.')
    return redirect('doctor_appointments')


@doctor_required
def appointment_noshow(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='Booked')
    if request.method == 'POST':
        appointment.status = 'No-show'
        appointment.updated_at = timezone.now()
        appointment.save()
        notify_appointment_status_changed(appointment, 'No-show')
        messages.success(request, 'Patient marked as no-show.')
    return redirect('doctor_appointment_detail', pk=pk)


@doctor_required
def allow_followup(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor)
    if request.method == 'POST' and appointment.status in ('In progress', 'Completed'):
        appointment.follow_up_allowed = 1
        appointment.updated_at = timezone.now()
        appointment.save()
        notify_followup_allowed(appointment)
        messages.success(request, 'Follow-up allowed for this patient.')
    return redirect('doctor_appointment_detail', pk=pk)


# =============================================================================
# Notes CRUD
# =============================================================================
@doctor_required
def notes_manage(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='In progress')

    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'add':
            Appointmentnote.objects.create(
                appointment=appointment, doctor=doctor,
                note=request.POST.get('note', '').strip(),
                created_at=timezone.now(), updated_at=timezone.now()
            )
            messages.success(request, 'Note added.')
        elif action == 'edit':
            note = get_object_or_404(Appointmentnote, pk=request.POST.get('note_id'), doctor=doctor)
            note.note = request.POST.get('note', '').strip()
            note.updated_at = timezone.now()
            note.save()
            messages.success(request, 'Note updated.')
        elif action == 'delete':
            Appointmentnote.objects.filter(pk=request.POST.get('note_id'), doctor=doctor).delete()
            messages.success(request, 'Note deleted.')

    return redirect('doctor_appointment_detail', pk=pk)


# =============================================================================
# Prescription CRUD
# =============================================================================
@doctor_required
def prescription_manage(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='In progress')

    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'create_prescription':
            prescription = Prescription.objects.create(
                patient=appointment.patient,
                doctor=doctor,
                appointment=appointment,
                date=date.today(),
                created_at=timezone.now(), updated_at=timezone.now()
            )
            notify_prescription_created(appointment.patient, doctor, prescription)
            messages.success(request, 'Prescription created. Add medications below.')
            return redirect('doctor_prescription_detail', pk=pk, prescription_id=prescription.id)

    prescriptions = Prescription.objects.filter(appointment=appointment)
    return render(request, 'doctor/prescriptions.html', {
        'appointment': appointment, 'prescriptions': prescriptions,
    })


@doctor_required
def prescription_detail(request, pk, prescription_id):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor)
    prescription = get_object_or_404(Prescription, pk=prescription_id, doctor=doctor)
    medications = Prescribedmedication.objects.filter(prescription=prescription)

    if request.method == 'POST' and appointment.status == 'In progress':
        action = request.POST.get('action')
        if action == 'add_medication':
            med = Prescribedmedication.objects.create(
                prescription=prescription,
                medication_name=request.POST.get('medication_name', '').strip(),
                dose=request.POST.get('dose', '').strip() or None,
                period=int(request.POST.get('period', 0)),
                dosage_strength=request.POST.get('dosage_strength', '').strip() or None,
                note=request.POST.get('note', '').strip() or None,
                created_at=timezone.now(), updated_at=timezone.now()
            )
            
            # Auto-create reminder
            from notification.models import Medicationreminder, Remindertimes
            from datetime import time
            
            reminder = Medicationreminder.objects.create(
                patient=appointment.patient,
                prescription=prescription,
                medication_name=med.medication_name,
                start_date=date.today(),
                end_date=date.today() + timedelta(days=med.period),
                repeat_interval_days=1,
                note=med.note,
                is_active=1,
                created_at=timezone.now(),
                updated_at=timezone.now()
            )
            
            # Basic dose parsing for reminder times
            dose_str = (med.dose or "").lower()
            times_to_add = [time(9, 0)] # Default
            if "3 times" in dose_str or "8 hours" in dose_str:
                times_to_add = [time(8, 0), time(14, 0), time(22, 0)]
            elif "2 times" in dose_str or "12 hours" in dose_str:
                times_to_add = [time(9, 0), time(21, 0)]
            
            for t in times_to_add:
                Remindertimes.objects.create(reminder=reminder, time=t)

            messages.success(request, 'Medication added and reminders set.')
        elif action == 'delete_medication':
            med_name = request.POST.get('medication_name')
            Prescribedmedication.objects.filter(
                prescription=prescription,
                medication_name=med_name,
            ).delete()
            # Also delete associated reminders
            from notification.models import Medicationreminder
            Medicationreminder.objects.filter(prescription=prescription, medication_name=med_name).delete()
            messages.success(request, 'Medication and associated reminders removed.')
        return redirect('doctor_prescription_detail', pk=pk, prescription_id=prescription_id)

    return render(request, 'doctor/prescription_detail.html', {
        'appointment': appointment, 'prescription': prescription, 'medications': medications,
    })


# =============================================================================
# Diagnosis CRUD (Doctor)
# =============================================================================
@doctor_required
def diagnosis_manage(request, pk):
    doctor = Doctor.objects.get(user=request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='In progress')

    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'add':
            Diagnosis.objects.create(
                patient=appointment.patient,
                diagnosis_name=request.POST.get('diagnosis_name', '').strip(),
                doctor_name=request.user.get_full_name(),
                date=date.today(),
                created_by=request.user,
                appointment=appointment,
                created_at=timezone.now(), updated_at=timezone.now()
            )
            diag = Diagnosis.objects.filter(appointment=appointment).last()
            notify_diagnosis_created(appointment.patient, doctor, diag)
            messages.success(request, 'Diagnosis added.')
        elif action == 'delete':
            Diagnosis.objects.filter(
                pk=request.POST.get('diagnosis_id'),
                appointment=appointment,
                created_by=request.user,
            ).delete()
            messages.success(request, 'Diagnosis removed.')

    return redirect('doctor_appointment_detail', pk=pk)


# =============================================================================
# Reviews (Doctor - read only)
# =============================================================================
@doctor_required
def reviews_list(request):
    doctor = Doctor.objects.get(user=request.user)
    reviews = Doctorreview.objects.filter(doctor=doctor).select_related('patient', 'appointment__slot')
    avg_rating = reviews.aggregate(avg=Avg('rating'))['avg']
    return render(request, 'doctor/reviews.html', {
        'reviews': reviews, 'avg_rating': avg_rating,
    })


# =============================================================================
# DOCTOR ASSISTANT VIEWS
# =============================================================================
def _get_assistant_doctor(user):
    """Get the doctor that this assistant is assigned to."""
    assistant = get_object_or_404(Doctorassistant, user=user)
    return assistant.doctor


@assistant_required
def assistant_dashboard(request):
    doctor = _get_assistant_doctor(request.user)
    today_appointments = Doctorappointment.objects.filter(
        doctor=doctor,
        slot__slot_date=date.today(),
    ).select_related('patient', 'slot', 'doctor_address').order_by('slot__start_time')

    upcoming = Doctorappointment.objects.filter(
        doctor=doctor, status='Booked',
        slot__slot_date__gte=date.today(),
    ).count()

    context = {
        'doctor': doctor,
        'today_appointments': today_appointments,
        'upcoming_count': upcoming,
    }
    return render(request, 'doctor/assistant_dashboard.html', context)


@assistant_required
def assistant_doctor_profile(request):
    doctor = _get_assistant_doctor(request.user)
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/assistant_doctor_profile.html', {'doctor': doctor, 'addresses': addresses})


@assistant_required
def assistant_edit_price(request):
    doctor = _get_assistant_doctor(request.user)
    if request.method == 'POST':
        doctor.price = float(request.POST.get('price', doctor.price))
        doctor.follow_up_price = float(request.POST.get('follow_up_price', doctor.follow_up_price))
        doctor.updated_at = timezone.now()
        doctor.save()
        messages.success(request, "Doctor's prices updated.")
        return redirect('assistant_doctor_profile')
    return render(request, 'doctor/edit_price.html', {'doctor': doctor, 'is_assistant': True})


@assistant_required
def assistant_schedules(request):
    doctor = _get_assistant_doctor(request.user)
    schedules = Doctorschedule.objects.filter(doctor=doctor).select_related('doctor_address')
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/schedules.html', {
        'schedules': schedules, 'addresses': addresses, 'is_assistant': True,
    })


@assistant_required
def assistant_schedule_add(request):
    doctor = _get_assistant_doctor(request.user)
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
        return redirect('assistant_schedules')
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/schedule_form.html', {'addresses': addresses, 'is_assistant': True})


@assistant_required
def assistant_schedule_edit(request, pk):
    doctor = _get_assistant_doctor(request.user)
    schedule = get_object_or_404(Doctorschedule, pk=pk, doctor=doctor)
    if request.method == 'POST':
        schedule.doctor_address_id = request.POST.get('doctor_address')
        schedule.day_of_week = request.POST.get('day_of_week')
        schedule.start_time = request.POST.get('start_time')
        schedule.end_time = request.POST.get('end_time')
        schedule.slot_duration = int(request.POST.get('slot_duration', 30))
        schedule.updated_at = timezone.now()
        schedule.save()
        Doctortimeslot.objects.filter(schedule=schedule, slot_date__gte=date.today(), is_booked=0).delete()
        _generate_slots_for_schedule(schedule)
        messages.success(request, 'Schedule updated.')
        return redirect('assistant_schedules')
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    return render(request, 'doctor/schedule_form.html', {'schedule': schedule, 'addresses': addresses, 'is_assistant': True})


@assistant_required
def assistant_schedule_delete(request, pk):
    doctor = _get_assistant_doctor(request.user)
    schedule = get_object_or_404(Doctorschedule, pk=pk, doctor=doctor)
    if request.method == 'POST':
        Doctortimeslot.objects.filter(schedule=schedule, slot_date__gte=date.today(), is_booked=0).delete()
        schedule.delete()
        messages.success(request, 'Schedule deleted.')
    return redirect('assistant_schedules')


@assistant_required
def assistant_appointments(request):
    doctor = _get_assistant_doctor(request.user)
    status_filter = request.GET.get('status', '')
    appointments = Doctorappointment.objects.filter(
        doctor=doctor
    ).select_related('patient', 'slot', 'doctor_address').order_by('-slot__slot_date')

    if status_filter:
        appointments = appointments.filter(status=status_filter)

    return render(request, 'doctor/assistant_appointments.html', {
        'appointments': appointments, 'current_status': status_filter,
    })


@assistant_required
def assistant_appointment_detail(request, pk):
    doctor = _get_assistant_doctor(request.user)
    appointment = get_object_or_404(
        Doctorappointment.objects.select_related('patient', 'slot', 'doctor_address'),
        pk=pk, doctor=doctor
    )
    # Assistant only sees basic patient contact info
    return render(request, 'doctor/assistant_appointment_detail.html', {'appointment': appointment})


@assistant_required
def assistant_cancel_appointment(request, pk):
    doctor = _get_assistant_doctor(request.user)
    appointment = get_object_or_404(Doctorappointment, pk=pk, doctor=doctor, status='Booked')
    if request.method == 'POST':
        appointment.status = 'Canceled'
        appointment.canceled_by = request.user
        appointment.updated_at = timezone.now()
        appointment.save()
        slot = appointment.slot
        slot.is_booked = 0
        slot.updated_at = timezone.now()
        slot.save()
        notify_appointment_status_changed(appointment, 'Canceled')
        messages.success(request, 'Appointment canceled.')
    return redirect('assistant_appointments')
