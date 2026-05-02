"""
Notification URL patterns.
Mounted at /notifications/ in config/urls.py
"""
from django.urls import path
from . import views

urlpatterns = [
    path('', views.notifications_list, name='notifications_list'),
    path('<int:pk>/mark-read/', views.mark_read, name='notification_mark_read'),
    path('mark-all-read/', views.mark_all_read, name='notifications_mark_all_read'),
    path('check-count/', views.check_unread_count, name='check_unread_count'),
]
