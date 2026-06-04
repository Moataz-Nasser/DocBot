import json
import re
from datetime import datetime
from decimal import Decimal
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.core.cache import cache
from django.shortcuts import render
from django.utils import timezone

# Universal imports based on schema
from patient.models import User, Chronicdiseases, Familyhistory, Allergies, Currentmedications, Formersurgeries, Vitalmeasurements, Patientprofile
from systemadmin.models import Inheritablediseases, Measurementtypes
from doctor.models import Doctor, Doctoraddress

def chat_page_view(request):
    if not request.session.session_key: request.session.create()
    request.session.save()
    token = request.session.session_key
    uid = request.user.id if request.user.is_authenticated else 1
    cache.set(f'chatbot_token_{token}', uid, 86400)
    return render(request, 'chatbot/chat.html', {'token': token})

def parse_safe_date(date_str):
    if not date_str: return None
    date_str = str(date_str).strip()
    if re.match(r'^\d{4}$', date_str): return f"{date_str}-01-01"
    if re.match(r'^\d{4}-\d{2}-\d{2}$', date_str): return date_str
    for fmt in ('%Y-%m-%d', '%d/%m/%Y', '%m/%d/%Y', '%Y/%m/%d'):
        try: return datetime.strptime(date_str, fmt).strftime('%Y-%m-%d')
        except ValueError: continue
    return None


def parse_numeric(value):
    if value is None:
        return None
    text = str(value).strip()
    match = re.search(r'([0-9]+(?:\.[0-9]+)?)', text)
    if not match:
        return None
    try:
        return Decimal(match.group(1))
    except Exception:
        return None

@csrf_exempt
def get_profile_view(request):
    token = request.headers.get('X-Chatbot-Token') or request.GET.get('token')
    user_id = cache.get(f'chatbot_token_{token}')
    if not user_id: return JsonResponse({'error': 'Unauthorized'}, status=401)
    try:
        user = User.objects.get(id=user_id)
        profile, _ = Patientprofile.objects.get_or_create(user_id=user.id, defaults={'created_at': timezone.now(), 'updated_at': timezone.now()})
        vitals = Vitalmeasurements.objects.filter(patient_id=user.id).select_related('measurement_type')
        vitals_list = [{'name': v.measurement_type.name, 'value': str(v.value)} for v in vitals]

        gender_val = profile.gender
        dob_val = str(profile.date_of_birth) if profile.date_of_birth else None
        smoker_val = "Yes" if profile.is_smoker == 1 else "No" if profile.is_smoker == 0 else None
        hand_val = "Left" if profile.is_left_handed == 1 else "Right" if profile.is_left_handed == 0 else None
        chronic = list(Chronicdiseases.objects.filter(patient_id=user.id).values('disease_name', 'diagnosis_date'))
        family = list(Familyhistory.objects.filter(patient_id=user.id).values('disease_id__disease_name', 'inherited_from'))
        allergies = list(Allergies.objects.filter(patient_id=user.id).values('allergy_name', 'severity'))
        medications = list(Currentmedications.objects.filter(patient_id=user.id).values('medication_name', 'dosage_strength'))

        # Build missing fields list for required basic profile info
        missing = []
        if not gender_val: missing.append('gender')
        if not dob_val: missing.append('date_of_birth')
        if smoker_val is None or smoker_val == "": missing.append('is_smoker')
        if hand_val is None or hand_val == "": missing.append('handedness')
        if len(allergies) == 0: missing.append('allergies')
        if len(chronic) == 0: missing.append('chronic_diseases')
        if len(medications) == 0: missing.append('current_medications')
        if len(family) == 0: missing.append('family_history')

        # Fetch list of valid inheritable diseases for family history
        valid_diseases = list(Inheritablediseases.objects.values_list('disease_name', flat=True))

        data = {
            'username': user.username,
            'gender': gender_val,
            'date_of_birth': dob_val,
            'is_smoker': smoker_val,
            'handedness': hand_val,
            'weight': str(profile.weight) if profile.weight is not None else None,
            'height': str(profile.height) if profile.height is not None else None,
            'blood_type': profile.blood_type,
            'emergency_contact_name': profile.emergency_contact_name,
            'emergency_contact_phone': profile.emergency_contact_phone,
            'chronic_diseases': chronic,
            'family_history': family,
            'allergies': allergies,
            'current_medications': medications,
            'surgeries': list(Formersurgeries.objects.filter(patient_id=user.id).values('surgery_name', 'date')),
            'vitals': vitals_list,
            'missing_fields': missing,
            'profile_complete': len(missing) == 0,
            'available_inheritable_diseases': valid_diseases
        }
        return JsonResponse(data)
    except Exception as e: return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
def webhook_view(request):
    print(f"\n{'='*60}")
    print(f"[WEBHOOK] Request received: {request.method}")
    print(f"[WEBHOOK] Raw body: {request.body[:500]}")
    token = request.headers.get('X-Chatbot-Token') or request.GET.get('token')
    print(f"[WEBHOOK] Token: {token}")
    user_id = cache.get(f'chatbot_token_{token}')
    print(f"[WEBHOOK] User ID from cache: {user_id}")
    if not user_id: 
        print("[WEBHOOK] ❌ UNAUTHORIZED - token not found in cache")
        return JsonResponse({'error': 'Unauthorized'}, status=401)
    try:
        data = json.loads(request.body)
        user = User.objects.get(id=user_id)
        patient_data = data.get('patient_data')
        print(f"[WEBHOOK] patient_data: {patient_data}")
        if not patient_data: 
            print("[WEBHOOK] ⚠️ No patient_data - returning early")
            return JsonResponse({'status': 'no data'})
        now = timezone.now()

        # FIXED: Robust PatientProfile updates
        profile, _ = Patientprofile.objects.get_or_create(user_id=user.id, defaults={'created_at': now, 'updated_at': now})
        if 'gender' in patient_data:
            g = str(patient_data['gender']).strip().capitalize()
            profile.gender = g[:6] # Enforce 6-char limit (Male/Female)
        if 'date_of_birth' in patient_data:
            dob = parse_safe_date(patient_data['date_of_birth'])
            if dob:
                profile.date_of_birth = dob
        if 'is_smoker' in patient_data: 
            s = str(patient_data['is_smoker']).lower()
            profile.is_smoker = 1 if any(x in s for x in ["yes", "1", "true", "smoker"]) else 0
        if 'handedness' in patient_data:
            h = str(patient_data['handedness']).lower()
            profile.is_left_handed = 1 if "left" in h else 0
        if 'weight' in patient_data:
            w = parse_numeric(patient_data['weight'])
            if w is not None:
                profile.weight = w
        if 'height' in patient_data:
            h = parse_numeric(patient_data['height'])
            if h is not None:
                profile.height = h
        if 'blood_type' in patient_data:
            profile.blood_type = str(patient_data['blood_type']).strip().upper()
        if 'emergency_contact_name' in patient_data:
            profile.emergency_contact_name = str(patient_data['emergency_contact_name']).strip()
        if 'emergency_contact_phone' in patient_data:
            profile.emergency_contact_phone = str(patient_data['emergency_contact_phone']).strip()
        profile.updated_at = now
        profile.save()
        print(f"[WEBHOOK] ✅ Profile saved — gender={profile.gender}, smoker={profile.is_smoker}, handed={profile.is_left_handed}, weight={profile.weight}, height={profile.height}, blood={profile.blood_type}")

        def process_universal(raw_list, model_class, name_field, mapping):
            if not raw_list: return
            items = raw_list if isinstance(raw_list, list) else [raw_list]
            for item in items:
                if not isinstance(item, dict): item = {name_field: str(item)}
                name = str(item.get(name_field) or item.get('name') or '').strip().capitalize()
                if not name or name.lower() in ["none", "no"]: continue
                update_data = {'updated_at': now}
                for ai_key, db_field in mapping.items():
                    val = item.get(ai_key) or item.get(db_field)
                    if val:
                        if 'date' in db_field: val = parse_safe_date(val)
                        if val: update_data[db_field] = str(val).strip()
                obj, created = model_class.objects.get_or_create(patient_id=user.id, **{name_field: name}, defaults={**update_data, 'created_at': now})
                if not created:
                    for k, v in update_data.items(): setattr(obj, k, v)
                    obj.save()

        process_universal(patient_data.get('chronic_diseases'), Chronicdiseases, 'disease_name', {'diagnosis_date': 'diagnosis_date'})
        process_universal(patient_data.get('allergies'), Allergies, 'allergy_name', {'severity': 'severity'})
        process_universal(patient_data.get('current_medications'), Currentmedications, 'medication_name', {'dosage': 'dosage_strength'})
        process_universal(patient_data.get('surgeries'), Formersurgeries, 'surgery_name', {'date': 'date'})
        
        rejected_diseases = []
        raw_f = patient_data.get('family_history')
        if raw_f:
            items = raw_f if isinstance(raw_f, list) else [raw_f]
            for item in items:
                if not isinstance(item, dict): item = {'name': str(item)}
                name = str(item.get('name') or item.get('disease') or '').strip().capitalize()
                rel = str(item.get('relation') or item.get('inherited_from') or "Unknown").strip().capitalize()
                if name:
                    # Only look up existing diseases — do NOT create new ones
                    try:
                        dis = Inheritablediseases.objects.get(disease_name__iexact=name)
                    except Inheritablediseases.DoesNotExist:
                        rejected_diseases.append(name)
                        continue
                    obj, _ = Familyhistory.objects.get_or_create(patient_id=user.id, disease_id=dis.id, defaults={'inherited_from': rel, 'created_at': now, 'updated_at': now})
                    if obj.inherited_from != rel:
                        obj.inherited_from = rel
                        obj.save()

        response = {'status': 'success'}
        if rejected_diseases:
            response['rejected_family_history'] = rejected_diseases
        return JsonResponse(response)
    except Exception as e: 
        import traceback; traceback.print_exc()
        return JsonResponse({'error': str(e)}, status=200) # Soft fail to prevent n8n crash

@csrf_exempt
def get_doctors_view(request):
    token = request.headers.get('X-Chatbot-Token') or request.GET.get('token')
    user_id = cache.get(f'chatbot_token_{token}')
    if not user_id: return JsonResponse({'error': 'Unauthorized'}, status=401)
    
    spec = request.GET.get('specialization', '').strip()
    if not spec:
        spec = 'Cardiology'  # Default to Cardiology for urgent cases
    
    try:
        doctors = Doctor.objects.filter(specialization__icontains=spec)[:5]
        
        if not doctors:
            doctors = Doctor.objects.all()[:5]
            
        results = []
        for d in doctors:
            addr = Doctoraddress.objects.filter(doctor_id=d.user_id).first()
            results.append({
                'name': f"Dr. {d.user.first_name} {d.user.last_name}",
                'specialization': d.specialization,
                'street': addr.street if addr else "Address available upon request"
            })
            
        return JsonResponse({'doctors': results})
    except Exception as e: 
        import traceback; traceback.print_exc()
        return JsonResponse({'doctors': []})

def login_view(request): return render(request, 'chatbot/login.html')
