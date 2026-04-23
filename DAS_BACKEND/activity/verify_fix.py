import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
django.setup()

from schedular.models import Task, Projects

# Exact logic from views.py
projects = Projects.objects.all()
tasks = Task.objects.filter(project__in=projects)

critical_tasks = tasks.filter(priority='CRITICAL').exclude(status='DONE').exclude(project__status='COMPLETED').count()
rejected_projects = projects.filter(approval_status='REJECTED').exclude(status='COMPLETED').count()

total_critical = critical_tasks + rejected_projects

print(f"Critical Tasks (Filtered): {critical_tasks}")
print(f"Rejected Projects (Filtered): {rejected_projects}")
print(f"Total Critical Attention: {total_critical}")

if total_critical == 1:
    print("\nSUCCESS: Count is now 1 as expected.")
else:
    print(f"\nFAILURE: Count is {total_critical}, expected 1.")
