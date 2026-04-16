# This file contains the bulk_stop endpoint code to be added to ActivityLogViewSet
# Add this method to the ActivityLogViewSet class in views.py

"""
    @action(detail=False, methods=['post'], url_path='bulk-stop')
    def bulk_stop(self, request):
        '''Stop all activity logs for the same task on the same day with synchronized status'''
        from datetime import datetime
        try:
            from zoneinfo import ZoneInfo
        except ImportError:
            from backports.zoneinfo import ZoneInfo
        
        # Get input parameters
        today_plan_id = request.data.get('today_plan_id')
        date_str = request.data.get('date')  # e.g., '2026-04-16'
        is_completed = request.data.get('is_completed', False)
        work_notes = request.data.get('work_notes', '')
        minutes_left = request.data.get('minutes_left', 0)
        extra_minutes = request.data.get('extra_minutes') or 0
        
        # Get custom start and end times if provided
        start_time_str = request.data.get('start_time', '').strip()
        end_time_str = request.data.get('end_time', '').strip()
        
        if not today_plan_id or not date_str:
            return Response(
                {"error": "today_plan_id and date are required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Try to get the plan
        try:
            today_plan = TodayPlan.objects.get(id=today_plan_id)
        except TodayPlan.DoesNotExist:
            return Response(
                {"error": "Today plan not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Find ALL activity logs for this plan on this date with IN_PROGRESS status
        activity_logs = ActivityLog.objects.filter(
            today_plan=today_plan,
            status='IN_PROGRESS'
        )
        
        if not activity_logs.exists():
            return Response(
                {"error": "No in-progress activities found for this plan"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Define timezone
        try:
            kolkata_tz = ZoneInfo('Asia/Kolkata')
        except Exception:
            kolkata_tz = timezone.get_current_timezone()
        
        current_kolkata_time = timezone.now().astimezone(kolkata_tz)
        today_kolkata = current_kolkata_time.date()
        
        # Calculate total times
        total_minutes_worked = 0
        total_hours_worked = 0.0
        
        with transaction.atomic():
            for activity_log in activity_logs:
                # Update start time if provided
                if start_time_str:
                    try:
                        start_time_obj = None
                        for fmt in ['%I:%M %p', '%H:%M']:
                            try:
                                start_time_obj = datetime.strptime(start_time_str, fmt).time()
                                break
                            except ValueError:
                                continue
                        
                        if start_time_obj:
                            if activity_log.actual_start_time:
                                activity_log.actual_start_time = activity_log.actual_start_time.replace(
                                    hour=start_time_obj.hour,
                                    minute=start_time_obj.minute,
                                    second=start_time_obj.second
                                )
                            else:
                                activity_log.actual_start_time = timezone.make_aware(
                                    datetime.combine(today_kolkata, start_time_obj),
                                    kolkata_tz
                                )
                    except Exception as e:
                        debugPrint(f'Error updating start time: {e}')
                
                # Update end time if provided
                if end_time_str:
                    try:
                        end_time_obj = None
                        for fmt in ['%I:%M %p', '%H:%M']:
                            try:
                                end_time_obj = datetime.strptime(end_time_str, fmt).time()
                                break
                            except ValueError:
                                continue
                        
                        if end_time_obj:
                            activity_log.actual_end_time = timezone.make_aware(
                                datetime.combine(today_kolkata, end_time_obj),
                                kolkata_tz
                            )
                    except Exception as e:
                        debugPrint(f'Error updating end time: {e}')
                
                # Calculate time worked
                if activity_log.actual_end_time:
                    delta = activity_log.actual_end_time - activity_log.actual_start_time
                    minutes = int(delta.total_seconds() / 60)
                    activity_log.minutes_worked = minutes
                    activity_log.hours_worked = round(minutes / 60, 2)
                    total_minutes_worked += minutes
                
                # Add extra minutes to all entries
                activity_log.extra_minutes = extra_minutes
                
                # Update work notes
                if work_notes:
                    activity_log.work_notes = work_notes
                
                # Update status fields based on completion flag
                activity_log.is_task_completed = is_completed
                activity_log.status = 'COMPLETED' if is_completed else 'PENDING'
               activity_log.save()
            
            # Calculate aggregated totals for ALL entries
            total_hours_worked = round(total_minutes_worked / 60, 2)
            
            # Handle pending task creation (only if marked as pending, one entry per task per day)
            if not is_completed:
                # Check if a pending task already exists for this plan on this date
                existing_pending = Pending.objects.filter(
                    today_plan=today_plan,
                    user=request.user,
                    created_at__date=today_kolkata
                ).first()
                
                if not existing_pending:
                    # Create a new pending entry (only ONE per task per day)
                    Pending.objects.create(
                        today_plan=today_plan,
                        user=request.user,
                        minutes_left=minutes_left or 0,
                        work_notes=work_notes
                    )
        
        return Response({
            "message": f"Updated {activity_logs.count()} activity logs",
            "total_time_worked": {
                "minutes": total_minutes_worked,
                "hours": total_hours_worked
            },
            "status": "COMPLETED" if is_completed else "PENDING",
            "activity_count": activity_logs.count()
        })
"""
