import os
import django
import sys

# Add the project directory to sys.path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Use the correct settings module
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'activity.settings')
django.setup()

from schedular.models import Projects, Task, User

def debug_search(query):
    print(f"\n--- Searching for: '{query}' ---")
    
    # 1. Projects
    projects = Projects.objects.filter(name__icontains=query)
    print(f"Projects found: {projects.count()}")
    for p in projects:
        print(f"  - [Project] ID: {p.id}, Name: {p.name}")

    # 2. Tasks
    tasks = Task.objects.filter(title__icontains=query)
    print(f"Tasks found: {tasks.count()}")
    for t in tasks:
        print(f"  - [Task] ID: {t.id}, Title: {t.title}")

    # Check for direct ID search if query is numeric
    if query.isdigit():
        p_by_id = Projects.objects.filter(id=int(query))
        if p_by_id.exists():
            print(f"  - Found Project by direct ID: {p_by_id.first().name}")

if __name__ == "__main__":
    # Test common search terms
    test_queries = ["Project", "Task", "Meeting", "Global", "a", "s"]
    
    # Also list EVERYTHING just to see what exists
    print("--- FULL LIST OF PROJECTS ---")
    for p in Projects.objects.all():
        print(f"  - {p.id}: {p.name}")
        
    for q in test_queries:
        debug_search(q)
