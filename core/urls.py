"""
Core URL patterns for static pages and guest-accessible pages.
Mounted at / in config/urls.py
"""
from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path('chatbot/', views.chatbot_page, name='chatbot_page'),
    path('how-it-works/', views.how_it_works, name='how_it_works'),
    path('services/', views.services, name='services'),
    path('why-choose-us/', views.why_choose_us, name='why_choose_us'),
    path('doctors/', views.doctor_listing, name='doctor_listing'),
    path('doctors/<int:doctor_id>/', views.doctor_public_profile, name='doctor_public_profile'),
]
