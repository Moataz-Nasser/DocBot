import json
import secrets
from django.shortcuts import render, redirect
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import authenticate, login
from django.contrib.auth.decorators import login_required
from django.core.cache import cache
from patient.models import (
    User, Patientprofile, Chronicdiseases, Familyhistory, 
    Allergies, Currentmedications
)
from systemadmin.models import Inheritablediseases

def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password =  request.POST.get('password')
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('chatbot_chat')
        else:
            return render(request, 'chatbot/login.html', {'error': 'Invalid credentials'})
    return render(request, 'chatbot/login.html')

@login_required(login_url='chatbot_login')
def chat_page_view(request):
    # generate a short lived token for this user
    token = secrets.token_hex(32)
    # store it in cache for 1 hour tied to this user
    cache.set(f'chatbot_token_{token}', request.user.id, timeout=3600)
    return render(request, 'chatbot/chat.html', {'chatbot_token': token})

@csrf_exempt
def webhook_view(request):
    if request.method != 'POST':
        return JsonResponse({'error': 'Method not allowed'}, status=405)
        
    token = request.headers.get('X-Chatbot-Token')
    if not token:
        return JsonResponse({'error': 'No token provided'}, status=401)
        
    user_id = cache.get(f'chatbot_token_{token}')
    if not user_id:
        return JsonResponse({'error': 'Invalid or expired token'}, status=401)
        
    try:
        data = json.loads(request.body)
        user = User.objects.get(id=user_id)
            
        patient_data = data.get('patient_data', {})
        
        # 1. Chronic Diseases
        chronic_str = patient_data.get('chronic_diseases', '')
        if chronic_str and chronic_str != "لا يوجد":
            Chronicdiseases.objects.get_or_create(
                patient_id=user, 
                disease_name=chronic_str
            )
            
        # 2. Family History
        family_str = patient_data.get('family_history', '')
        if family_str and family_str != "لا يوجد":
            disease, _ = Inheritablediseases.objects.get_or_create(disease_name=family_str[:250])
            Familyhistory.objects.get_or_create(
                patient_id=user,
                disease_id=disease,
                defaults={'inherited_from': 'Unknown'}
            )
            
        # 3. Allergies
        allergy_str = patient_data.get('allergies', '')
        if allergy_str and allergy_str != "لا يوجد":
            Allergies.objects.get_or_create(
                patient_id=user,
                allergy_name=allergy_str,
                defaults={'severity': 'Unknown'}
            )
            
        # 4. Current Medications
        meds_str = patient_data.get('current_medications', '')
        if meds_str and meds_str != "لا يوجد":
            Currentmedications.objects.get_or_create(
                patient_id=user,
                medication_name=meds_str,
                defaults={'dosage_strength': 'Unknown'}
            )
            
        return JsonResponse({'status': 'success', 'message': 'Data processed successfully'})
        
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    except User.DoesNotExist:
        return JsonResponse({'error': 'User not found'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

