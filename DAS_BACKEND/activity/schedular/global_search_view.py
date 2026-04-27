from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db import models
from django.db.models import Q
from .models import Projects, Task, SubTask, User, Catalog

class GlobalSearchAPIView(APIView):
    """
    Unified DAS search endpoint: Projects, Tasks, SubTasks, Employees, Catalog.
    Results are filtered by the requesting user's access rights.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        query = request.query_params.get('q', '').strip()
        if not query or len(query) < 2:
            return Response([])

        user = request.user
        q_lower = query.lower()

        is_searching_projects = any(q_lower.startswith(k) for k in ["project", "pro"])
        is_searching_tasks = any(q_lower.startswith(k) for k in ["task", "tas"])
        is_searching_employees = any(q_lower.startswith(k) for k in ["user", "empl", "people", "member"])

        results = []

        # --- 1. PROJECTS: filter by user access ---
        if user.role == 'ADMIN':
            base_projects = Projects.objects.all()
        else:
            base_projects = Projects.objects.filter(
                Q(created_by=user) |
                Q(assignees=user) |
                Q(project_lead=user) |
                Q(handled_by=user) |
                Q(tasks__assignees__user=user)
            ).distinct()

        if is_searching_projects:
            projects_qs = base_projects.order_by('-create_date')
        else:
            projects_qs = base_projects.filter(
                Q(name__icontains=query) |
                Q(description__icontains=query) |
                Q(approval_status__icontains=query)
            ).distinct()

        for p in projects_qs[:15]:
            results.append({
                'id': p.id,
                'type': 'PROJECT',
                'title': p.name,
                'subtitle': f"Lead: {p.project_lead.name if p.project_lead else 'No Lead'} • {p.status}",
                'status': p.status,
                'priority': 'N/A',
            })

        # --- 2. TASKS: filter by user access ---
        if user.role == 'ADMIN':
            base_tasks = Task.objects.all()
        else:
            base_tasks = Task.objects.filter(
                Q(assignees__user=user) |
                Q(project__created_by=user) |
                Q(project__project_lead=user)
            ).distinct()

        if is_searching_tasks:
            tasks_qs = base_tasks.order_by('-created_at')
        else:
            tasks_qs = base_tasks.filter(
                Q(title__icontains=query) |
                Q(status__icontains=query) |
                Q(priority__icontains=query)
            ).distinct()

        for t in tasks_qs[:10]:
            results.append({
                'id': t.id,
                'project_id': t.project.id if t.project else 0,
                'type': 'TASK',
                'title': t.title,
                'subtitle': f"Project: {t.project.name if t.project else 'No Project'} • {t.status}",
                'status': t.status,
                'priority': t.priority,
            })

        # --- 3. SUBTASKS ---
        if user.role == 'ADMIN':
            subtask_base = SubTask.objects.all()
        else:
            subtask_base = SubTask.objects.filter(
                Q(task__assignees__user=user) |
                Q(task__project__project_lead=user)
            ).distinct()

        subtasks_qs = subtask_base.filter(
            Q(title__icontains=query) | Q(status__icontains=query)
        ).distinct()

        for s in subtasks_qs[:5]:
            proj_id = s.task.project.id if s.task and s.task.project else 0
            proj_name = s.task.project.name if s.task and s.task.project else ''
            results.append({
                'id': s.id,
                'project_id': proj_id,
                'type': 'SUBTASK',
                'title': s.title,
                'subtitle': f"{proj_name} › {s.task.title if s.task else ''}",
                'status': 'COMPLETED' if s.is_completed else 'PENDING',
                'priority': 'SUB',
            })

        # --- 4. EMPLOYEES ---
        if is_searching_employees:
            users_qs = User.objects.filter(is_active=True).order_by('employee_name')
        else:
            users_qs = User.objects.filter(
                Q(employee_name__icontains=query) |
                Q(email__icontains=query)
            ).filter(is_active=True).distinct()

        for u in users_qs[:5]:
            results.append({
                'id': u.id,
                'type': 'EMPLOYEE',
                'title': u.name,
                'subtitle': f"{u.email} • {u.role or 'N/A'}",
                'status': 'ACTIVE' if u.is_active else 'INACTIVE',
                'priority': u.role or 'N/A',
            })

        # --- 5. CATALOG ---
        catalog_qs = Catalog.objects.filter(
            Q(name__icontains=query) |
            Q(catalog_type__icontains=query)
        )
        for c in catalog_qs[:5]:
            results.append({
                'id': c.id,
                'type': 'CATALOG',
                'title': c.name,
                'subtitle': f"Type: {c.catalog_type or 'General'}",
                'status': 'N/A',
                'priority': 'N/A',
            })

        return Response(results)
