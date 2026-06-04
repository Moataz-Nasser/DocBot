import os

base_dir = r'c:\Users\Fix-Dell\Downloads\DocBot-main (2)\DocBot-main'

replacements = [
    # patient/appointment_detail.html
    (r"patient\templates\patient\appointment_detail.html",
     '<form method="post" action="{% url \'patient_review_delete\' review.id %}">',
     '<form method="post" action="{% url \'patient_review_delete\' review.id %}" onsubmit="return confirm(\'Are you sure you want to delete this review?\');">'),

    # patient/diagnoses.html
    (r"patient\templates\patient\diagnoses.html",
     '<form method="post" action="{% url \'patient_diagnosis_delete\' d.id %}" style="display:inline;">',
     '<form method="post" action="{% url \'patient_diagnosis_delete\' d.id %}" style="display:inline;" onsubmit="return confirm(\'Are you sure you want to delete this diagnosis?\');">'),

    # patient/diagnosis_edit.html
    (r"patient\templates\patient\diagnosis_edit.html",
     '<form method="post">',
     '<form method="post" onsubmit="return confirm(\'Are you sure you want to update this record?\');">'),

    # patient/medical_profile.html
    (r"patient\templates\patient\medical_profile.html",
     '<form method="post" action="{% url \'medical_profile_update\' %}">',
     '<form method="post" action="{% url \'medical_profile_update\' %}" onsubmit="return confirm(\'Are you sure you want to update your medical profile?\');">'),

    # patient/profile_edit.html
    (r"patient\templates\patient\profile_edit.html",
     '<form method="post" action="{% url \'patient_profile_edit\' %}" class="needs-validation" novalidate>',
     '<form method="post" action="{% url \'patient_profile_edit\' %}" class="needs-validation" novalidate onsubmit="return confirm(\'Are you sure you want to update your profile?\');">'),

    # patient/review_form.html
    (r"patient\templates\patient\review_form.html",
     '<form method="post">',
     '<form method="post" onsubmit="return confirm(\'Are you sure you want to proceed?\');">'),

    # doctor/appointment_detail.html
    (r"doctor\templates\doctor\appointment_detail.html",
     '<form method="post" action="{% url \'doctor_appointment_cancel\' appointment.id %}">',
     '<form method="post" action="{% url \'doctor_appointment_cancel\' appointment.id %}" onsubmit="return confirm(\'Are you sure you want to cancel this appointment?\');">'),
    
    (r"doctor\templates\doctor\appointment_detail.html",
     '<form method="post" action="{% url \'doctor_diagnosis_manage\' appointment.id %}" style="margin:0;">',
     '<form method="post" action="{% url \'doctor_diagnosis_manage\' appointment.id %}" style="margin:0;" onsubmit="return confirm(\'Are you sure you want to delete this diagnosis?\');">'),

    (r"doctor\templates\doctor\appointment_detail.html",
     '<form method="post" action="{% url \'doctor_notes_manage\' appointment.id %}" style="margin:0;">',
     '<form method="post" action="{% url \'doctor_notes_manage\' appointment.id %}" style="margin:0;" onsubmit="return confirm(\'Are you sure you want to delete this note?\');">'),

    # doctor/edit_price.html
    (r"doctor\templates\doctor\edit_price.html",
     '<form method="post">',
     '<form method="post" onsubmit="return confirm(\'Are you sure you want to update the pricing?\');">'),

    # systemadmin/doctor_addresses.html
    (r"systemadmin\templates\systemadmin\doctor_addresses.html",
     '<form method="post" action="{% url \'admin_doctor_address_edit\' doctor.user_id addr.id %}">',
     '<form method="post" action="{% url \'admin_doctor_address_edit\' doctor.user_id addr.id %}" onsubmit="return confirm(\'Are you sure you want to update this address?\');">'),

    # systemadmin/users.html
    (r"systemadmin\templates\systemadmin\users.html",
     '<form method="post" action="{% url \'admin_user_edit_role\' u.id %}">',
     '<form method="post" action="{% url \'admin_user_edit_role\' u.id %}" onsubmit="return confirm(\'Are you sure you want to update this user role?\');">'),

    # systemadmin/doctor_form.html
    (r"systemadmin\templates\systemadmin\doctor_form.html",
     '<form method="post" enctype="multipart/form-data">',
     '<form method="post" enctype="multipart/form-data" onsubmit="{% if doctor %}return confirm(\'Are you sure you want to update this doctor?\');{% endif %}">')
]

for rel_path, old_str, new_str in replacements:
    path = os.path.join(base_dir, rel_path)
    if not os.path.exists(path):
        print(f"File not found: {path}")
        continue
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if old_str in content:
        content = content.replace(old_str, new_str)
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {rel_path}")
    else:
        print(f"String not found in {rel_path}:\n{old_str}")
