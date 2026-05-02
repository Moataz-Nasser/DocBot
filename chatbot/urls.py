from django.urls import path
from . import views

urlpatterns = [
    path('login/', views.login_view, name='chatbot_login'),
    path('chat/', views.chat_page_view, name='chatbot_chat'),
    path('api/validate/', views.validate_chatbot_token, name='chatbot_validate'),
    path('api/patient-data/', views.chatbot_patient_data, name='chatbot_patient_data'),
    path('api/webhook/', views.webhook_view, name='chatbot_webhook'),
]
