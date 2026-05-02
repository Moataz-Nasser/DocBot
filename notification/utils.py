"""
Notification helper utilities.
Creates notifications for various system events.
"""
from django.utils import timezone
from notification.models import Notification


def create_notification(user, title, message):
    """Create a notification for a user."""
    Notification.objects.create(
        user=user,
        title=title,
        message=message,
        is_allowed=1,
        is_read=0,
        created_at=timezone.now(),
    )


def notify_appointment_booked(patient, doctor, appointment):
    """Notify patient when they book an appointment."""
    create_notification(
        user=patient,
        title='Appointment Booked',
        message=f'Your appointment with Dr. {doctor.user.full_name} on '
                f'{appointment.slot.slot_date} at {appointment.slot.start_time.strftime("%I:%M %p")} '
                f'has been booked successfully.'
    )


def notify_appointment_status_changed(appointment, new_status):
    """Notify patient when appointment status changes."""
    doctor_name = appointment.doctor.user.full_name
    date_str = appointment.slot.slot_date
    time_str = appointment.slot.start_time.strftime("%I:%M %p")

    messages = {
        'In progress': f'Your appointment with Dr. {doctor_name} has started.',
        'Completed': f'Your appointment with Dr. {doctor_name} on {date_str} has been completed.',
        'Canceled': f'Your appointment with Dr. {doctor_name} on {date_str} at {time_str} has been canceled.',
        'No-show': f'You were marked as a no-show for your appointment with Dr. {doctor_name} on {date_str}.',
    }

    if new_status in messages:
        create_notification(
            user=appointment.patient,
            title=f'Appointment {new_status}',
            message=messages[new_status]
        )


def notify_prescription_created(patient, doctor, prescription):
    """Notify patient when doctor creates a prescription."""
    create_notification(
        user=patient,
        title='New Prescription',
        message=f'Dr. {doctor.user.full_name} has written a new prescription for you '
                f'on {prescription.date}.'
    )


def notify_diagnosis_created(patient, doctor, diagnosis):
    """Notify patient when doctor creates a diagnosis."""
    create_notification(
        user=patient,
        title='New Diagnosis',
        message=f'Dr. {doctor.user.full_name} has added a diagnosis: {diagnosis.diagnosis_name}.'
    )


def notify_followup_allowed(appointment):
    """Notify patient when doctor allows follow-up booking."""
    create_notification(
        user=appointment.patient,
        title='Follow-Up Available',
        message=f'Dr. {appointment.doctor.user.full_name} has authorized a follow-up appointment. '
                f'You can book it within the next 30 days.'
    )
