"""
Patient views for DocBot.
All views require login + Patient role.
"""
from datetime import date, timedelta
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from django.db.models import Q
import cloudinary.uploader

from core.decorators import patient_required
from config.constants import FOLLOWUP_BOOKING_WINDOW_DAYS
from patient.models import (
    User, Patientprofile, Allergies, Chronicdiseases, Currentmedications,
    Diagnosis, Familyhistory, Formersurgeries, Labtests, Medicalscans,
    Vitalmeasurements,
)
from doctor.models import Doctor, Doctoraddress, Doctortimeslot, Prescription, Prescribedmedication
from appointment.models import Doctorappointment, Appointmentnote, Appointmentsymptoms, Doctorreview
from notification.models import Notification, Medicationreminder, Remindertimes
from notification.utils import notify_appointment_booked
from systemadmin.models import Measurementtypes, Inheritablediseases


def _auto_update_missed_appointments():
    today = date.today()
    past_appointments = Doctorappointment.objects.filter(
        status='Booked',
        slot__slot_date__lt=today
    )
    if past_appointments.exists():
        past_appointments.update(status='No-show', updated_at=timezone.now())

# =============================================================================
# Dashboard
# =============================================================================
@patient_required
def dashboard(request):
    _auto_update_missed_appointments()
    user = request.user
    upcoming = Doctorappointment.objects.filter(
        patient=user,
        status='Booked',
        slot__slot_date__gte=date.today(),
    ).select_related('doctor__user', 'slot', 'doctor_address').order_by('slot__slot_date', 'slot__start_time')[:5]

    recent_prescriptions = Prescription.objects.filter(
        patient=user,
    ).select_related('doctor__user').order_by('-date')[:5]

    recent_notifications = Notification.objects.filter(
        user=user,
    ).order_by('-created_at')[:5]

    total_appointments = Doctorappointment.objects.filter(patient=user).count()
    completed = Doctorappointment.objects.filter(patient=user, status='Completed').count()

    context = {
        'upcoming_appointments': upcoming,
        'recent_prescriptions': recent_prescriptions,
        'recent_notifications': recent_notifications,
        'total_appointments': total_appointments,
        'completed_appointments': completed,
    }
    return render(request, 'patient/dashboard.html', context)


# =============================================================================
# Profile
# =============================================================================
@patient_required
def profile_view(request):
    profile, _ = Patientprofile.objects.get_or_create(
        user=request.user,
        defaults={'created_at': timezone.now(), 'updated_at': timezone.now()}
    )
    return render(request, 'patient/profile.html', {'profile': profile})


@patient_required
def profile_edit(request):
    user = request.user
    profile, _ = Patientprofile.objects.get_or_create(
        user=user,
        defaults={'created_at': timezone.now(), 'updated_at': timezone.now()}
    )

    if request.method == 'POST':
        user.first_name = request.POST.get('first_name', user.first_name).strip()
        user.last_name = request.POST.get('last_name', user.last_name).strip()
        user.email = request.POST.get('email', user.email).strip()
        user.phone = request.POST.get('phone', user.phone or '').strip() or None
        user.save()

        new_password = request.POST.get('new_password', '')
        if new_password:
            if len(new_password) < 6:
                messages.error(request, 'Password must be at least 6 characters.')
                return redirect('patient_profile_edit')
            user.set_password(new_password)
            user.save()
            messages.success(request, 'Password updated. Please log in again.')
            return redirect('login')

        messages.success(request, 'Profile updated successfully.')
        return redirect('patient_profile')

    return render(request, 'patient/profile_edit.html', {'profile': profile})


# =============================================================================
# Medical Profile
# =============================================================================
@patient_required
def medical_profile(request):
    user = request.user
    profile, _ = Patientprofile.objects.get_or_create(
        user=user,
        defaults={'created_at': timezone.now(), 'updated_at': timezone.now()}
    )
    allergies = Allergies.objects.filter(patient=user)
    chronic = Chronicdiseases.objects.filter(patient=user)
    medications = Currentmedications.objects.filter(patient=user)
    surgeries = Formersurgeries.objects.filter(patient=user)
    family = Familyhistory.objects.filter(patient=user).select_related('disease')
    inheritable = Inheritablediseases.objects.all()

    context = {
        'profile': profile,
        'allergies': allergies,
        'chronic_diseases': chronic,
        'current_medications': medications,
        'surgeries': surgeries,
        'family_history': family,
        'inheritable_diseases': inheritable,
    }
    return render(request, 'patient/medical_profile.html', context)


@patient_required
def medical_profile_update(request):
    if request.method == 'POST':
        profile = Patientprofile.objects.get(user=request.user)
        profile.date_of_birth = request.POST.get('date_of_birth') or None
        profile.gender = request.POST.get('gender') or None
        profile.blood_type = request.POST.get('blood_type') or None
        profile.weight = request.POST.get('weight') or None
        profile.height = request.POST.get('height') or None
        profile.is_smoker = 1 if request.POST.get('is_smoker') else 0
        profile.is_left_handed = 1 if request.POST.get('is_left_handed') else 0
        profile.emergency_contact_name = request.POST.get('emergency_contact_name') or None
        profile.emergency_contact_phone = request.POST.get('emergency_contact_phone') or None
        profile.updated_at = timezone.now()
        profile.save()
        messages.success(request, 'Medical profile updated.')
    return redirect('medical_profile')


# =============================================================================
# Allergies / Chronic / Medications / Surgeries / Family CRUD
# =============================================================================
@patient_required
def allergy_add(request):
    if request.method == 'POST':
        name = request.POST.get('allergy_name', '').strip()
        severity = request.POST.get('severity', '').strip() or None
        if name:
            Allergies.objects.create(
                patient=request.user, allergy_name=name, severity=severity,
                created_at=timezone.now(), updated_at=timezone.now()
            )
            messages.success(request, 'Allergy added.')
    return redirect('medical_profile')


@patient_required
def allergy_delete(request):
    if request.method == 'POST':
        name = request.POST.get('allergy_name')
        Allergies.objects.filter(patient=request.user, allergy_name=name).delete()
        messages.success(request, 'Allergy removed.')
    return redirect('medical_profile')


@patient_required
def chronic_disease_add(request):
    if request.method == 'POST':
        name = request.POST.get('disease_name', '').strip()
        diag_date = request.POST.get('diagnosis_date') or None
        if name:
            Chronicdiseases.objects.create(
                patient=request.user, disease_name=name, diagnosis_date=diag_date,
                created_at=timezone.now(), updated_at=timezone.now()
            )
            messages.success(request, 'Chronic disease added.')
    return redirect('medical_profile')


@patient_required
def chronic_disease_delete(request):
    if request.method == 'POST':
        name = request.POST.get('disease_name')
        Chronicdiseases.objects.filter(patient=request.user, disease_name=name).delete()
        messages.success(request, 'Chronic disease removed.')
    return redirect('medical_profile')


@patient_required
def medication_add(request):
    if request.method == 'POST':
        name = request.POST.get('medication_name', '').strip()
        dosage = request.POST.get('dosage_strength', '').strip() or None
        if name:
            Currentmedications.objects.create(
                patient=request.user, medication_name=name, dosage_strength=dosage,
                created_at=timezone.now(), updated_at=timezone.now()
            )
            messages.success(request, 'Medication added.')
    return redirect('medical_profile')


@patient_required
def medication_delete(request):
    if request.method == 'POST':
        name = request.POST.get('medication_name')
        Currentmedications.objects.filter(patient=request.user, medication_name=name).delete()
        messages.success(request, 'Medication removed.')
    return redirect('medical_profile')


@patient_required
def surgery_add(request):
    if request.method == 'POST':
        Formersurgeries.objects.create(
            patient=request.user,
            surgery_name=request.POST.get('surgery_name', '').strip(),
            date=request.POST.get('date'),
            doctor_name=request.POST.get('doctor_name', '').strip() or None,
            hospital_name=request.POST.get('hospital_name', '').strip() or None,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Surgery added.')
    return redirect('medical_profile')


@patient_required
def surgery_delete(request):
    if request.method == 'POST':
        pk = request.POST.get('pk')
        Formersurgeries.objects.filter(patient=request.user, id=pk).delete()
        messages.success(request, 'Surgery removed.')
    return redirect('medical_profile')


@patient_required
def family_history_add(request):
    if request.method == 'POST':
        disease_id = request.POST.get('disease_id')
        inherited_from = request.POST.get('inherited_from', '').strip() or None
        if disease_id:
            Familyhistory.objects.create(
                patient=request.user, disease_id=disease_id, inherited_from=inherited_from,
                created_at=timezone.now(), updated_at=timezone.now()
            )
            messages.success(request, 'Family history added.')
    return redirect('medical_profile')


@patient_required
def family_history_delete(request):
    if request.method == 'POST':
        disease_id = request.POST.get('disease_id')
        Familyhistory.objects.filter(patient=request.user, disease_id=disease_id).delete()
        messages.success(request, 'Family history removed.')
    return redirect('medical_profile')


# =============================================================================
# Vitals
# =============================================================================
@patient_required
def vitals_list(request):
    vitals = Vitalmeasurements.objects.filter(
        patient=request.user
    ).select_related('measurement_type').order_by('-date', '-time')
    types = Measurementtypes.objects.all()
    return render(request, 'patient/vitals.html', {'vitals': vitals, 'types': types})


@patient_required
def vitals_add(request):
    if request.method == 'POST':
        Vitalmeasurements.objects.create(
            patient=request.user,
            measurement_type_id=request.POST.get('measurement_type'),
            value=request.POST.get('value'),
            value_secondary=request.POST.get('value_secondary') or None,
            date=request.POST.get('date'),
            time=request.POST.get('time') or None,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Vital measurement added.')
    return redirect('vitals_list')


# =============================================================================
# Lab Tests
# =============================================================================
@patient_required
def lab_tests_list(request):
    tests = Labtests.objects.filter(patient=request.user).order_by('-date')
    return render(request, 'patient/lab_tests.html', {'lab_tests': tests})


@patient_required
def lab_tests_add(request):
    if request.method == 'POST':
        result_file_url = None
        if request.FILES.get('result_file'):
            upload = cloudinary.uploader.upload(
                request.FILES['result_file'],
                folder='docbot/lab_tests/',
                resource_type='auto'
            )
            result_file_url = upload.get('secure_url')

        Labtests.objects.create(
            patient=request.user,
            test_name=request.POST.get('test_name', '').strip(),
            result_file=result_file_url,
            date=request.POST.get('date'),
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Lab test added.')
    return redirect('lab_tests_list')


# =============================================================================
# Medical Scans
# =============================================================================
@patient_required
def scans_list(request):
    scans = Medicalscans.objects.filter(patient=request.user).order_by('-date')
    return render(request, 'patient/scans.html', {'scans': scans})


@patient_required
def scans_add(request):
    if request.method == 'POST':
        result_file_url = None
        if request.FILES.get('result_file'):
            upload = cloudinary.uploader.upload(
                request.FILES['result_file'],
                folder='docbot/medical_scans/',
                resource_type='auto'
            )
            result_file_url = upload.get('secure_url')

        Medicalscans.objects.create(
            patient=request.user,
            type=request.POST.get('type', '').strip(),
            result_file=result_file_url,
            date=request.POST.get('date'),
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Medical scan added.')
    return redirect('scans_list')


# =============================================================================
# Prescriptions
# =============================================================================
@patient_required
def prescriptions_list(request):
    prescriptions = Prescription.objects.filter(
        patient=request.user
    ).select_related('doctor__user').order_by('-date')

    for p in prescriptions:
        p.medications = Prescribedmedication.objects.filter(prescription=p)

    return render(request, 'patient/prescriptions.html', {'prescriptions': prescriptions})


# =============================================================================
# Diagnoses
# =============================================================================
@patient_required
def diagnoses_list(request):
    diagnoses = Diagnosis.objects.filter(
        patient=request.user
    ).order_by('-date')
    return render(request, 'patient/diagnoses.html', {'diagnoses': diagnoses})


@patient_required
def diagnosis_add(request):
    if request.method == 'POST':
        Diagnosis.objects.create(
            patient=request.user,
            diagnosis_name=request.POST.get('diagnosis_name', '').strip(),
            doctor_name=request.POST.get('doctor_name', '').strip() or None,
            date=request.POST.get('date'),
            created_by=request.user,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Diagnosis added.')
    return redirect('patient_diagnoses')


@patient_required
def diagnosis_edit(request, pk):
    diagnosis = get_object_or_404(Diagnosis, pk=pk, patient=request.user, created_by=request.user)
    if request.method == 'POST':
        diagnosis.diagnosis_name = request.POST.get('diagnosis_name', '').strip()
        diagnosis.doctor_name = request.POST.get('doctor_name', '').strip() or None
        diagnosis.date = request.POST.get('date')
        diagnosis.updated_at = timezone.now()
        diagnosis.save()
        messages.success(request, 'Diagnosis updated.')
        return redirect('patient_diagnoses')
    return render(request, 'patient/diagnosis_edit.html', {'diagnosis': diagnosis})


@patient_required
def diagnosis_delete(request, pk):
    diagnosis = get_object_or_404(Diagnosis, pk=pk, patient=request.user, created_by=request.user)
    if request.method == 'POST':
        diagnosis.delete()
        messages.success(request, 'Diagnosis deleted.')
    return redirect('patient_diagnoses')


# =============================================================================
# Appointments
# =============================================================================
@patient_required
def appointments_list(request):
    _auto_update_missed_appointments()
    status_filter = request.GET.get('status', '')
    appointments = Doctorappointment.objects.filter(
        patient=request.user
    ).select_related('doctor__user', 'slot', 'doctor_address').order_by('-slot__slot_date', '-slot__start_time')

    if status_filter:
        appointments = appointments.filter(status=status_filter)

    return render(request, 'patient/appointments.html', {
        'appointments': appointments,
        'current_status': status_filter,
    })


@patient_required
def appointment_detail(request, pk):
    appointment = get_object_or_404(
        Doctorappointment.objects.select_related('doctor__user', 'slot', 'doctor_address', 'parent_appointment'),
        pk=pk, patient=request.user
    )
    symptoms = Appointmentsymptoms.objects.filter(appointment=appointment)
    notes = Appointmentnote.objects.filter(appointment=appointment)
    prescriptions = Prescription.objects.filter(appointment=appointment)
    for p in prescriptions:
        p.medications = Prescribedmedication.objects.filter(prescription=p)
    diagnoses = Diagnosis.objects.filter(appointment=appointment)
    review = Doctorreview.objects.filter(appointment=appointment, patient=request.user).first()

    # Check if follow-up is available
    followup_available = (
        appointment.status == 'Completed' and
        appointment.follow_up_allowed and
        not Doctorappointment.objects.filter(parent_appointment=appointment).exists() and
        (timezone.now().date() - appointment.slot.slot_date).days <= FOLLOWUP_BOOKING_WINDOW_DAYS
    )

    context = {
        'appointment': appointment,
        'symptoms': symptoms,
        'notes': notes,
        'prescriptions': prescriptions,
        'diagnoses': diagnoses,
        'review': review,
        'followup_available': followup_available,
    }
    return render(request, 'patient/appointment_detail.html', context)


@patient_required
def appointment_cancel(request, pk):
    appointment = get_object_or_404(Doctorappointment, pk=pk, patient=request.user)
    if request.method == 'POST' and appointment.status == 'Booked':
        appointment.status = 'Canceled'
        appointment.canceled_by = request.user
        appointment.updated_at = timezone.now()
        appointment.save()
        # Free up the slot
        slot = appointment.slot
        slot.is_booked = 0
        slot.updated_at = timezone.now()
        slot.save()
        from notification.utils import notify_appointment_status_changed
        notify_appointment_status_changed(appointment, 'Canceled')
        messages.success(request, 'Appointment canceled successfully.')
    return redirect('patient_appointments')


@patient_required
def symptoms_manage(request, pk):
    appointment = get_object_or_404(Doctorappointment, pk=pk, patient=request.user)
    if appointment.status != 'Booked':
        messages.error(request, 'You can only manage symptoms for booked appointments.')
        return redirect('patient_appointment_detail', pk=pk)

    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'add':
            Appointmentsymptoms.objects.create(
                appointment=appointment,
                patient=request.user,
                symptom_name=request.POST.get('symptom_name', '').strip(),
                severity=request.POST.get('severity', '').strip() or None,
                created_at=timezone.now(), updated_at=timezone.now()
            )
            messages.success(request, 'Symptom added.')
        elif action == 'delete':
            symptom_id = request.POST.get('symptom_id')
            Appointmentsymptoms.objects.filter(
                id=symptom_id, appointment=appointment, patient=request.user
            ).delete()
            messages.success(request, 'Symptom removed.')

    symptoms = Appointmentsymptoms.objects.filter(appointment=appointment)
    return render(request, 'patient/symptoms.html', {'appointment': appointment, 'symptoms': symptoms})


# =============================================================================
# Reviews
# =============================================================================
@patient_required
def review_create(request, pk):
    appointment = get_object_or_404(Doctorappointment, pk=pk, patient=request.user)
    if appointment.status != 'Completed':
        messages.error(request, 'You can only review completed appointments.')
        return redirect('patient_appointment_detail', pk=pk)

    if Doctorreview.objects.filter(appointment=appointment, patient=request.user).exists():
        messages.error(request, 'You have already reviewed this appointment.')
        return redirect('patient_appointment_detail', pk=pk)

    if request.method == 'POST':
        Doctorreview.objects.create(
            doctor=appointment.doctor,
            patient=request.user,
            appointment=appointment,
            rating=int(request.POST.get('rating', 5)),
            comment=request.POST.get('comment', '').strip() or None,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        messages.success(request, 'Review submitted successfully!')
        return redirect('patient_appointment_detail', pk=pk)

    return render(request, 'patient/review_form.html', {'appointment': appointment})


@patient_required
def review_edit(request, pk):
    review = get_object_or_404(Doctorreview, pk=pk, patient=request.user)
    if request.method == 'POST':
        review.rating = int(request.POST.get('rating', review.rating))
        review.comment = request.POST.get('comment', '').strip() or None
        review.updated_at = timezone.now()
        review.save()
        messages.success(request, 'Review updated.')
        return redirect('patient_appointment_detail', pk=review.appointment_id)
    return render(request, 'patient/review_form.html', {'appointment': review.appointment, 'review': review})


@patient_required
def review_delete(request, pk):
    review = get_object_or_404(Doctorreview, pk=pk, patient=request.user)
    appointment_id = review.appointment_id
    if request.method == 'POST':
        review.delete()
        messages.success(request, 'Review deleted.')
    return redirect('patient_appointment_detail', pk=appointment_id)


# =============================================================================
# Booking
# =============================================================================
@patient_required
def book_appointment(request, doctor_id):
    doctor = get_object_or_404(Doctor.objects.select_related('user'), user_id=doctor_id)
    addresses = Doctoraddress.objects.filter(doctor=doctor)

    selected_address = request.GET.get('address')
    available_slots = None

    if selected_address:
        available_slots = Doctortimeslot.objects.filter(
            schedule__doctor=doctor,
            schedule__doctor_address_id=selected_address,
            slot_date__gte=date.today(),
            is_booked=0,
            is_available=1,
        ).select_related('schedule__doctor_address').order_by('slot_date', 'start_time')

    if request.method == 'POST':
        slot_id = request.POST.get('slot_id')
        address_id = request.POST.get('address_id')
        slot = get_object_or_404(Doctortimeslot, pk=slot_id, is_booked=0, is_available=1)

        appointment = Doctorappointment.objects.create(
            slot=slot,
            patient=request.user,
            doctor=doctor,
            doctor_address_id=address_id,
            status='Booked',
            is_follow_up=0,
            follow_up_allowed=0,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        slot.is_booked = 1
        slot.updated_at = timezone.now()
        slot.save()

        notify_appointment_booked(request.user, doctor, appointment)
        messages.success(request, 'Appointment booked successfully!')
        return redirect('patient_appointment_detail', pk=appointment.id)

    context = {
        'doctor': doctor,
        'addresses': addresses,
        'available_slots': available_slots,
        'selected_address': selected_address,
    }
    return render(request, 'patient/book_appointment.html', context)


@patient_required
def book_followup(request, doctor_id, appointment_id):
    """Book a follow-up appointment (only if doctor allowed it)."""
    parent = get_object_or_404(
        Doctorappointment, pk=appointment_id, patient=request.user,
        doctor__user_id=doctor_id, status='Completed', follow_up_allowed=1
    )

    # Check window
    days_since = (date.today() - parent.slot.slot_date).days
    if days_since > FOLLOWUP_BOOKING_WINDOW_DAYS:
        messages.error(request, 'Follow-up booking window has expired.')
        return redirect('patient_appointment_detail', pk=appointment_id)

    # Check no existing follow-up
    if Doctorappointment.objects.filter(parent_appointment=parent).exists():
        messages.error(request, 'A follow-up has already been booked for this appointment.')
        return redirect('patient_appointment_detail', pk=appointment_id)

    doctor = parent.doctor
    addresses = Doctoraddress.objects.filter(doctor=doctor)
    selected_address = request.GET.get('address')
    available_slots = None

    if selected_address:
        available_slots = Doctortimeslot.objects.filter(
            schedule__doctor=doctor,
            schedule__doctor_address_id=selected_address,
            slot_date__gte=date.today(),
            is_booked=0,
            is_available=1,
        ).select_related('schedule__doctor_address').order_by('slot_date', 'start_time')

    if request.method == 'POST':
        slot_id = request.POST.get('slot_id')
        address_id = request.POST.get('address_id')
        slot = get_object_or_404(Doctortimeslot, pk=slot_id, is_booked=0, is_available=1)

        appointment = Doctorappointment.objects.create(
            slot=slot,
            patient=request.user,
            doctor=doctor,
            doctor_address_id=address_id,
            status='Booked',
            parent_appointment=parent,
            is_follow_up=1,
            follow_up_allowed=0,
            created_at=timezone.now(), updated_at=timezone.now()
        )
        slot.is_booked = 1
        slot.updated_at = timezone.now()
        slot.save()

        notify_appointment_booked(request.user, doctor, appointment)
        messages.success(request, 'Follow-up appointment booked!')
        return redirect('patient_appointment_detail', pk=appointment.id)

    context = {
        'doctor': doctor,
        'addresses': addresses,
        'available_slots': available_slots,
        'selected_address': selected_address,
        'parent_appointment': parent,
        'is_followup': True,
    }
    return render(request, 'patient/book_appointment.html', context)


# =============================================================================
# Medication Reminders
# =============================================================================
@patient_required
def reminders_list(request):
    reminders = Medicationreminder.objects.filter(
        patient=request.user
    ).select_related('prescription').order_by('-start_date')

    for r in reminders:
        r.times = Remindertimes.objects.filter(reminder=r)

    return render(request, 'patient/reminders.html', {'reminders': reminders})

@patient_required
def reminder_toggle(request, pk):
    reminder = get_object_or_404(Medicationreminder, pk=pk, patient=request.user)
    if request.method == 'POST':
        reminder.is_active = 0 if reminder.is_active else 1
        reminder.updated_at = timezone.now()
        reminder.save()
        status = "enabled" if reminder.is_active else "disabled"
        messages.success(request, f'Reminder for {reminder.medication_name} has been {status}.')
    return redirect('patient_reminders')
