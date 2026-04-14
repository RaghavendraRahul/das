import django, os, sys
sys.path.insert(0, '.')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
django.setup()

from schedular.models import Projects, Task
from django.db.models.functions import ExtractMonth
from django.db.models import Count
import calendar

print('=== PROJECT COMPLETION BY MONTH (2026) ===')
projects_by_month = (
    Projects.objects
    .filter(status='COMPLETED', completed_date__year=2026)
    .annotate(month=ExtractMonth('completed_date'))
    .values('month')
    .annotate(count=Count('id'))
    .order_by('month')
)
total = 0
for row in projects_by_month:
    total += row['count']
    print(f"  {calendar.month_name[row['month']]}: {row['count']} projects")
print(f'  TOTAL: {total}')

print()
print('=== TASK COMPLETION BY MONTH (2026) ===')
tasks_by_month = (
    Task.objects
    .filter(status='DONE', completed_at__year=2026)
    .annotate(month=ExtractMonth('completed_at'))
    .values('month')
    .annotate(count=Count('id'))
    .order_by('month')
)
task_total = 0
for row in tasks_by_month:
    task_total += row['count']
    print(f"  {calendar.month_name[row['month']]}: {row['count']} tasks")
print(f'  TOTAL: {task_total}')

print()
null_p = Projects.objects.filter(status='COMPLETED', completed_date__isnull=True).count()
null_t = Task.objects.filter(status='DONE', completed_at__isnull=True).count()
print(f'NULL completed_date (projects): {null_p}')
print(f'NULL completed_at (tasks): {null_t}')
