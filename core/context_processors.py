"""
Context processors for DocBot.
These inject data into every template context automatically.
"""
from notification.models import Notification


def notifications_context(request):
    """Inject unread notification count into all templates."""
    if request.user.is_authenticated:
        unread_count = Notification.objects.filter(
            user=request.user,
            is_read=0
        ).count()
        return {'unread_notification_count': unread_count}
    return {'unread_notification_count': 0}
