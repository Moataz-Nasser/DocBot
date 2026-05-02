"""
Patient URL patterns.
Mounted at /patient/ in config/urls.py
"""
from django.urls import path
from . import views

urlpatterns = [
    path('dashboard/', views.dashboard, name='patient_dashboard'),
    path('profile/', views.profile_view, name='patient_profile'),
    path('profile/edit/', views.profile_edit, name='patient_profile_edit'),
    path('medical-profile/', views.medical_profile, name='medical_profile'),
    path('medical-profile/update/', views.medical_profile_update, name='medical_profile_update'),

    # Vitals
    path('vitals/', views.vitals_list, name='vitals_list'),
    path('vitals/add/', views.vitals_add, name='vitals_add'),

    # Lab tests
    path('lab-tests/', views.lab_tests_list, name='lab_tests_list'),
    path('lab-tests/add/', views.lab_tests_add, name='lab_tests_add'),

    # Medical scans
    path('medical-scans/', views.scans_list, name='scans_list'),
    path('medical-scans/add/', views.scans_add, name='scans_add'),

    # Prescriptions
    path('prescriptions/', views.prescriptions_list, name='patient_prescriptions'),

    # Diagnoses
    path('diagnoses/', views.diagnoses_list, name='patient_diagnoses'),
    path('diagnoses/add/', views.diagnosis_add, name='patient_diagnosis_add'),
    path('diagnoses/<int:pk>/edit/', views.diagnosis_edit, name='patient_diagnosis_edit'),
    path('diagnoses/<int:pk>/delete/', views.diagnosis_delete, name='patient_diagnosis_delete'),

    # Appointments
    path('appointments/', views.appointments_list, name='patient_appointments'),
    path('appointments/<int:pk>/', views.appointment_detail, name='patient_appointment_detail'),
    path('appointments/<int:pk>/cancel/', views.appointment_cancel, name='patient_appointment_cancel'),
    path('appointments/<int:pk>/symptoms/', views.symptoms_manage, name='patient_symptoms_manage'),
    path('appointments/<int:pk>/review/', views.review_create, name='patient_review_create'),

    # Booking
    path('book/<int:doctor_id>/', views.book_appointment, name='book_appointment'),
    path('book/<int:doctor_id>/follow-up/<int:appointment_id>/', views.book_followup, name='book_followup'),

    # Reviews
    path('reviews/<int:pk>/edit/', views.review_edit, name='patient_review_edit'),
    path('reviews/<int:pk>/delete/', views.review_delete, name='patient_review_delete'),

    # Medication reminders
    path('medication-reminders/', views.reminders_list, name='patient_reminders'),
    path('medication-reminders/<int:pk>/toggle/', views.reminder_toggle, name='patient_reminder_toggle'),

    # Medical data management
    path('allergies/add/', views.allergy_add, name='allergy_add'),
    path('allergies/delete/', views.allergy_delete, name='allergy_delete'),
    path('chronic-diseases/add/', views.chronic_disease_add, name='chronic_disease_add'),
    path('chronic-diseases/delete/', views.chronic_disease_delete, name='chronic_disease_delete'),
    path('medications/add/', views.medication_add, name='medication_add'),
    path('medications/delete/', views.medication_delete, name='medication_delete'),
    path('surgeries/add/', views.surgery_add, name='surgery_add'),
    path('surgeries/<int:pk>/delete/', views.surgery_delete, name='surgery_delete'),
    path('family-history/add/', views.family_history_add, name='family_history_add'),
    path('family-history/delete/', views.family_history_delete, name='family_history_delete'),
]
