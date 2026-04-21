# patient
from datetime import date
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    phone = models.CharField(max_length=11, blank=True, null=True)
    role = models.CharField(max_length=20, default='Patient')
    deleted_at = models.DateTimeField(blank=True, null=True)
    
    @property
    def is_patient(self):
        return self.role == 'Patient'
    
    @property
    def is_doctorassistant(self):
        return self.role == 'Doctor_Assistant'

    @property
    def is_doctor(self):
        return self.role == 'Doctor'

    @property
    def is_moderator(self):
        return self.role == 'Moderator'

    @property
    def is_super_admin(self):
        return self.role == 'Super_Admin'
    
    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}".strip()

    class Meta:
        db_table = 'user'

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
    
    @property
    def age(self):
        if self.date_of_birth:
            today = date.today()
            return today.year - self.date_of_birth.year - (
                (today.month, today.day) < (self.date_of_birth.month, self.date_of_birth.day)
            )
        return None

    class Meta:
        managed = False
        db_table = 'patientprofile'

class Allergies(models.Model):
    pk = models.CompositePrimaryKey('patient_id', 'allergy_name')
    patient = models.ForeignKey('User', models.DO_NOTHING)
    allergy_name = models.CharField(max_length=100)
    severity = models.CharField(max_length=100, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    
    def __str__(self):
        return f"{self.allergy_name} - {self.patient}"

    class Meta:
        managed = False
        db_table = 'allergies'
        

class Chronicdiseases(models.Model):
    pk = models.CompositePrimaryKey('patient_id', 'disease_name')
    patient = models.ForeignKey('User', models.DO_NOTHING)
    disease_name = models.CharField(max_length=255)
    diagnosis_date = models.DateField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

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

    class Meta:
        managed = False
        db_table = 'currentmedications'
        
class Diagnosis(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    diagnosis_name = models.CharField(max_length=255)
    doctor_name = models.CharField(max_length=255, blank=True, null=True)
    date = models.DateField()
    created_by = models.ForeignKey('User', models.DO_NOTHING, db_column='created_by', related_name='diagnosis_created_by_set')
    appointment = models.ForeignKey('appointment.Doctorappointment', models.DO_NOTHING, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'diagnosis'
        
class Familyhistory(models.Model):
    pk = models.CompositePrimaryKey('patient_id', 'disease_id')
    patient = models.ForeignKey('User', models.DO_NOTHING)
    disease = models.ForeignKey('systemadmin.Inheritablediseases', models.DO_NOTHING)
    inherited_from = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

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

    class Meta:
        managed = False
        db_table = 'formersurgeries'
        
class Labtests(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    test_name = models.CharField(max_length=255)
    result_file = models.CharField(max_length=255, blank=True, null=True)
    date = models.DateField()
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'labtests'
        
class Medicalscans(models.Model):
    patient = models.ForeignKey('User', models.DO_NOTHING)
    type = models.CharField(max_length=255)
    date = models.DateField()
    result_file = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'medicalscans'
        
class Vitalmeasurements(models.Model):
    patient = models.ForeignKey(User, models.DO_NOTHING)
    measurement_type = models.ForeignKey("systemadmin.Measurementtypes", models.DO_NOTHING)
    value = models.FloatField()
    value_secondary = models.FloatField(blank=True, null=True)
    date = models.DateField()
    time = models.TimeField(blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'vitalmeasurements'
