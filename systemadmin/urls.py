"""
System Admin URL patterns.
Mounted at /admin-panel/ in config/urls.py
"""
from django.urls import path
from . import views

urlpatterns = [
    path('dashboard/', views.dashboard, name='admin_dashboard'),

    # Users
    path('users/', views.user_list, name='admin_users'),
    path('users/<int:pk>/edit-role/', views.user_edit_role, name='admin_user_edit_role'),
    path('users/<int:pk>/delete/', views.user_delete, name='admin_user_delete'),
    path('users/<int:pk>/reactivate/', views.user_reactivate, name='admin_user_reactivate'),

    # Doctors
    path('doctors/', views.doctor_list, name='admin_doctors'),
    path('doctors/add/', views.doctor_add, name='admin_doctor_add'),
    path('doctors/<str:username>/edit/', views.doctor_edit, name='admin_doctor_edit'),
    path('doctors/<str:username>/delete/', views.doctor_delete, name='admin_doctor_delete'),

    # Doctor Addresses
    path('doctors/<str:username>/addresses/', views.doctor_addresses, name='admin_doctor_addresses'),
    path('doctors/<str:username>/addresses/add/', views.doctor_address_add, name='admin_doctor_address_add'),
    path('doctors/<str:username>/addresses/<int:address_id>/edit/', views.doctor_address_edit, name='admin_doctor_address_edit'),
    path('doctors/<str:username>/addresses/<int:address_id>/delete/', views.doctor_address_delete, name='admin_doctor_address_delete'),

    # Doctor Schedules (admin)
    path('doctors/<str:username>/schedules/', views.admin_doctor_schedules, name='admin_doctor_schedules'),
    path('doctors/<str:username>/schedules/add/', views.admin_doctor_schedule_add, name='admin_doctor_schedule_add'),
    path('doctors/<str:username>/schedules/<int:schedule_id>/delete/', views.admin_doctor_schedule_delete, name='admin_doctor_schedule_delete'),

    # Doctor Assistants
    path('doctor-assistants/add/', views.assistant_add, name='admin_assistant_add'),

    # Reviews
    path('reviews/', views.reviews_list, name='admin_reviews'),
    path('reviews/<int:pk>/delete/', views.review_delete, name='admin_review_delete'),

    # Measurement Types
    path('measurement-types/', views.measurement_types, name='admin_measurement_types'),

    # Inheritable Diseases
    path('inheritable-diseases/', views.inheritable_diseases, name='admin_inheritable_diseases'),
]
