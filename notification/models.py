# notification
from django.db import models


class Medicationreminder(models.Model):
    patient = models.ForeignKey('patient.User', models.DO_NOTHING)
    prescription = models.ForeignKey('doctor.Prescription', models.DO_NOTHING)
    medication_name = models.CharField(max_length=255)
    start_date = models.DateField()
    end_date = models.DateField()
    repeat_interval_days = models.IntegerField()
    note = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'medicationreminder'

class Notification(models.Model):
    user = models.ForeignKey('patient.User', models.DO_NOTHING)
    title = models.CharField(max_length=255)
    message = models.TextField()
    is_allowed = models.IntegerField()
    created_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'notification'

class Remindertimes(models.Model):
    pk = models.CompositePrimaryKey('reminder_id', 'time')
    reminder = models.ForeignKey(Medicationreminder, models.DO_NOTHING)
    time = models.TimeField()

    class Meta:
        managed = False
        db_table = 'remindertimes'
