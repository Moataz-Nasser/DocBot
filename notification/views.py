"""
Notification views.
"""
from django.shortcuts import redirect, get_object_or_404, render
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from notification.models import Notification


@login_required
def notifications_list(request):
    notifications = Notification.objects.filter(
        user=request.user
    ).order_by('-created_at')
    return render(request, 'notification/list.html', {'notifications': notifications})


@login_required
def mark_read(request, pk):
    notification = get_object_or_404(Notification, pk=pk, user=request.user)
    notification.is_read = 1
    notification.save()
    return redirect('notifications_list')


@login_required
def mark_all_read(request):
    if request.method == 'POST':
        Notification.objects.filter(user=request.user, is_read=0).update(is_read=1)
    return redirect('notifications_list')

@login_required
def check_unread_count(request):
    count = Notification.objects.filter(user=request.user, is_read=0).count()
    return JsonResponse({'unread_count': count})
