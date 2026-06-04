from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login_view, name='chatbot_login'),
    path('chat/', views.chat_page_view, name='chatbot_chat'),
    path('api/webhook/', views.webhook_view, name='chatbot_webhook'),
    path('api/profile/', views.get_profile_view, name='chatbot_get_profile'),
    path('api/doctors/', views.get_doctors_view, name='chatbot_get_doctors'),
]
