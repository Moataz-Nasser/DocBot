"""
Authentication URL patterns for DocBot.
Mounted at /auth/ in config/urls.py
"""
from django.urls import path, reverse_lazy
from django.contrib.auth import views as auth_views
from . import auth_views as custom_auth_views

urlpatterns = [
    path('login/', custom_auth_views.login_view, name='login'),
    path('register/', custom_auth_views.register_view, name='register'),
    path('logout/', custom_auth_views.logout_view, name='logout'),

    # Password reset flow (uses Django built-in views with console email backend)
    path('password-reset/',
         auth_views.PasswordResetView.as_view(
             template_name='core/password_reset.html',
             email_template_name='core/password_reset_email.html',
             subject_template_name='core/password_reset_subject.txt',
             success_url=reverse_lazy('password_reset_done'),
         ),
         name='password_reset'),

    path('password-reset/done/',
         auth_views.PasswordResetDoneView.as_view(
             template_name='core/password_reset_done.html',
         ),
         name='password_reset_done'),

    path('reset/<uidb64>/<token>/',
         auth_views.PasswordResetConfirmView.as_view(
             template_name='core/password_reset_confirm.html',
             success_url=reverse_lazy('password_reset_complete'),
         ),
         name='password_reset_confirm'),

    path('password-reset-complete/',
         auth_views.PasswordResetCompleteView.as_view(
             template_name='core/password_reset_complete.html',
         ),
         name='password_reset_complete'),
]
