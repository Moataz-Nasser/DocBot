# appointment
from django.db import models

class Doctorappointment(models.Model):
    slot = models.ForeignKey('doctor.Doctortimeslot', models.DO_NOTHING)
    patient = models.ForeignKey('patient.User', models.DO_NOTHING)
    doctor = models.ForeignKey('doctor.Doctor', models.DO_NOTHING)
    doctor_address = models.ForeignKey('doctor.Doctoraddress', models.DO_NOTHING)
    status = models.CharField(max_length=11)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    parent_appointment = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
    canceled_by = models.ForeignKey('patient.User', models.SET_NULL, null=True, blank=True, related_name='canceled_appointments', db_column='canceled_by')
    is_follow_up = models.IntegerField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    
    def __str__(self):
        return f"Appointment {self.id} - {self.patient.get_full_name()} with Dr. {self.doctor.user.get_full_name()}"

    class Meta:
        managed = False
        db_table = 'doctorappointment'

class Appointmentnote(models.Model):
    appointment = models.ForeignKey('appointment.Doctorappointment', models.DO_NOTHING)
    doctor = models.ForeignKey('doctor.Doctor', models.DO_NOTHING)
    note = models.TextField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'appointmentnote'
        unique_together = (('appointment', 'id'),)


class Appointmentsymptoms(models.Model):
    appointment = models.ForeignKey('Doctorappointment', models.DO_NOTHING)
    patient = models.ForeignKey('patient.User', models.DO_NOTHING)
    symptom_name = models.CharField(max_length=100)
    severity = models.CharField(max_length=50, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'appointmentsymptoms'

class Doctorreview(models.Model):
    doctor = models.ForeignKey('doctor.Doctor', models.DO_NOTHING)
    patient = models.ForeignKey('patient.User', models.DO_NOTHING)
    appointment = models.ForeignKey('appointment.Doctorappointment', models.DO_NOTHING)
    rating = models.IntegerField()
    comment = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'doctorreview'