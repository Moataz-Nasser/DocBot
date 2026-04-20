# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth.models import AbstractUser

class Allergies(models.Model):
    pk = models.CompositePrimaryKey('patient_id', 'allergy_name')
    patient = models.ForeignKey('User', models.DO_NOTHING)
    allergy_name = models.CharField(max_length=100)
    severity = models.CharField(max_length=100, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'allergies'


class Appointmentnote(models.Model):
    appointment = models.ForeignKey('Doctorappointment', models.DO_NOTHING)
    doctor = models.ForeignKey('Doctor', models.DO_NOTHING)
    note = models.TextField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'appointmentnote'
        unique_together = (('appointment', 'id'),)


class Appointmentsymptoms(models.Model):
    appointment = models.ForeignKey('Doctorappointment', models.DO_NOTHING)
    patient = models.ForeignKey('User', models.DO_NOTHING)
    symptom_name = models.CharField(max_length=100)
    severity = models.CharField(max_length=50, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'appointmentsymptoms'


class Chronicdiseases(models.Model):
    pk = models.CompositePrimaryKey('patient_id', 'disease_name')
    patient = models.ForeignKey('User', models.DO_NOTHING)
    disease_name = models.CharField(max_length=255)
    diagnosis_date = models.DateField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'chronicdiseases'


class Currentmedications(models.Model):
    pk = models.CompositePrimaryKey('patient_id', 'medication_name')
    patient = models.ForeignKey('User', models.DO_NOTHING)
    medication_name = models.CharField(max_length=255)
    dosage_strength = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'currentmedications'


class Diagnosis(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    diagnosis_name = models.CharField(max_length=255)
    doctor_name = models.CharField(max_length=255, blank=True, null=True)
    date = models.DateField()
    created_by = models.ForeignKey('User', models.DO_NOTHING, db_column='created_by', related_name='diagnosis_created_by_set')
    appointment = models.ForeignKey('Doctorappointment', models.DO_NOTHING, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'diagnosis'


class Doctor(models.Model):
    user = models.OneToOneField('User', models.DO_NOTHING, primary_key=True)
    specialization = models.CharField(max_length=255)
    years_of_experience = models.IntegerField()
    price = models.FloatField()
    image = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'doctor'


class Doctoraddress(models.Model):
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    floor = models.CharField(max_length=50, blank=True, null=True)
    building_number = models.IntegerField(blank=True, null=True)
    street = models.CharField(max_length=255)
    governorate = models.CharField(max_length=255)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'doctoraddress'


class Doctorappointment(models.Model):
    slot = models.ForeignKey('Doctortimeslot', models.DO_NOTHING)
    patient = models.ForeignKey('User', models.DO_NOTHING)
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    doctor_address = models.ForeignKey(Doctoraddress, models.DO_NOTHING)
    status = models.CharField(max_length=11)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    parent_appointment = models.ForeignKey('self', models.DO_NOTHING, blank=True, null=True)
    is_follow_up = models.IntegerField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'doctorappointment'


class Doctorassistant(models.Model):
    user = models.OneToOneField('User', models.DO_NOTHING, primary_key=True)
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    created_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'doctorassistant'


class Doctorreview(models.Model):
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    patient = models.ForeignKey('User', models.DO_NOTHING)
    appointment = models.ForeignKey(Doctorappointment, models.DO_NOTHING)
    rating = models.IntegerField()
    comment = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'doctorreview'


class Doctorschedule(models.Model):
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    doctor_address = models.ForeignKey(Doctoraddress, models.DO_NOTHING)
    day_of_week = models.CharField(max_length=9)
    start_time = models.TimeField()
    end_time = models.TimeField()
    slot_duration = models.IntegerField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'doctorschedule'


class Doctortimeslot(models.Model):
    schedule = models.ForeignKey(Doctorschedule, models.DO_NOTHING)
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


class Familyhistory(models.Model):
    pk = models.CompositePrimaryKey('patient_id', 'disease_id')
    patient = models.ForeignKey('User', models.DO_NOTHING)
    disease = models.ForeignKey('Inheritablediseases', models.DO_NOTHING)
    inherited_from = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'familyhistory'


class Formersurgeries(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    surgery_name = models.CharField(max_length=255)
    date = models.DateField()
    doctor_name = models.CharField(max_length=100, blank=True, null=True)
    hospital_name = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'formersurgeries'


class Inheritablediseases(models.Model):
    disease_name = models.CharField(unique=True, max_length=255)

    class Meta:
        managed = False
        db_table = 'inheritablediseases'


class Labtests(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    test_name = models.CharField(max_length=255)
    result_file = models.CharField(max_length=255, blank=True, null=True)
    date = models.DateField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'labtests'


class Measurementtypes(models.Model):
    name = models.CharField(max_length=255)
    unit = models.CharField(max_length=255)

    class Meta:
        managed = False
        db_table = 'measurementtypes'


class Medicalscans(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    type = models.CharField(max_length=255)
    date = models.DateField()
    result_file = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'medicalscans'


class Medicationreminder(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    prescription = models.ForeignKey('Prescription', models.DO_NOTHING)
    medication_name = models.CharField(max_length=255)
    start_date = models.DateField()
    end_date = models.DateField()
    repeat_interval_days = models.IntegerField()
    note = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'medicationreminder'


class Notification(models.Model):
    user = models.ForeignKey('User', models.DO_NOTHING)
    title = models.CharField(max_length=255)
    message = models.TextField()
    is_allowed = models.IntegerField()
    created_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'notification'


class Patientprofile(models.Model):
    user = models.OneToOneField('User', models.DO_NOTHING, primary_key=True)
    date_of_birth = models.DateField(blank=True, null=True)
    gender = models.CharField(max_length=6, blank=True, null=True)
    blood_type = models.CharField(max_length=3, blank=True, null=True)
    weight = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    height = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    is_smoker = models.IntegerField(blank=True, null=True)
    is_left_handed = models.IntegerField(blank=True, null=True)
    emergency_contact_name = models.CharField(max_length=255, blank=True, null=True)
    emergency_contact_phone = models.CharField(max_length=11, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'patientprofile'


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
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prescribedmedication'


class Prescription(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    doctor = models.ForeignKey(Doctor, models.DO_NOTHING)
    appointment = models.ForeignKey(Doctorappointment, models.DO_NOTHING, blank=True, null=True)
    date = models.DateField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'prescription'


class Remindertimes(models.Model):
    pk = models.CompositePrimaryKey('reminder_id', 'time')
    reminder = models.ForeignKey(Medicationreminder, models.DO_NOTHING)
    time = models.TimeField()

    class Meta:
        managed = False
        db_table = 'remindertimes'

class User(AbstractUser):
    phone = models.CharField(max_length=11, blank=True, null=True)
    role = models.CharField(max_length=11, default='Patient')
    deleted_at = models.DateTimeField(blank=True, null=True)

    # Tell Django auth to use 'role' for checking permissions
    @property
    def is_doctor(self):
        return self.role == 'Doctor'

    @property
    def is_moderator(self):
        return self.role == 'Moderator'

    @property
    def is_super_admin(self):
        return self.role == 'Super_Admin'

    class Meta:
        db_table = 'user'


class Vitalmeasurements(models.Model):
    patient = models.ForeignKey(User, models.DO_NOTHING)
    measurement_type = models.ForeignKey(Measurementtypes, models.DO_NOTHING)
    value = models.FloatField()
    value_secondary = models.FloatField(blank=True, null=True)
    date = models.DateField()
    time = models.TimeField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    deleted_at = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'vitalmeasurements'
