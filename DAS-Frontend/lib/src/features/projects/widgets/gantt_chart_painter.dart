import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:project_pm/src/core/models/milestone.dart';
import '../../../core/utils/user_color_service.dart';

class GanttChartPainter extends CustomPainter {
  final List<TaskWithAssignees> tasks;
  final DateTime projectStart;
  final DateTime projectEnd;
  final double dayWidth;
  final double rowHeight;
  final double headerHeight;
  final double taskNameWidth;

  GanttChartPainter({
    required this.tasks,
    required this.projectStart,
    required this.projectEnd,
    required this.dayWidth,
    required this.rowHeight,
    required this.headerHeight,
    required this.taskNameWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
    );

    // 1. Setup Dates
    final totalDays = projectEnd.difference(projectStart).inDays + 1;

    // Helper: Get X for date
    double getXForDate(DateTime date) {
      if (date.isBefore(projectStart)) return taskNameWidth;
      final diff = date.difference(projectStart).inDays;
      return taskNameWidth + (diff * dayWidth);
    }

    // 2. Clear / Background
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // 3. Draw Weekend Shading (Full height)
    for (int i = 0; i < totalDays; i++) {
      final date = projectStart.add(Duration(days: i));
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        paint.color = const Color(0xFFF9FAFB); // Very light gray for weekends
        final x = taskNameWidth + (i * dayWidth);
        canvas.drawRect(
            Rect.fromLTWH(
                x, headerHeight, dayWidth, size.height - headerHeight),
            paint);
      }
    }

    // 4. Draw Header Background
    paint.color = Colors.white;
    // Add subtle shadow/border for header
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, headerHeight), paint);

    // Bottom border of header
    paint.color = const Color(0xFFE5E7EB);
    paint.strokeWidth = 1.0;
    canvas.drawLine(
        Offset(0, headerHeight), Offset(size.width, headerHeight), paint);

    // 5. Draw Calendar Headers (Days & Months)
    DateTime? lastMonth;

    for (int i = 0; i < totalDays; i++) {
      final date = projectStart.add(Duration(days: i));
      final x = taskNameWidth + (i * dayWidth);

      // Month Header (Top half of header)
      if (lastMonth == null ||
          date.month != lastMonth.month ||
          date.year != lastMonth.year) {
        // Draw Month Name
        textPainter.text = TextSpan(
          text: DateFormat('MMMM yyyy').format(date),
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x + 8, 8)); // 8px padding

        // Draw vertical separator for month start
        if (i > 0) {
          paint.color = const Color(0xFFE5E7EB);
          canvas.drawLine(Offset(x, 0), Offset(x, headerHeight), paint);
        }
        lastMonth = date;
      }

      // Day Header (Bottom half)
      bool isToday = DateFormat('yyyy-MM-dd').format(date) ==
          DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Highlight "Today" in header
      if (isToday) {
        paint.color = const Color(0xFFEFF6FF); // Blue-50
        canvas.drawRect(
            Rect.fromLTWH(x, 28, dayWidth, headerHeight - 28), paint);
      }

      // Day Number
      textPainter.text = TextSpan(
        text: date.day.toString(),
        style: TextStyle(
          color: isToday ? const Color(0xFF2563EB) : const Color(0xFF4B5563),
          fontSize: 13,
          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(x + (dayWidth - textPainter.width) / 2,
              32)); // align in bottom half

      // Day Name (M, T, W...)
      textPainter.text = TextSpan(
        text: DateFormat('E').format(date)[0],
        style: TextStyle(
          color: isToday ? const Color(0xFF2563EB) : const Color(0xFF9CA3AF),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas,
          Offset(x + (dayWidth - textPainter.width) / 2, 48)); // below number

      // Vertical Grid Line (Right side of day) - very subtle
      paint.color = const Color(0xFFF3F4F6);
      canvas.drawLine(Offset(x + dayWidth, headerHeight),
          Offset(x + dayWidth, size.height), paint);
    }

    // 6. Draw Task List Columns Background (Left Side)
    // We redraw this over the scrolled content to make it look "frozen"
    // BUT we are inside a single CustomPaint which scrolls.
    // To make it frozen, the parent widget structure would need to change.
    // For now, we draw it as part of the canvas, so it scrolls with it.
    // The previous implementation had "Sticky" intent but implemented it as just column 0.
    // We will keep it simple: It's just the first column.

    // Draw "Frozen" column background to cover grid lines
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, taskNameWidth, size.height), paint);

    // Vertical Separator
    paint.color = const Color(0xFFE5E7EB); // Gray-200
    paint.strokeWidth = 1.0;
    // Draw shadow for depth
    final shadowPath = Path();
    shadowPath.addRect(Rect.fromLTWH(taskNameWidth - 4, 0, 4, size.height));
    canvas.drawShadow(shadowPath, Colors.black, 2.0, true);

    // Redraw separator line
    canvas.drawLine(
        Offset(taskNameWidth, 0), Offset(taskNameWidth, size.height), paint);

    // Header for Task List
    paint.color = const Color(0xFFF9FAFB); // Gray-50
    canvas.drawRect(Rect.fromLTWH(0, 0, taskNameWidth, headerHeight), paint);
    canvas.drawLine(
        Offset(0, headerHeight), Offset(taskNameWidth, headerHeight), paint);

    textPainter.text = const TextSpan(
      text: "TASKS",
      style: TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5),
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(20, (headerHeight - textPainter.height) / 2));

    // 7. Draw Task Rows
    double currentY = headerHeight;
    final today = DateTime.now();

    for (int i = 0; i < tasks.length; i++) {
      final taskItem = tasks[i];
      final task = taskItem.task;

      // Row Hover/Alternating Highlight (Optional)
      // if (i % 2 == 1) {
      //   paint.color = const Color(0xFFF9FAFB);
      //   canvas.drawRect(Rect.fromLTWH(0, currentY, size.width, rowHeight), paint);
      // }

      // Separator
      paint.color = const Color(0xFFF3F4F6); // Very light
      canvas.drawLine(Offset(0, currentY + rowHeight),
          Offset(size.width, currentY + rowHeight), paint);

      // Task Name
      textPainter.text = TextSpan(
        text: task.name,
        style: const TextStyle(
            color: Color(0xFF111827), // Gray-900
            fontSize: 13,
            fontWeight: FontWeight.w500),
      );
      textPainter.layout(maxWidth: taskNameWidth - 40);
      textPainter.paint(
          canvas, Offset(20, currentY + (rowHeight - textPainter.height) / 2));

      // --- Task Bar ---

      // Calculate start/end X
      DateTime start =
          task.startDate.isBefore(projectStart) ? projectStart : task.startDate;
      DateTime end =
          task.endDate.isAfter(projectEnd) ? projectEnd : task.endDate;
      if (end.isBefore(start)) end = start;

      final barStartX = getXForDate(start);
      // end is inclusive, so +1 day for width calculation
      final durationDays = end.difference(start).inDays + 1;
      final barWidth = durationDays * dayWidth;

      const barHeight = 24.0;
      final barTop = currentY + (rowHeight - barHeight) / 2;

      final barRect = Rect.fromLTWH(
          barStartX + 4, barTop, barWidth - 8, barHeight); // +4, -8 for spacing

      // --- Color Logic ---
      Color taskColor;
      Color progressColor;
      bool isOverdue = false;

      // Ensure consistent comparison (ignore time)
      final endDateOnly =
          DateTime(task.endDate.year, task.endDate.month, task.endDate.day);
      final todayOnly = DateTime(today.year, today.month, today.day);

      if (task.progress >= 100) {
        // COMPLETED: Green
        taskColor = const Color(0xFFD1FAE5); // Green-100
        progressColor = const Color(0xFF10B981); // Green-500
      } else if (endDateOnly.isBefore(todayOnly)) {
        // OVERDUE (regardless of whether it was active yesterday)
        // Main bar is Blue (Start -> End)
        // Extension is Red (End -> Today)
        isOverdue = true;
        taskColor = const Color(0xFFDBEAFE); // Blue-100
        progressColor = const Color(0xFF3B82F6); // Blue-500
      } else {
        // ACTIVE / PENDING: Blue
        taskColor = const Color(0xFFDBEAFE); // Blue-100
        progressColor = const Color(0xFF3B82F6); // Blue-500
      }

      // --- Draw Main Bar (Start -> End) ---
      paint.color = taskColor;
      final rrect = RRect.fromRectAndRadius(barRect, const Radius.circular(4));
      canvas.drawRRect(rrect, paint);

      // --- Draw Segmented Progress Based on Milestones ---
      try {
        final List<dynamic> milestoneData = jsonDecode(task.milestonesJson);
        final List<Milestone> milestones = milestoneData
            .map((m) => Milestone.fromJson(m as Map<String, dynamic>))
            .toList();

        if (milestones.isNotEmpty) {
          double accumulatedX = barStartX + 4;
          final usableWidth = barWidth - 8;
          final totalWeight = milestones.fold<int>(0, (sum, m) => sum + m.weight);
          
          canvas.save();
          canvas.clipRRect(rrect);
          
          for (final milestone in milestones) {
            final milestoneWidth = (milestone.weight / (totalWeight > 0 ? totalWeight : 1)) * usableWidth;
            
            if (milestone.completed) {
              // Get color of the user who completed it
              paint.color = UserColorService.getColorForUser(milestone.completedById);
              final milestoneRect = Rect.fromLTWH(
                accumulatedX, 
                barTop, 
                milestoneWidth, 
                barHeight
              );
              canvas.drawRect(milestoneRect, paint);
            }
            
            accumulatedX += milestoneWidth;
          }
          canvas.restore();
        } else if (task.progress > 0) {
          // Fallback to solid progress bar if no milestones
          final progressWidth = (barWidth) * (task.progress / 100);
          final clampedProgressWidth = progressWidth > barWidth ? barWidth : progressWidth;
          final progressRect = Rect.fromLTWH(barStartX + 4, barTop, clampedProgressWidth - 8, barHeight);

          canvas.save();
          canvas.clipRRect(rrect);
          paint.color = progressColor;
          canvas.drawRect(progressRect, paint);
          canvas.restore();
        }
      } catch (e) {
        // Fallback to solid progress bar on error
        if (task.progress > 0) {
          final progressWidth = (barWidth) * (task.progress / 100);
          final clampedProgressWidth = progressWidth > barWidth ? barWidth : progressWidth;
          final progressRect = Rect.fromLTWH(barStartX + 4, barTop, clampedProgressWidth - 8, barHeight);

          canvas.save();
          canvas.clipRRect(rrect);
          paint.color = progressColor;
          canvas.drawRect(progressRect, paint);
          canvas.restore();
        }
      }

      // --- Draw Overdue Extension (End -> Today) ---
      if (isOverdue) {
        // Calculate start/end for overdue part
        // overdueStart is the day AFTER endDate
        // getXForDate(endDate) covers [startX, startX + dayWidth]
        // So start of overdue part is getXForDate(endDate) + dayWidth

        final overdueStartX = getXForDate(task.endDate) + dayWidth;

        // Duration from Day AFTER EndDate to Today (inclusive)
        // difference(today, endDate) includes the days in between
        final overdueDurationDays = todayOnly.difference(endDateOnly).inDays;

        if (overdueDurationDays > 0) {
          final overdueWidth = overdueDurationDays * dayWidth;

          // Draw slightly distinct block
          final overdueRect = Rect.fromLTWH(
              overdueStartX, barTop + 4, overdueWidth, barHeight - 8);

          paint.color = const Color(0xFFEF4444); // Red-500

          // Rounded ends
          final overdueRRect =
              RRect.fromRectAndRadius(overdueRect, const Radius.circular(4));
          canvas.drawRRect(overdueRRect, paint);
        }
      }

      // --- Border for Main Bar ---
      paint.style = PaintingStyle.stroke;
      paint.color = progressColor.withOpacity(0.3);
      paint.strokeWidth = 1;
      canvas.drawRRect(rrect, paint);
      paint.style = PaintingStyle.fill;

      // Task Text on Bar (if fits) or to Right
      final textOnBar = durationDays > 2; // Arbitrary threshold

      // We already show task name in left column.
      // User might want to see it on bar too?
      // "make professional look" -> Usually just one place.
      // But we can show %, or nothing.
      // Let's show % if > 0
      if (task.progress > 0 && task.progress < 100) {
        textPainter.text = TextSpan(
          text: "${task.progress}%",
          style: TextStyle(
              color: textOnBar
                  ? progressColor.withOpacity(0.8)
                  : const Color(0xFF6B7280),
              fontSize: 10,
              fontWeight: FontWeight.w600),
        );
        textPainter.layout();

        if (textOnBar) {
          // Center in bar
          textPainter.paint(
              canvas,
              Offset(barStartX + 4 + (barWidth - 8 - textPainter.width) / 2,
                  barTop + (barHeight - textPainter.height) / 2));
        } else {
          // Right of bar
          textPainter.paint(
              canvas,
              Offset(barStartX + 4 + barWidth,
                  barTop + (barHeight - textPainter.height) / 2));
        }
      }

      currentY += rowHeight;
    }
  }

  @override
  bool shouldRepaint(covariant GanttChartPainter oldDelegate) {
    return oldDelegate.tasks != tasks ||
        oldDelegate.dayWidth != dayWidth ||
        oldDelegate.projectStart != projectStart ||
        oldDelegate.projectEnd != projectEnd;
  }
}
