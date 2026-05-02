from django.core.management.base import BaseCommand
from doctor.models import Doctorschedule
from doctor.views import _generate_slots_for_schedule

class Command(BaseCommand):
    help = 'Generates future time slots for all active doctor schedules'

    def handle(self, *args, **options):
        schedules = Doctorschedule.objects.all()
        count = 0
        for schedule in schedules:
            _generate_slots_for_schedule(schedule)
            count += 1
            
        self.stdout.write(self.style.SUCCESS(f'Successfully generated slots for {count} schedules.'))
