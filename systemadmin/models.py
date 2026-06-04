# systemadmin
from django.db import models

class Inheritablediseases(models.Model):
    disease_name = models.CharField(unique=True, max_length=255)
    
    def __str__(self):
        return self.disease_name

    class Meta:
        managed = False
        db_table = 'inheritablediseases'

class Measurementtypes(models.Model):
    name = models.CharField(max_length=255)
    unit = models.CharField(max_length=255)
    
    def __str__(self):
        return f"{self.name} ({self.unit})"

    class Meta:
        managed = False
        db_table = 'measurementtypes'