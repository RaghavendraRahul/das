
import os
import django
import sys

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
sys.path.append(os.getcwd())
django.setup()

from schedular.models import ActivityLog, TodayPlan, Pending
from django.utils import timezone

def check_logs():
    print("=== PLANNER LOGS VERIFICATION ===")
    
    # Check TodayPlans
    print("\n--- Latest 10 TodayPlans ---")
    plans = TodayPlan.objects.all().order_by('-id')[:10]
    for p in plans:
        title = 'N/A'
        if p.catalog_item:
            title = p.catalog_item.name
        elif p.custom_title:
            title = p.custom_title
        
        print(f"ID: {p.id:4} | Status: {p.status:15} | Date: {p.plan_date} | Task: {title}")

    # Check ActivityLogs
    # Check ActivityLogs
    print("\n--- Latest 10 ActivityLogs ---")
    logs = ActivityLog.objects.all().order_by('-id')[:10]
    for l in logs:
        # Get start/end times in local for readability
        start = l.actual_start_time.strftime('%H:%M') if l.actual_start_time else 'N/A'
        end = l.actual_end_time.strftime('%H:%M') if l.actual_end_time else 'N/A'
        print(f"ID: {l.id:4} | PlanID: {l.today_plan_id:4} | Status: {l.status:10} | Time: {start}-{end} | Extra: {l.extra_minutes:3}m | Notes: {l.work_notes}")

    # Check Pending
    print("\n--- Latest 5 Pending Entries ---")
    pendings = Pending.objects.all().order_by('-id')[:5]
    if not pendings.exists():
        print("No pending records found.")
    for pt in pendings:
        print(f"ID: {pt.id:4} | PlanID: {pt.today_plan.id if pt.today_plan else 'N/A'} | Created: {pt.created_at.strftime('%Y-%m-%d %H:%M')} | Reason: {pt.reason}")

if __name__ == '__main__':
    check_logs()
