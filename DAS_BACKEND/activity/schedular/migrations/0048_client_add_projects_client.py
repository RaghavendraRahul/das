# Generated migration for Client model and Projects.client FK

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('schedular', '0047_alter_stickynote_options_stickynote_order'),
    ]

    operations = [
        # Create Client model
        migrations.CreateModel(
            name='Client',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('client_name', models.CharField(help_text='Name of the client', max_length=255)),
                ('company_name', models.CharField(help_text='Name of the company', max_length=255)),
                ('phone_number', models.CharField(help_text='Client phone number', max_length=20)),
                ('email', models.EmailField(help_text='Client email address', max_length=254)),
                ('is_approved', models.BooleanField(default=False)),
                ('approval_status', models.CharField(blank=True, help_text='Current approval status: PENDING, APPROVED, REJECTED', max_length=50, null=True)),
                ('rejection_reason', models.TextField(blank=True, help_text='Reason for rejection if applicable', null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('created_by', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='created_clients', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-created_at'],
            },
        ),
        
        # Add client FK to Projects
        migrations.AddField(
            model_name='projects',
            name='client',
            field=models.ForeignKey(blank=True, help_text='Client associated with this project', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='projects', to='schedular.client'),
        ),
        
        # Update ApprovalRequest to include CLIENT reference type
        migrations.AlterField(
            model_name='approvalrequest',
            name='reference_type',
            field=models.CharField(choices=[('PROJECT', 'Project'), ('TASK', 'Task'), ('CLIENT', 'Client')], max_length=20),
        ),
    ]
