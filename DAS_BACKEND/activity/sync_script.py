import requests
from schedular.models import User

res = requests.get('http://127.0.0.1:8001/api/employees-active/', timeout=10)
data = res.json().get('employees', [])
for emp in data:
    if emp.get('email'):
        name = f"{emp.get('full_name') or ''} {emp.get('last_name') or ''}".strip()
        User.objects.update_or_create(email=emp['email'], defaults={'employee_name': name})
print('Synced', len(data), 'employees')
