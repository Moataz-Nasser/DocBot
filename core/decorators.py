"""
Role-based permission decorators for DocBot.
Usage: Apply these decorators to views to restrict access by user role.
All decorators require the user to be logged in first.
Unauthorized access returns HTTP 403 Forbidden.
"""
from functools import wraps
from django.http import HttpResponseForbidden
from django.contrib.auth.decorators import login_required
from django.shortcuts import render


def _role_required(allowed_roles):
    """Factory for role-checking decorators."""
    def decorator(view_func):
        @wraps(view_func)
        @login_required
        def wrapper(request, *args, **kwargs):
            if request.user.role in allowed_roles:
                return view_func(request, *args, **kwargs)
            return render(request, 'core/403.html', status=403)
        return wrapper
    return decorator


def patient_required(view_func):
    """Only users with role='Patient' can access."""
    return _role_required(['Patient'])(view_func)


def doctor_required(view_func):
    """Only users with role='Doctor' can access."""
    return _role_required(['Doctor'])(view_func)


def assistant_required(view_func):
    """Only users with role='Doctor_Assistant' can access."""
    return _role_required(['Doctor_Assistant'])(view_func)


def moderator_required(view_func):
    """Only users with role='Moderator' can access."""
    return _role_required(['Moderator'])(view_func)


def superadmin_required(view_func):
    """Only users with role='Super_Admin' can access."""
    return _role_required(['Super_Admin'])(view_func)


def admin_required(view_func):
    """Users with role='Moderator' or 'Super_Admin' can access."""
    return _role_required(['Moderator', 'Super_Admin'])(view_func)


def doctor_or_assistant_required(view_func):
    """Users with role='Doctor' or 'Doctor_Assistant' can access."""
    return _role_required(['Doctor', 'Doctor_Assistant'])(view_func)
