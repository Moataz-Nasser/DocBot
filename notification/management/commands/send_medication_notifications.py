from django.core.management.base import BaseCommand
from django.utils import timezone
from datetime import datetime, timedelta
from notification.models import Medicationreminder, Remindertimes, Notification
from patient.models import User

class Command(BaseCommand):
    help = 'Sends medication notifications to patients'

    def handle(self, *args, **options):
        now = timezone.now()
        today = now.date()
        current_time = now.time()
        
        # Buffer of 15 minutes
        buffer_start = (now - timedelta(minutes=15)).time()
        
        active_reminders = Medicationreminder.objects.filter(
            is_active=1,
            start_date__lte=today,
            end_date__gte=today
        )
        
        for reminder in active_reminders:
            times = Remindertimes.objects.filter(reminder=reminder)
            for rt in times:
                # Check if it's time (roughly)
                if buffer_start <= rt.time <= current_time:
                    # Check if already notified recently (last 1 hour) for this medication
                    already_notified = Notification.objects.filter(
                        user=reminder.patient,
                        title='Medication Reminder',
                        message__icontains=reminder.medication_name,
                        created_at__gte=now - timedelta(hours=1)
                    ).exists()
                    
                    if not already_notified:
                        Notification.objects.create(
                            user=reminder.patient,
                            title='Medication Reminder',
                            message=f'It is time to take your medication: {reminder.medication_name}.',
                            is_allowed=1,
                            is_read=0,
                            created_at=now
                        )
                        self.stdout.write(f'Sent reminder to {reminder.patient.username} for {reminder.medication_name}')
