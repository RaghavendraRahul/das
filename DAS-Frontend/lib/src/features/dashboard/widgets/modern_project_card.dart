import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';

import 'package:intl/intl.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import '../../../core/utils/user_color_service.dart';

class ModernProjectCard extends StatefulWidget {
  final ProjectWithTasks project;
  final VoidCallback? onTap;
  final bool isDark;

  const ModernProjectCard({
    super.key,
    required this.project,
    this.onTap,
    required this.isDark,
  });

  @override
  State<ModernProjectCard> createState() => _ModernProjectCardState();
}

class _ModernProjectCardState extends State<ModernProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final approvalStatus =
        widget.project.project.approvalStatus?.toLowerCase() ?? '';
    final status = widget.project.project.status.toLowerCase() ?? 'active';

    Color projectColor;
    if (status == 'completed') {
      projectColor = Colors.green;
    } else if (approvalStatus == 'pending_completion') {
      projectColor = Colors.orange;
    } else {
      switch (status) {
        case 'active':
        case 'working':
          projectColor = const Color(0xFF0F518B);
          break;
        case 'on_hold':
          projectColor = Colors.orange;
          break;
        default:
          projectColor = const Color(0xFF64748B); // Slate for others
      }
    }

    final borderColor = _isHovered
        ? projectColor.withOpacity(0.5)
        : (widget.isDark ? const Color(0xFF374151) : Colors.grey.shade200);

    final criticalCount = widget.project.tasks
        .where((t) =>
            (t.task.priority == 'Critical' || t.task.priority == 'High') &&
            t.task.progress < 100)
        .length;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedRotation(
        turns: _isHovered ? 0.005 : 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: AnimatedScale(
          scale: _isHovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1E293B) : Colors.white,
              gradient: widget.isDark 
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1E293B),
                        const Color(0xFF0F172A).withValues(alpha: 0.8),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered 
                    ? projectColor.withValues(alpha: 0.5) 
                    : (widget.isDark ? Colors.white10 : Colors.indigo.withValues(alpha: 0.05)),
                width: _isHovered ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? projectColor.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: widget.isDark ? 0.3 : 0.06),
                  blurRadius: _isHovered ? 30 : 15,
                  spreadRadius: _isHovered ? 2 : 0,
                  offset: Offset(0, _isHovered ? 12 : 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // Left Accent Stroke
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: projectColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProjectHeader(project: widget.project.project),
                          if (criticalCount > 0) ...[
                            const SizedBox(height: 6),
                            _CriticalBadge(count: criticalCount),
                          ],
                          const SizedBox(height: 12),
                          _ProjectKPISection(
                                  project: widget.project.project,
                                  tasks: widget.project.tasks,
                                  isDark: widget.isDark)
                              .animate()
                              .fadeIn(delay: 100.ms)
                              .slideX(begin: -0.1, end: 0),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _TaskPreviewSection(
                                    tasks: widget.project.tasks,
                                    isDark: widget.isDark)
                                .animate()
                                .fadeIn(delay: 200.ms)
                                .slideY(begin: 0.1, end: 0),
                          ),
                          const SizedBox(height: 12),
                          _ProjectFooter(
                                  project: widget.project,
                                  isDark: widget.isDark)
                              .animate()
                              .fadeIn(delay: 300.ms),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _ApprovalAction(
                        project: widget.project, isDark: widget.isDark),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  final dynamic
      project; // Using dynamic or specific Project model if available in context

  const _ProjectHeader({required this.project});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Determine status color
    Color statusColor;
    String statusText;

    final approvalStatus = project.approvalStatus?.toLowerCase();
    final status = project.status?.toLowerCase();

    if (status == 'completed') {
      statusColor = Colors.green;
      statusText = 'Completed';
    } else if (approvalStatus == 'pending_completion') {
      statusColor = Colors.orange;
      statusText = 'Waiting Approval';
    } else if (approvalStatus == 'rejected') {
      statusColor = Colors.red;
      statusText = 'Closure Rejected';
    } else {
      switch (status) {
        case 'active':
        case 'working':
          statusColor = Colors.blue;
          statusText = 'Open';
          break;
        case 'on_hold':
          statusColor = Colors.orange;
          statusText = 'On Hold';
          break;
        default:
          statusColor = Colors.purple;
          statusText = 'Pending Approval';
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Priority Stripe
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                right: 32.0), // Room for top-right action button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    height: 1.2,
                    color: isDark ? Colors.white : const Color(0xFF0F518B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (project.context != null &&
                    project.context.toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    project.context.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2, // Reduced to give more vertical space
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusBadge(text: statusText, color: statusColor),
                    if (project.plannedHours > 0)
                      _PlannedHoursBadge(hours: project.plannedHours),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlannedHoursBadge extends StatelessWidget {
  final double hours;

  const _PlannedHoursBadge({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer_outlined,
            size: 12,
            color: Colors.indigo,
          ),
          const SizedBox(width: 4),
          Text(
            '${hours.toStringAsFixed(1)}H PLANNED',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.indigo,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProjectKPISection extends StatelessWidget {
  final Project project;
  final List<dynamic> tasks;
  final bool isDark;

  const _ProjectKPISection({
    required this.project,
    required this.tasks,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.task.progress >= 100).length;
    // Average of backend task.progress — source of truth, not frontend re-computation
    final avgProgress = totalTasks > 0
        ? tasks.fold<double>(0, (sum, t) => sum + t.task.progress) / totalTasks
        : 0.0;
    final percentage = avgProgress.toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$percentage%',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: totalTasks > 0 ? (percentage / 100.0) : 0,
            backgroundColor:
                isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
                percentage == 100 ? Colors.green : Colors.blue),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$completedTasks/$totalTasks tasks completed',
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

class _TaskPreviewSection extends StatelessWidget {
  final List<dynamic> tasks;
  final bool isDark;

  const _TaskPreviewSection({required this.tasks, required this.isDark});

  @override
  Widget build(BuildContext context) {
    // Get top 2 active tasks (not completed)
    final activeTasks =
        tasks.where((t) => t.task.progress < 100).take(2).toList();

    if (activeTasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.grey.shade800.withOpacity(0.3)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.transparent : Colors.grey.shade100,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline,
                size: 16,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400),
            const SizedBox(width: 8),
            Text(
              'All caught up!',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      // Calculate how many tasks we can fit
      // Approx 24px per task row + 8px padding
      final availableHeight = constraints.maxHeight;
      const taskHeight = 32.0;
      final maxTasks = (availableHeight / taskHeight).floor();

      final tasksToShow = activeTasks.take(maxTasks).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: tasksToShow.map((taskWithAssignees) {
          final task = taskWithAssignees.task;
          final isHighPriority =
              task.priority == "High" || task.priority == "Critical";

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isHighPriority ? Colors.red : Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color:
                          isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isHighPriority)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HIGH',
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}

class _ProjectFooter extends StatelessWidget {
  final ProjectWithTasks project;
  final bool isDark;

  const _ProjectFooter({
    required this.project,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final project = this.project;
    final isDark = this.isDark;
    // Collect project-level assignees
    final seenIds = <int>{};
    final allAssigneesList = <Map<String, dynamic>>[];

    // Only add project-level assignees, not task-level ones.
    for (final a in project.projectAssignees) {
      // Check for multiple possible ID keys to ensure robustness across all projects
      final idVal = a['id'] ?? a['employee_id'] ?? a['user_id'];
      final id = idVal is int ? idVal : int.tryParse(idVal.toString());
      final String? role = a['role']?.toString().toUpperCase();

      if (id != null && seenIds.add(id)) {
        allAssigneesList.add({
          'id': id,
          'name': a['name'],
          'avatarUrl': a['avatar_url'],
          'role': role,
        });
      }
    }

    final assigneesList = allAssigneesList.take(3).toList();
    final extraAssignees = (allAssigneesList.length - 3).clamp(0, 99);

    final isCompleted = project.project.status.toLowerCase() == 'completed';
    final isPendingApproval =
        project.project.approvalStatus?.toLowerCase() == 'pending_completion';

    final dueDateVal = project.dueDate;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isOverdue = dueDateVal != null &&
        dueDateVal.isBefore(today) &&
        !isCompleted &&
        !isPendingApproval;

    final dueDateText =
        dueDateVal != null ? DateFormat('MMM d').format(dueDateVal) : 'No date';
    // Days remaining — only when active & future-dated (backend dueDate)
    final daysRemaining = dueDateVal != null && !isCompleted && !isOverdue
        ? dueDateVal.difference(today).inDays
        : null;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 12,
      children: [
        // Avatars + overflow chip
        PopupMenuButton<void>(
          offset: const Offset(0, 30),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          tooltip: 'All members',
          itemBuilder: (context) => allAssigneesList.map((assignee) {
            return PopupMenuItem<void>(
              enabled: false,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF374151)
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor:
                              UserColorService.getColorForUser(
                                  assignee['id']),
                          backgroundImage: assignee['avatarUrl'] != null
                              ? NetworkImage(assignee['avatarUrl']! as String)
                              : null,
                          child: assignee['avatarUrl'] == null
                              ? Text(
                                  ((assignee['name'] as String?) ?? '?')[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              : null,
                        ),
                      ),
                      // PL/TL badge overlay in dropdown
                      if ((assignee['id'].toString() ==
                                  project.projectLeadId.toString() &&
                              project.projectLeadId != null) ||
                          assignee['role'] == 'TEAMLEAD')
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: assignee['role'] == 'TEAMLEAD'
                                  ? Colors.orange.shade700
                                  : Colors.blue.shade700,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 1.5),
                            ),
                            child: Text(
                              assignee['role'] == 'TEAMLEAD' ? 'TL' : 'PL',
                              style: const TextStyle(
                                  fontSize: 6,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            (assignee['name'] as String?) ?? 'Unknown Employee',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: (assignee['id'].toString() ==
                                              project.projectLeadId.toString() &&
                                          project.projectLeadId != null ||
                                      assignee['role'] == 'TEAMLEAD')
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (assignee['id'].toString() ==
                                project.projectLeadId.toString() &&
                            project.projectLeadId != null)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.amber.withValues(alpha: 0.5),
                                  width: 0.5),
                            ),
                            child: const Text(
                              'PROJECT LEAD',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        if (assignee['role'] == 'TEAMLEAD')
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.blue.withValues(alpha: 0.5),
                                  width: 0.5),
                            ),
                            child: const Text(
                              'TEAM LEAD',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 6,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          child: SizedBox(
            height: 28,
            width: 18.0 * assigneesList.length + (extraAssignees > 0 ? 36 : 12),
            child: Stack(
              children: [
                for (int i = 0; i < assigneesList.length; i++)
                  Positioned(
                    left: i * 18.0,
                    child: Tooltip(
                      message:
                          (assigneesList[i]['name'] as String?) ?? 'Employee',
                      waitDuration: const Duration(milliseconds: 500),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isDark ? const Color(0xFF1F2937) : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor:
                              UserColorService.getColorForUser(
                                  assigneesList[i]['id']),
                          backgroundImage: assigneesList[i]['avatarUrl'] != null
                              ? NetworkImage(
                                  assigneesList[i]['avatarUrl']! as String)
                              : null,
                          child: assigneesList[i]['avatarUrl'] == null
                              ? Text(
                                  ((assigneesList[i]['name'] as String?) ??
                                          '?')[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                if (extraAssignees > 0)
                  Positioned(
                    left: assigneesList.length * 18.0,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isDark ? const Color(0xFF1F2937) : Colors.white,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '+$extraAssignees',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Due Date
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: isOverdue ? Colors.red : Colors.grey.shade500,
            ),
            const SizedBox(width: 4),
            Text(
              isOverdue ? "Overdue ($dueDateText)" : dueDateText,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isOverdue
                    ? Colors.red
                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
            if (daysRemaining != null) ...[
              const SizedBox(width: 6),
              _DaysRemainingPill(days: daysRemaining),
            ],
          ],
        ),
      ],
    );
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────────

class _CriticalBadge extends StatelessWidget {
  final int count;
  const _CriticalBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF450A0A) : Colors.red.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? Colors.red.shade900 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 11,
            color: isDark ? Colors.red.shade300 : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            '$count Critical Task${count > 1 ? 's' : ''}',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.red.shade300 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DaysRemainingPill extends StatelessWidget {
  final int days;
  const _DaysRemainingPill({required this.days});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg;
    final Color fg;
    final String label;

    if (days == 0) {
      bg = isDark ? const Color(0xFF431407) : Colors.orange.shade50;
      fg = isDark ? Colors.orange.shade300 : Colors.orange.shade700;
      label = 'Due today';
    } else if (days <= 3) {
      bg = isDark ? const Color(0xFF431407) : Colors.orange.shade50;
      fg = isDark ? Colors.orange.shade300 : Colors.orange.shade700;
      label = '${days}d left';
    } else {
      bg = isDark ? const Color(0xFF052E16) : Colors.green.shade50;
      fg = isDark ? Colors.green.shade300 : Colors.green.shade700;
      label = '${days}d left';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: fg.withAlpha(80)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _ApprovalAction extends ConsumerStatefulWidget {
  final ProjectWithTasks project;
  final bool isDark;

  const _ApprovalAction({required this.project, required this.isDark});

  @override
  ConsumerState<_ApprovalAction> createState() => _ApprovalActionState();
}

class _ApprovalActionState extends ConsumerState<_ApprovalAction> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final isDark = widget.isDark;

    final isCompleted = project.project.status.toLowerCase() == 'completed';
    final isPendingApproval =
        project.project.approvalStatus?.toLowerCase() == 'pending_completion';
    final isRejected =
        project.project.approvalStatus?.toLowerCase() == 'rejected';
    final canRequestCompletion = !isCompleted && !isPendingApproval;

    if (canRequestCompletion) {
      return InkWell(
        onTap: _isLoading
            ? null
            : () async {
                setState(() => _isLoading = true);
                try {
                  final hasPendingTasks =
                      project.tasks.any((t) => t.task.progress < 100);
                  if (hasPendingTasks) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Cannot complete project. Some tasks are still pending.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    return;
                  }

                  final isAdmin =
                      ref.read(currentUserProvider).valueOrNull?.role ==
                          'ADMIN';

                  if (isAdmin) {
                    await ref
                        .read(projectRepositoryProvider)
                        .adminCompleteProject(project.project.id);
                    
                    // --- GLOBAL REACTIVITY ---
                    ref.invalidate(apiProjectsProvider);
                    ref.invalidate(projectsWithTasksProvider);
                    ref.invalidate(paginatedDashboardProjectsProvider);
                    ref.invalidate(projectsPageProjectsProvider);
                    ref.invalidate(currentProjectProvider);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Project marked as Completed'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    await ref
                        .read(projectRepositoryProvider)
                        .requestProjectCompletion(project.project.id);
                    
                    // --- GLOBAL REACTIVITY ---
                    ref.invalidate(apiTasksProvider);
                    ref.invalidate(projectsWithTasksProvider);
                    ref.invalidate(pendingProjectClosuresProvider);
                    ref.invalidate(paginatedDashboardProjectsProvider);
                    ref.invalidate(projectsPageProjectsProvider);
                    ref.invalidate(currentProjectProvider);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Project closure request sent for approval'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Failed: ${e.toString().replaceAll("Exception:", "").trim()}'),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.green.withOpacity(_isLoading ? 0.1 : 0.2)
                : Colors.green.shade50,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.green.withOpacity(0.5)
                  : Colors.green.shade300,
              width: 1.5,
            ),
          ),
          child: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.green.shade700,
                  ),
                )
              : Icon(
                  isRejected ? Icons.refresh : Icons.check,
                  size: 16,
                  color: isRejected ? Colors.red : Colors.green.shade700,
                ),
        ),
      );
    } else if (isPendingApproval) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isDark
                  ? Colors.orange.withOpacity(0.5)
                  : Colors.orange.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: Icon(Icons.hourglass_empty,
                  size: 10, color: Colors.orange.shade700),
            ).animate(onPlay: (c) => c.repeat()).rotate(duration: 2.seconds),
            const SizedBox(width: 4),
            Text(
              'Waiting Approval',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ),
      );
    } else if (isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? Colors.green.withOpacity(0.2) : Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isDark
                  ? Colors.green.withOpacity(0.5)
                  : Colors.green.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 12, color: Colors.green.shade700),
            const SizedBox(width: 4),
            Text(
              'Completed',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
