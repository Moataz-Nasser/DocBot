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
    now = timezone.now()
    today = now.date()
    
    # 1. Booked -> No-show (if date passed)
    past_appointments = Doctorappointment.objects.filter(
        status='Booked',
        appointment_date__lt=today
    )
    if past_appointments.exists():
        past_appointments.update(status='No-show', updated_at=now)

    # 2. In progress -> Completed (if stuck for > 12 hours)
    twelve_hours_ago = now - timedelta(hours=12)
    stuck_appointments = Doctorappointment.objects.filter(
        status='In progress',
        updated_at__lt=twelve_hours_ago
    )
    if stuck_appointments.exists():
        stuck_appointments.update(status='Completed', updated_at=now)

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
        appointment_date__gte=date.today(),
    ).select_related('doctor__user', 'slot', 'doctor_address').order_by('appointment_date', 'appointment_time')[:5]

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
        'chatbot_data_exists': user.has_initialized_profile,
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
        first_name = request.POST.get('first_name', '').strip()
        last_name = request.POST.get('last_name', '').strip()
        email = request.POST.get('email', '').strip()
        phone = request.POST.get('phone', '').strip() or None

        # Validate first_name & last_name
        import re
        if not first_name or any(char.isdigit() for char in first_name):
            messages.error(request, 'First name is required and must contain letters only, no numbers.')
            return redirect('patient_profile_edit')
        if not last_name or any(char.isdigit() for char in last_name):
            messages.error(request, 'Last name is required and must contain letters only, no numbers.')
            return redirect('patient_profile_edit')

        # Validate email
        if not email or not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|org|edu)(?:\.eg)?$', email):
            messages.error(request, 'Please enter a valid email address (e.g. user@domain.com or user@domain.com.eg).')
            return redirect('patient_profile_edit')

        # Validate phone
        if phone:
            if not re.match(r'^01[0125]\d{8}$', phone):
                messages.error(request, 'Phone number must be a valid 11-digit Egyptian mobile number (e.g. 01012345678).')
                return redirect('patient_profile_edit')

        user.first_name = first_name
        user.last_name = last_name
        user.email = email
        user.phone = phone
        user.save()

        new_password = request.POST.get('new_password', '')
        confirm_password = request.POST.get('confirm_password', '')
        if new_password:
            has_digit = re.search(r"\d", new_password)
            if len(new_password) < 8 or not has_digit:
                messages.error(request, 'Password must be at least 8 characters and contain at least one digit.')
                return redirect('patient_profile_edit')
            if new_password != confirm_password:
                messages.error(request, 'Passwords do not match.')
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

    # Fetch active prescribed medications
    all_prescribed = Prescribedmedication.objects.filter(
        prescription__patient=user
    ).select_related('prescription', 'prescription__doctor__user')
    
    # Filter for active ones in Python using the model property
    active_prescribed = [m for m in all_prescribed if not m.is_expired]

    # Determine if chatbot data exists in any of the 6 sections
    chatbot_data_exists = (
        allergies.exists() or
        chronic.exists() or
        medications.exists() or
        surgeries.exists() or
        family.exists() or
        Diagnosis.objects.filter(patient=user).exists()
    )

    context = {
        'profile': profile,
        'allergies': allergies,
        'chronic_diseases': chronic,
        'current_medications': medications,
        'active_prescribed': active_prescribed,
        'surgeries': surgeries,
        'family_history': family,
        'inheritable_diseases': inheritable,
        'chatbot_data_exists': chatbot_data_exists,
    }
    return render(request, 'patient/medical_profile.html', context)


@patient_required
def medical_profile_update(request):
    if request.method == 'POST':
        import re
        profile = Patientprofile.objects.get(user=request.user)

        weight_raw = request.POST.get('weight', '').strip()
        weight_val = None
        if weight_raw:
            try:
                weight_val = float(weight_raw)
                if weight_val < 20:
                    messages.error(request, 'Weight must be at least 20 kg.')
                    return redirect('medical_profile')
            except ValueError:
                messages.error(request, 'Please enter a valid number for weight.')
                return redirect('medical_profile')

        height_raw = request.POST.get('height', '').strip()
        height_val = None
        if height_raw:
            try:
                height_val = float(height_raw)
                if height_val < 100:
                    messages.error(request, 'Height must be at least 100 cm.')
                    return redirect('medical_profile')
            except ValueError:
                messages.error(request, 'Please enter a valid number for height.')
                return redirect('medical_profile')

        emergency_contact_name = request.POST.get('emergency_contact_name', '').strip() or None
        if emergency_contact_name:
            if any(char.isdigit() for char in emergency_contact_name):
                messages.error(request, 'Emergency contact name must contain letters only, no numbers.')
                return redirect('medical_profile')

        emergency_contact_phone = request.POST.get('emergency_contact_phone', '').strip() or None
        if emergency_contact_phone:
            if not re.match(r'^01[0125]\d{8}$', emergency_contact_phone):
                messages.error(request, 'Emergency contact phone number must be a valid 11-digit Egyptian mobile number (e.g. 01012345678).')
                return redirect('medical_profile')

        profile.date_of_birth = request.POST.get('date_of_birth') or None
        profile.gender = request.POST.get('gender') or None
        profile.blood_type = request.POST.get('blood_type') or None
        profile.weight = weight_val
        profile.height = height_val
        profile.is_smoker = 1 if request.POST.get('is_smoker') else 0
        profile.is_left_handed = 1 if request.POST.get('is_left_handed') else 0
        profile.emergency_contact_name = emergency_contact_name
        profile.emergency_contact_phone = emergency_contact_phone
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
def surgery_delete(request, pk):
    if request.method == 'POST':
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
            file = request.FILES['result_file']
            # Determine resource type: images as 'image', others (PDFs) as 'raw'
            resource_type = 'image'
            if file.name.lower().endswith('.pdf'):
                resource_type = 'raw'
            
            upload = cloudinary.uploader.upload(
                file,
                folder='docbot/lab_tests/',
                resource_type=resource_type,
                type='upload'
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


@patient_required
def lab_tests_delete(request, pk):
    test = get_object_or_404(Labtests, pk=pk, patient=request.user)
    if request.method == 'POST':
        test.delete()
        messages.success(request, 'Lab test deleted successfully.')
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
            file = request.FILES['result_file']
            # Determine resource type: images as 'image', others (PDFs) as 'raw'
            resource_type = 'image'
            if file.name.lower().endswith('.pdf'):
                resource_type = 'raw'

            upload = cloudinary.uploader.upload(
                file,
                folder='docbot/medical_scans/',
                resource_type=resource_type,
                type='upload'
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


@patient_required
def scans_delete(request, pk):
    scan = get_object_or_404(Medicalscans, pk=pk, patient=request.user)
    if request.method == 'POST':
        scan.delete()
        messages.success(request, 'Medical scan deleted successfully.')
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
    user = request.user
    diagnoses = Diagnosis.objects.filter(
        patient=user
    ).order_by('-date')

    chatbot_data_exists = (
        Allergies.objects.filter(patient=user).exists() or
        Chronicdiseases.objects.filter(patient=user).exists() or
        Currentmedications.objects.filter(patient=user).exists() or
        Formersurgeries.objects.filter(patient=user).exists() or
        Familyhistory.objects.filter(patient=user).exists() or
        diagnoses.exists()
    )

    return render(request, 'patient/diagnoses.html', {
        'diagnoses': diagnoses,
        'chatbot_data_exists': chatbot_data_exists,
    })


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
    ).select_related('doctor__user', 'slot', 'doctor_address').order_by('-appointment_date', '-appointment_time')

    if status_filter:
        appointments = appointments.filter(status=status_filter)

    # Fetch notes in a single query to avoid N+1 queries
    notes = Appointmentnote.objects.filter(appointment__in=appointments)
    from collections import defaultdict
    notes_by_appt = defaultdict(list)
    for note in notes:
        notes_by_appt[note.appointment_id].append(note)
    
    for appt in appointments:
        appt.notes = notes_by_appt[appt.id]

    return render(request, 'patient/appointments.html', {
        'appointments': appointments,
        'current_status': status_filter,
        'chatbot_data_exists': request.user.has_initialized_profile,
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
        (timezone.now().date() - appointment.appointment_date).days <= FOLLOWUP_BOOKING_WINDOW_DAYS
    )

    # Monthly stats
    month_start = date.today().replace(day=1)
    patients_this_month = Doctorappointment.objects.filter(
        doctor=appointment.doctor,
        appointment_date__gte=month_start
    ).count()

    context = {
        'appointment': appointment,
        'symptoms': symptoms,
        'notes': notes,
        'prescriptions': prescriptions,
        'diagnoses': diagnoses,
        'review': review,
        'followup_available': followup_available,
        'patients_this_month': patients_this_month,
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
        # Free up the slot, if it still exists
        if appointment.slot:
            appointment.slot.is_booked = 0
            appointment.slot.updated_at = timezone.now()
            appointment.slot.save()
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
    if not request.user.has_initialized_profile:
        messages.warning(request, "To help your doctor prepare for your visit, please complete your health profile with our AI assistant first. Let's finish your quick chat, and then you can book your appointment right away!")
        return redirect('chatbot_chat')
        
    doctor = get_object_or_404(Doctor.objects.select_related('user'), user_id=doctor_id)
    addresses = Doctoraddress.objects.filter(doctor=doctor)

    selected_address = request.GET.get('address')
    available_slots = None

    if selected_address:
        limit_datetime = timezone.localtime(timezone.now()) + timedelta(hours=1)
        limit_date = limit_datetime.date()
        limit_time = limit_datetime.time()
        available_slots = Doctortimeslot.objects.filter(
            schedule__doctor=doctor,
            schedule__doctor_address_id=selected_address,
            is_booked=0,
            is_available=1,
        ).filter(
            Q(slot_date__gt=limit_date) |
            Q(slot_date=limit_date, start_time__gt=limit_time)
        ).select_related('schedule__doctor_address').order_by('slot_date', 'start_time')

    if request.method == 'POST':
        slot_id = request.POST.get('slot_id')
        address_id = request.POST.get('address_id')
        slot = get_object_or_404(Doctortimeslot, pk=slot_id, is_booked=0, is_available=1)

        appointment = Doctorappointment.objects.create(
            slot=slot,
            appointment_date=slot.slot_date,
            appointment_time=slot.start_time,
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
    if not request.user.has_initialized_profile:
        messages.warning(request, "To help your doctor prepare for your visit, please complete your health profile with our AI assistant first. Let's finish your quick chat, and then you can book your appointment right away!")
        return redirect('chatbot_chat')
    parent = get_object_or_404(
        Doctorappointment, pk=appointment_id, patient=request.user,
        doctor__user_id=doctor_id, status='Completed', follow_up_allowed=1
    )

    # Check window
    days_since = (date.today() - parent.appointment_date).days
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
        limit_datetime = timezone.localtime(timezone.now()) + timedelta(hours=1)
        limit_date = limit_datetime.date()
        limit_time = limit_datetime.time()
        available_slots = Doctortimeslot.objects.filter(
            schedule__doctor=doctor,
            schedule__doctor_address_id=selected_address,
            is_booked=0,
            is_available=1,
        ).filter(
            Q(slot_date__gt=limit_date) |
            Q(slot_date=limit_date, start_time__gt=limit_time)
        ).select_related('schedule__doctor_address').order_by('slot_date', 'start_time')

    if request.method == 'POST':
        slot_id = request.POST.get('slot_id')
        address_id = request.POST.get('address_id')
        slot = get_object_or_404(Doctortimeslot, pk=slot_id, is_booked=0, is_available=1)

        appointment = Doctorappointment.objects.create(
            slot=slot,
            appointment_date=slot.slot_date,
            appointment_time=slot.start_time,
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
    today = date.today()
    all_reminders = Medicationreminder.objects.filter(
        patient=request.user
    ).select_related('prescription').order_by('-start_date')

    active_reminders = []
    past_reminders = []

    for r in all_reminders:
        r.times = Remindertimes.objects.filter(reminder=r)
        if r.end_date >= today:
            active_reminders.append(r)
        else:
            past_reminders.append(r)

    return render(request, 'patient/reminders.html', {
        'active_reminders': active_reminders,
        'past_reminders': past_reminders
    })

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
