from schedular.models import Task, Projects, SubTask
try:
    t = Task.objects.get(title='dash')
    print(f'Task: {t.title} (ID: {t.id})')
    print(f'Project: {t.project.name} (Planned budget: {t.project.planned_hours})')
    print(f'Task Planned: {t.planned_hours}')
    subtasks = t.subtasks.all()
    print(f'Subtasks count: {subtasks.count()}')
    for s in subtasks:
        print(f' - {s.title}: {s.status}')
    print(f'Calculated Progress: {t.calculate_progress()}')
except Exception as e:
    print(f'Error: {e}')
