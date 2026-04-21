import os
import django
import sys

# Setup Django
sys.path.append('c:\\flutter_apps\\MERIDA PROJECTS\\HRM_DAS 1\\DAS_Backend\\activity')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
django.setup()

from schedular.models import Projects, Task
from django.utils import timezone
from datetime import timedelta

def check_counts():
    print("\n--- DONE Tasks Details ---")
    done_tasks = Task.objects.filter(status='DONE')
    for t in done_tasks:
        print(f"ID: {t.id}, Title: {t.title}, Completed At: {t.completed_at}")

if __name__ == "__main__":
    check_counts()
