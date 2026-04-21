# ازاي تحمل وتشتغل على المشروع؟
1. دوس على الزرار الاسمه كود اللونه اخضر وحمل ملفات المشروع كـ zip file
2. استخرج الملفات الجوا الzip file
3. افتح الملف الاسمه DocBot-main في VS Code (الملف الجواه اكثر من ملف تاني زي config و manage.py)
4. افتح terminal جديدة جوا VS Code بالضغط على ctrl + `
5. جوا الterminal اعمل enironment جديدة
```
python -m venv venv
```
6. فعل الenvironment بانك تكتب ده لو انت على Windows
```
venv\Scripts\activate
```
لو على Linux
```
source venv/bin/activate
```
7. حمل المتطلبات كلها
```
pip install -r requirements.txt
```
8. غير اسم الملف .env.example الى .env فقط
9. جوا الملف الدلوقتي اسمه .env بتغير بيانات الdatabase لبيانات الdatabase الخاصة بيك
10. جرب اعمل run للمشروع لو اشتغل يبقى كل حاجا تمام
```
python manage.py runserver
```


# لو معندكش الdatabase تعمل ايه؟
1. الملف موجود بداخل الfolder الاسمه database
2. خد الكود الجواه copy واعمله run على الdatabase الموجودة عندك
