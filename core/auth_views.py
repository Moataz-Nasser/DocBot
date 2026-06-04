"""
Authentication views for DocBot.
Handles login, registration, logout, and role-based redirect.
"""
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from patient.models import User, Patientprofile


def get_role_redirect_url(user):
    """Return the dashboard URL based on user role."""
    role_urls = {
        'Patient': '/patient/dashboard/',
        'Doctor': '/doctor/dashboard/',
        'Doctor_Assistant': '/doctor/assistant-dashboard/',
        'Moderator': '/admin-panel/dashboard/',
        'Super_Admin': '/admin-panel/dashboard/',
    }
    return role_urls.get(user.role, '/')


def login_view(request):
    """Login view using username + password."""
    if request.user.is_authenticated:
        return redirect(get_role_redirect_url(request.user))

    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '')

        if not username:
            return render(request, 'core/login.html', {'error': 'Please enter your username.'})
        if not password:
            return render(request, 'core/login.html', {'error': 'Please enter your password.', 'username': username})

        user = authenticate(request, username=username, password=password)
        if user is not None:
            if user.deleted_at is not None:
                return render(request, 'core/login.html', {
                    'error': 'This account has been deactivated.',
                    'username': username,
                })
            login(request, user)
            # Redirect to 'next' param if present, otherwise role-based dashboard
            next_url = request.GET.get('next') or request.POST.get('next')
            if next_url:
                return redirect(next_url)
            return redirect(get_role_redirect_url(user))
        else:
            return render(request, 'core/login.html', {
                'error': 'Invalid username or password.',
                'username': username,
            })

    return render(request, 'core/login.html')


def register_view(request):
    """Registration view — creates a Patient user."""
    if request.user.is_authenticated:
        return redirect(get_role_redirect_url(request.user))

    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        first_name = request.POST.get('first_name', '').strip()
        last_name = request.POST.get('last_name', '').strip()
        email = request.POST.get('email', '').strip()
        password = request.POST.get('password', '')
        confirm = request.POST.get('confirm_password', '')

        errors = {}
        if not username or len(username) < 3:
            errors['username'] = 'Username must be at least 3 characters.'
        elif len(username) > 14:
            errors['username'] = 'Username must be at most 14 characters.'
        elif User.objects.filter(username=username).exists():
            errors['username'] = 'This username is already taken.'

        import re
        if not first_name:
            errors['first_name'] = 'First name is required.'
        elif any(char.isdigit() for char in first_name):
            errors['first_name'] = 'First name must contain letters only, no numbers.'

        if not last_name:
            errors['last_name'] = 'Last name is required.'
        elif any(char.isdigit() for char in last_name):
            errors['last_name'] = 'Last name must contain letters only, no numbers.'

        if not email or not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|net|org|edu)(?:\.eg)?$', email):
            errors['email'] = 'Please enter a valid email address (e.g. user@domain.com or user@domain.com.eg).'
        elif User.objects.filter(email=email).exists():
            errors['email'] = 'This email is already registered.'

        if len(password) < 8 or not re.search(r'[A-Z]', password) or not re.search(r'[a-z]', password) or not re.search(r'\d', password) or not re.search(r'[^A-Za-z0-9]', password):
            errors['password'] = 'Password must be at least 8 characters and contain uppercase, lowercase, numbers, and special characters.'
        if password != confirm:
            errors['confirm_password'] = "Passwords don't match."

        if errors:
            return render(request, 'core/register.html', {
                'errors': errors,
                'username': username,
                'first_name': first_name,
                'last_name': last_name,
                'email': email,
            })

        # Create user
        user = User.objects.create_user(
            username=username,
            email=email,
            password=password,
            first_name=first_name,
            last_name=last_name,
            role='Patient',
        )
        user.date_joined = timezone.now()
        user.save()

        # Create empty patient profile
        Patientprofile.objects.create(
            user=user,
            created_at=timezone.now(),
            updated_at=timezone.now(),
        )

        messages.success(request, 'Account created successfully! Please log in.')
        return redirect('login')

    return render(request, 'core/register.html')


@login_required
def logout_view(request):
    """Log the user out and redirect to login."""
    logout(request)
    return redirect('login')
