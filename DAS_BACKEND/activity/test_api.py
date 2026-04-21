import os
import sys

# MUST set settings before importing anything else
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')

import django
django.setup()

from rest_framework.test import APIRequestFactory, force_authenticate
from schedular.models import User
from schedular.global_search_view import GlobalSearchAPIView

def test_api_search(query):
    factory = APIRequestFactory()
    view = GlobalSearchAPIView.as_view()
    
    # Get a test user
    user = User.objects.filter(is_active=True).first()
    if not user:
        print("No active user found for authentication")
        return

    print(f"\n--- Testing API Search for: '{query}' (User: {user.email}) ---")
    request = factory.get(f'/api/global-search/?q={query}')
    force_authenticate(request, user=user)
    
    response = view(request)
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 200:
        print(f"Results Count: {len(response.data)}")
        for item in response.data:
            print(f"  [{item['type']}] ID: {item['id']} | {item['title']} - {item['subtitle']}")
    else:
        print(f"Error: {response.data}")

if __name__ == "__main__":
    test_api_search("DAS")
    test_api_search("project")
    test_api_search("task")
    test_api_search("TASK 1")
