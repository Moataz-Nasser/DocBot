import os

dirs = ['patient', 'doctor', 'systemadmin']
base_dir = r'c:\Users\Fix-Dell\Downloads\DocBot-main (2)\DocBot-main'
patterns = ['delete', 'cancel', 'update', 'edit', 'manage']

for d in dirs:
    app_dir = os.path.join(base_dir, d, 'templates', d)
    if not os.path.exists(app_dir): continue
    for f in os.listdir(app_dir):
        if not f.endswith('.html'): continue
        filepath = os.path.join(app_dir, f)
        with open(filepath, 'r', encoding='utf-8') as file:
            lines = file.readlines()
        for i, line in enumerate(lines):
            # Form check
            if '<form' in line and 'method="post"' in line.lower():
                if any(p in line.lower() for p in patterns):
                    if 'onsubmit=' not in line.lower():
                        print(f'FILE: {d}/{f} LINE: {i+1} TYPE: FORM CODE: {line.strip()}')
            # Button check
            elif '<button' in line.lower() and 'type="submit"' in line.lower():
                # We need to make sure this button is inside a form that does update/delete/cancel
                # A simple check is if the button text itself says Update or Delete or Cancel
                if any(p in line.lower() for p in patterns):
                    if 'onclick=' not in line.lower() and 'onsubmit=' not in line.lower():
                        print(f'FILE: {d}/{f} LINE: {i+1} TYPE: BUTTON CODE: {line.strip()}')
