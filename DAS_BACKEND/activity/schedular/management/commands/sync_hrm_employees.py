"""
Management command to sync all active employees from HRM to DAS
Usage: python manage.py sync_hrm_employees
"""
from django.core.management.base import BaseCommand
from django.utils import timezone
from django.contrib.auth.hashers import make_password
import requests
import secrets
from schedular.models import User, Employee
from rest_framework_simplejwt.tokens import RefreshToken


class Command(BaseCommand):
    help = 'Sync all active employees from HRM to DAS database'

    def add_arguments(self, parser):
        parser.add_argument(
            '--hrm-url',
            type=str,
            # default='https://hrmbackendapi.meridahr.com/',
            default='http://localhost:8001/',
            # help='HRM server URL (default: https://hrmbackendapi.meridahr.com/)'
            help='HRM server URL (default: http://localhost:8001/)'
        )

    def handle(self, *args, **options):
        # Sanitize URL (remove trailing slash)
        hrm_url = options['hrm_url'].rstrip('/')
        
        self.stdout.write(self.style.WARNING(f'Starting HRM employee sync from {hrm_url}...'))
        
        try:
            # Fetch all active employees from HRM
            response = requests.get(f'{hrm_url}/root/api/employees-active/', timeout=30)
            
            if response.status_code != 200:
                self.stdout.write(self.style.ERROR(f'Failed to fetch employees from HRM. Status: {response.status_code}'))
                return
            
            data = response.json()
            employees = data.get('employees', [])
            
            if not employees:
                self.stdout.write(self.style.WARNING('No employees found in HRM'))
                return
                
            self.stdout.write(self.style.SUCCESS(f'Found {len(employees)} active employees in HRM'))
            
            created_count = 0
            updated_count = 0
            error_count = 0
            
            for emp_data in employees:
                try:
                    email = emp_data.get('email')
                    
                    if not email:
                        self.stdout.write(self.style.WARNING(f'Skipping employee without email: {emp_data.get("full_name")}'))
                        continue
                    
                    # Map HRM designation to DAS role
                    hrm_designation = emp_data.get('designation', '')
                    
                    def get_das_role(hrm_role_str):
                        if not hrm_role_str: return 'EMPLOYEE'
                        role_l = hrm_role_str.lower()
                        if role_l in ['admin', 'administrator', 'superadmin']: return 'ADMIN'
                        if role_l in ['hr', 'manager', 'hr manager', 'head']: return 'MANAGER'
                        if role_l in ['tl', 'teamlead', 'lead', 'team lead']: return 'TEAMLEAD'
                        return 'EMPLOYEE'
                    
                    das_role = get_das_role(hrm_designation)
                    
                    # Helper for safe date parsing
                    from datetime import datetime
                    def parse_date_safe(date_str):
                        if not date_str: return None
                        try:
                            if 'T' in date_str: return datetime.fromisoformat(date_str).date()
                            return datetime.strptime(date_str, '%Y-%m-%d').date()
                        except: return None

                    # Create or update User
                    user, created = User.objects.update_or_create(
                        email=email,
                        defaults={
                            'hrm_employee_id': emp_data.get('employee_Id'),
                            'employee_name': emp_data.get('full_name'),
                            'employee_type': emp_data.get('Employeement_Type'),
                            'designation': hrm_designation,
                            'role': das_role,  # Map designation to role
                            'location': emp_data.get('work_location'),
                            'date_of_joining': parse_date_safe(emp_data.get('hired_date')),
                            'is_active_in_hrm': True,
                            'last_sync_time': timezone.now(),
                            'is_active': True,
                        }
                    )
                    
                    # Set password for new users
                    if created:
                        random_password = secrets.token_urlsafe(16)
                        user.set_password(random_password)
                        user.save()
                        created_count += 1
                        self.stdout.write(self.style.SUCCESS(f'  [CREATED] {email} ({emp_data.get("full_name")})'))
                    else:
                        updated_count += 1
                        self.stdout.write(f'  [UPDATED] {email} ({emp_data.get("full_name")})')
                    
                    # Create or update Employee profile
                    Employee.objects.update_or_create(
                        user=user,
                        defaults={
                            'email': email,
                            'name': emp_data.get('full_name'),
                            'employee_id': emp_data.get('employee_Id'),
                            'phone': emp_data.get('phone'),
                            'designation': hrm_designation,
                            'work_location': emp_data.get('work_location'),
                            'date_of_joining': parse_date_safe(emp_data.get('hired_date')),
                            'date_of_birth': parse_date_safe(emp_data.get('date_of_birth')),
                            'employment_type': emp_data.get('Employeement_Type'),
                            'hrm_employee_id': emp_data.get('employee_Id'),
                            'is_active_in_hrm': True,
                        }
                    )
                    
                except Exception as e:
                    error_count += 1
                    self.stdout.write(self.style.ERROR(f'  [ERROR] syncing {email}: {str(e)}'))
            
            self.stdout.write('')
            self.stdout.write(self.style.SUCCESS('=' * 60))
            self.stdout.write(self.style.SUCCESS(f'Sync completed!'))
            self.stdout.write(self.style.SUCCESS(f'  Created: {created_count}'))
            self.stdout.write(self.style.SUCCESS(f'  Updated: {updated_count}'))
            if error_count > 0:
                self.stdout.write(self.style.ERROR(f'  Errors:  {error_count}'))
            self.stdout.write(self.style.SUCCESS('=' * 60))
            
        except requests.exceptions.Timeout:
            self.stdout.write(self.style.ERROR('Request to HRM timed out'))
        except requests.exceptions.RequestException as e:
            self.stdout.write(self.style.ERROR(f'Failed to connect to HRM: {str(e)}'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Unexpected error: {str(e)}'))
