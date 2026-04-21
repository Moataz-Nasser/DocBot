# doctor
from datetime import timezone, timedelta
from django.db import models

class Doctor(models.Model):
    user = models.OneToOneField('patient.User', models.DO_NOTHING, primary_key=True)
    specialization = models.CharField(max_length=255)
    years_of_experience = models.IntegerField()
    price = models.FloatField()
    image = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'doctor'
        
class Doctorassistant(models.Model):
    user = models.OneToOneField('patient.User', models.DO_NOTHING, primary_key=True)
    doctor = models.ForeignKey('Doctor', models.DO_NOTHING)
    created_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'doctorassistant'

class Doctoraddress(models.Model):
    doctor = models.ForeignKey('Doctor', models.DO_NOTHING)
    floor = models.CharField(max_length=50, blank=True, null=True)
    building_number = models.IntegerField(blank=True, null=True)
    street = models.CharField(max_length=255)
    governorate = models.CharField(max_length=255)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    
    @property
    def full_address(self):
        parts = [self.building_number, self.street, self.governorate]
        return ", ".join([str(p) for p in parts if p])

    class Meta:
        managed = False
        db_table = 'doctoraddress'
        
class Doctorschedule(models.Model):
    doctor = models.ForeignKey('Doctor', models.DO_NOTHING)
    doctor_address = models.ForeignKey('Doctoraddress', models.DO_NOTHING)
    day_of_week = models.CharField(max_length=9)
    start_time = models.TimeField()
    end_time = models.TimeField()
    slot_duration = models.IntegerField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    
    @property
    def time_range(self):
        return f"{self.start_time.strftime('%I:%M %p')} - {self.end_time.strftime('%I:%M %p')}"

    class Meta:
        managed = False
        db_table = 'doctorschedule'


class Doctortimeslot(models.Model):
    schedule = models.ForeignKey('Doctorschedule', models.DO_NOTHING)
    slot_date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    is_booked = models.IntegerField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'doctortimeslot'
        unique_together = (('schedule', 'slot_date', 'start_time'),)
        
class Prescription(models.Model):
    patient = models.ForeignKey('patient.User', models.DO_NOTHING)
    doctor = models.ForeignKey('Doctor', models.DO_NOTHING)
    appointment = models.ForeignKey('appointment.Doctorappointment', models.DO_NOTHING, blank=True, null=True)
    date = models.DateField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    
    def __str__(self):
        return f"Prescription {self.id} for {self.patient}"

    class Meta:
        managed = False
        db_table = 'prescription'

class Prescribedmedication(models.Model):
    pk = models.CompositePrimaryKey('prescription_id', 'medication_name')
    prescription = models.ForeignKey('Prescription', models.DO_NOTHING)
    medication_name = models.CharField(max_length=100)
    dose = models.CharField(max_length=100, blank=True, null=True)
    period = models.IntegerField()
    dosage_strength = models.CharField(max_length=100, blank=True, null=True)
    note = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    
    @property
    def is_expired(self):
        expiration_date = self.created_at + timedelta(days=self.period)
        return timezone.now() > expiration_date

    class Meta:
        managed = False
        db_table = 'prescribedmedication'
