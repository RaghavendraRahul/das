import django, os, sys
sys.path.insert(0, '.')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
django.setup()

from django.contrib.auth import get_user_model
from schedular.models import Projects, Task
from django.db.models import Q
from django.db.models.functions import ExtractMonth
from django.db.models import Count
import calendar

User = get_user_model()

# For each user, calculate what the chart should show vs what portfolio shows
for user in User.objects.all():
    # Portfolio "Done" count (what shows in the top Project Portfolio card)
    portfolio_done = Projects.objects.filter(
        status='COMPLETED'
    ).filter(
        Q(project_lead=user) | Q(handled_by=user) | Q(created_by=user) | Q(assignees=user) | Q(tasks__assignees__user=user)
    ).distinct().count()

    # Chart "my" filter (what the line graph should show)
    chart_my = Projects.objects.filter(
        status='COMPLETED',
        completed_date__year=2026
    ).filter(
        Q(project_lead=user) | Q(handled_by=user) | Q(created_by=user) | Q(assignees=user) | Q(tasks__assignees__user=user)
    ).distinct().count()

    if portfolio_done > 0:
        print(f"USER: {user.email} ({user.role})")
        print(f"  Portfolio Done count: {portfolio_done}")
        print(f"  Chart 'my' count (2026): {chart_my}")
        
        # Monthly breakdown for chart
        monthly = (
            Projects.objects.filter(
                status='COMPLETED',
                completed_date__year=2026
            ).filter(
                Q(project_lead=user) | Q(handled_by=user) | Q(created_by=user) | Q(assignees=user) | Q(tasks__assignees__user=user)
            ).distinct()
            .annotate(month=ExtractMonth('completed_date'))
            .values('month')
            .annotate(count=Count('id'))
            .order_by('month')
        )
        for row in monthly:
            print(f"    {calendar.month_name[row['month']]}: {row['count']}")
        print()
