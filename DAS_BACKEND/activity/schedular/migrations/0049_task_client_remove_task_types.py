# Generated migration for Task.client and removing task_type choices

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('schedular', '0048_client_add_projects_client'),
    ]

    operations = [
        # Add client FK to Task
        migrations.AddField(
            model_name='task',
            name='client',
            field=models.ForeignKey(blank=True, help_text='Client for this routine task', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='routine_tasks', to='schedular.client'),
        ),
        
        # Remove task_type field (it's not being used)
        migrations.RemoveField(
            model_name='task',
            name='task_type',
        ),
    ]
