import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import '../../../core/utils/user_color_service.dart';

@RoutePage()
class ProjectGridPage extends HookConsumerWidget {
  const ProjectGridPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(currentProjectProvider);

    return projectAsync.when(
      data: (data) {
        if (data == null) {
          return const Scaffold(
            body: Center(child: Text("Project not found")),
          );
        }
        return _ProjectGridView(project: data);
      },
      error: (err, st) => Scaffold(body: Center(child: Text("Error: $err"))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
    );
  }
}

class _ProjectGridView extends StatelessWidget {
  final ProjectWithTasks project;
  const _ProjectGridView({required this.project});

  @override
  Widget build(BuildContext context) {
    // Sort tasks by start date
    final sortedTasks = [...project.tasks]
      ..sort((a, b) => a.task.startDate.compareTo(b.task.startDate));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Project Header Row
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Grid View',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            // Grid Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isDark
                          ? const Color(0xFF374151)
                          : Colors.grey.shade200),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: isDark
                                  ? const Color(0xFF374151)
                                  : Colors.grey.shade200),
                        ),
                        color: isDark
                            ? Colors.grey.shade800.withOpacity(0.5)
                            : Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell("TASK NAME",
                              flex: 4, isDark: isDark),
                          _buildHeaderCell("ASSIGNEES",
                              flex: 2, isDark: isDark),
                          _buildHeaderCell("START DATE",
                              flex: 2, isDark: isDark),
                          _buildHeaderCell("END DATE", flex: 2, isDark: isDark),
                          _buildHeaderCell("PROGRESS", flex: 3, isDark: isDark),
                          _buildHeaderCell("STATUS", flex: 2, isDark: isDark),
                        ],
                      ),
                    ),
                    // List
                    Expanded(
                      child: ListView.separated(
                        itemCount: sortedTasks.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: isDark
                              ? const Color(0xFF374151)
                              : Colors.grey.shade200,
                        ),
                        itemBuilder: (context, index) {
                          final t = sortedTasks[index];
                          final task = t.task;

                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                // Task Name
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          task.name,
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.grey.shade900,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (task.approvalStatus ==
                                          'pending_creation')
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? Colors.yellow.shade900
                                                    .withOpacity(0.3)
                                                : Colors.yellow.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            "NEW",
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.yellow.shade300
                                                  : Colors.yellow.shade800,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                                // Assignees
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 28,
                                        width: 80,
                                        child: Stack(
                                          children: [
                                            for (int i = 0;
                                                i < t.assignees.take(3).length;
                                                i++)
                                              Positioned(
                                                left: i * 18.0,
                                                child: Tooltip(
                                                  message: t.assignees[i].name,
                                                  preferBelow: false,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: isDark
                                                            ? theme.cardColor
                                                            : Colors.white,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      backgroundColor:
                                                          UserColorService
                                                              .getColorForUser(
                                                                  t.assignees[i]
                                                                      .id),
                                                      backgroundImage: t
                                                              .assignees[i]
                                                              .avatarUrl
                                                              .isNotEmpty
                                                          ? NetworkImage(t
                                                              .assignees[i]
                                                              .avatarUrl)
                                                          : null,
                                                      child: t.assignees[i]
                                                              .avatarUrl.isEmpty
                                                          ? Text(
                                                              t.assignees[i]
                                                                  .name[0]
                                                                  .toUpperCase(),
                                                              style: GoogleFonts
                                                                  .inter(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )
                                                          : null,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Start Date
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    DateFormat('MMM d').format(task.startDate),
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                // End Date
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    DateFormat('MMM d').format(task.endDate),
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                // Progress
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 24.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: LinearProgressIndicator(
                                              value: task.progress / 100,
                                              minHeight: 6,
                                              backgroundColor: isDark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade200,
                                              color: _getProgressColor(
                                                  task.progress),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "${task.progress.toInt()}%",
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.grey.shade300
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Status
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _buildStatusBadge(task, isDark),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text,
      {required int flex, required bool isDark}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 11,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getProgressColor(int progress) {
    if (progress >= 100) return Colors.green;
    if (progress > 50) return Colors.blue;
    return Colors.orange;
  }

  Widget _buildStatusBadge(Task task, bool isDark) {
    final today = DateTime.now();
    Color bg;
    Color text;
    String label;

    if (task.approvalStatus == 'pending_creation') {
      bg = isDark
          ? Colors.yellow.shade900.withOpacity(0.3)
          : Colors.yellow.shade100;
      text = isDark ? Colors.yellow.shade300 : Colors.yellow.shade800;
      label = "New";
    } else if (task.approvalStatus == 'pending_completion') {
      bg = isDark
          ? Colors.orange.shade900.withOpacity(0.3)
          : Colors.orange.shade100;
      text = isDark ? Colors.orange.shade300 : Colors.orange.shade800;
      label = "Awaiting Approval";
    } else if (task.approvalStatus == 'approved' && task.progress >= 100) {
      bg = isDark
          ? Colors.green.shade900.withOpacity(0.3)
          : Colors.green.shade100;
      text = isDark ? Colors.green.shade300 : Colors.green.shade800;
      label = "Verified";
    } else if (task.approvalStatus == 'rejected') {
      bg = isDark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade100;
      text = isDark ? Colors.red.shade300 : Colors.red.shade800;
      label = "Rejected";
    } else if (task.progress < 100 && task.endDate.isBefore(today)) {
      final days = today.difference(task.endDate).inDays;
      bg = isDark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50;
      text = isDark ? Colors.red.shade300 : Colors.red;
      label = "Delayed (${days}d)";
    } else if (task.progress >= 100) {
      bg = isDark
          ? Colors.green.shade900.withOpacity(0.3)
          : Colors.green.shade100;
      text = isDark ? Colors.green.shade300 : Colors.green.shade800;
      label = "Completed";
    } else {
      bg = isDark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50;
      text = isDark ? Colors.blue.shade300 : Colors.blue.shade700;
      label = "In Progress";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: text,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
