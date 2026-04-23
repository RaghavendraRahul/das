import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
django.setup()

from schedular.models import Task, Projects

critical_tasks = Task.objects.filter(priority='CRITICAL')
print(f"Total Critical Tasks: {critical_tasks.count()}")
for t in critical_tasks:
    print(f"  Task: {t.title}, Status: {t.status}, Project: {t.project.name}")

rejected_projects = Projects.objects.filter(approval_status='REJECTED')
print(f"Total Rejected Projects: {rejected_projects.count()}")
for p in rejected_projects:
    print(f"  Project: {p.name}, Status: {p.status}")
