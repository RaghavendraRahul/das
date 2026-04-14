import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
django.setup()

from schedular.models import User, Projects
from schedular.views import ProjectViewSet
from django.test import RequestFactory
from django.db.models import Q

def check_user_projects(user_email):
    try:
        user = User.objects.get(email=user_email)
        print(f"Checking projects for user: {user.email} (ID: {user.id})")
        
        # 1. Direct DB Query
        db_projects = Projects.objects.filter(
            Q(created_by=user) | 
            Q(assignees=user) |
            Q(project_lead=user) | 
            Q(handled_by=user) |
            Q(tasks__assignees__user=user)
        ).distinct()
        
        print(f"DB Query count (any relation): {db_projects.count()}")
        print(f"Approved: {db_projects.filter(is_approved=True).count()}")
        
        db_ids = set(db_projects.values_list('id', flat=True))
        print(f"DB Project IDs: {sorted(list(db_ids))}")
        
        # 2. Simulate API Call
        factory = RequestFactory()
        request = factory.get('/api/projects/', {'filter': 'my'})
        request.user = user
        
        view = ProjectViewSet.as_view({'get': 'list'})
        response = view(request)
        
        if hasattr(response, 'data'):
            data = response.data
            print(f"DEBUG: API Data type: {type(data)}")
            print(f"DEBUG: API Data (sample): {str(data)[:200]}")
            api_ids = []
            if isinstance(data, dict) and 'results' in data:
                api_ids = [p['id'] for p in data['results']]
            elif isinstance(data, list):
                api_ids = [p['id'] for p in data if isinstance(p, dict) and 'id' in p]
            
            print(f"API Project IDs: {sorted(api_ids)}")


            
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_user_projects("durgasprasadag@gmail.com")
