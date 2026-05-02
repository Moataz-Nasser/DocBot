"""
Doctor URL patterns.
Mounted at /doctor/ in config/urls.py
Includes both Doctor and Doctor Assistant routes.
"""
from django.urls import path
from . import views

urlpatterns = [
    # =================== Doctor Views ===================
    path('dashboard/', views.dashboard, name='doctor_dashboard'),
    path('profile/', views.doctor_profile, name='doctor_profile'),
    path('profile/edit-price/', views.edit_price, name='doctor_edit_price'),

    # Schedules
    path('schedules/', views.schedules_list, name='doctor_schedules'),
    path('schedules/add/', views.schedule_add, name='doctor_schedule_add'),
    path('schedules/<int:pk>/edit/', views.schedule_edit, name='doctor_schedule_edit'),
    path('schedules/<int:pk>/delete/', views.schedule_delete, name='doctor_schedule_delete'),

    # Appointments
    path('appointments/', views.appointments_list, name='doctor_appointments'),
    path('appointments/<int:pk>/', views.appointment_detail, name='doctor_appointment_detail'),
    path('appointments/<int:pk>/start/', views.appointment_start, name='doctor_appointment_start'),
    path('appointments/<int:pk>/complete/', views.appointment_complete, name='doctor_appointment_complete'),
    path('appointments/<int:pk>/cancel/', views.appointment_cancel, name='doctor_appointment_cancel'),
    path('appointments/<int:pk>/no-show/', views.appointment_noshow, name='doctor_appointment_noshow'),
    path('appointments/<int:pk>/allow-followup/', views.allow_followup, name='doctor_allow_followup'),

    # Clinical data
    path('appointments/<int:pk>/notes/', views.notes_manage, name='doctor_notes_manage'),
    path('appointments/<int:pk>/prescriptions/', views.prescription_manage, name='doctor_prescription_manage'),
    path('appointments/<int:pk>/prescriptions/<int:prescription_id>/', views.prescription_detail, name='doctor_prescription_detail'),
    path('appointments/<int:pk>/diagnoses/', views.diagnosis_manage, name='doctor_diagnosis_manage'),

    # Reviews
    path('reviews/', views.reviews_list, name='doctor_reviews'),

    # =================== Doctor Assistant Views ===================
    path('assistant-dashboard/', views.assistant_dashboard, name='assistant_dashboard'),
    path('assistant/doctor-profile/', views.assistant_doctor_profile, name='assistant_doctor_profile'),
    path('assistant/edit-price/', views.assistant_edit_price, name='assistant_edit_price'),

    # Assistant Schedules
    path('assistant/schedules/', views.assistant_schedules, name='assistant_schedules'),
    path('assistant/schedules/add/', views.assistant_schedule_add, name='assistant_schedule_add'),
    path('assistant/schedules/<int:pk>/edit/', views.assistant_schedule_edit, name='assistant_schedule_edit'),
    path('assistant/schedules/<int:pk>/delete/', views.assistant_schedule_delete, name='assistant_schedule_delete'),

    # Assistant Appointments
    path('assistant/appointments/', views.assistant_appointments, name='assistant_appointments'),
    path('assistant/appointments/<int:pk>/', views.assistant_appointment_detail, name='assistant_appointment_detail'),
    path('assistant/appointments/<int:pk>/cancel/', views.assistant_cancel_appointment, name='assistant_cancel_appointment'),
]
