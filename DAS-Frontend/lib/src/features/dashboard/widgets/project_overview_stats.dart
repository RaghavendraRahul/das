import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/routes/app_router.dart';

enum StatCategory { portfolio, timeline, completion, attention }

class ProjectOverviewStats extends ConsumerWidget {
  final List<ProjectWithTasks> projects;
  final int? totalCountOverride;

  const ProjectOverviewStats({
    super.key,
    required this.projects,
    this.totalCountOverride,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always show the cards, even with empty projects (display zeros)
    final totalProjects = totalCountOverride ?? projects.length;
    final activeProjects = projects.where((p) => p.isActive).length;
    final completedProjects = projects.where((p) => p.isCompleted).length;

    // Timeline calculation
    final now = DateTime.now();
    final overdueCount = projects
        .where((p) =>
            p.isActive &&
            p.tasks.any((t) => t.progress < 100 && t.endDate.isBefore(now)))
        .length;
    final onTrackCount = activeProjects - overdueCount;

    // Task Completion
    final allTasks = projects.expand((p) => p.tasks).toList();
    final totalTasks = allTasks.length;
    final completedTasks = allTasks.where((t) => t.progress == 100).length;

    // Attention
    final criticalCount = allTasks
        .where((t) =>
            t.task.priority == 'High' &&
            t.progress < 100 &&
            t.endDate.isBefore(now))
        .length;

    void showCategoryModal(StatCategory category) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => _StatsModal(
          category: category,
          projects: projects,
          onSelectProject: (projectId) {
            Navigator.of(ctx).pop();
            ref.read(selectedProjectIdProvider.notifier).state = projectId;
            context.router.navigate(const ProjectPlanRoute());
          },
        ),
      );
    }

    return Column(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          int crossAxisCount = 1;
          if (constraints.maxWidth > 600) crossAxisCount = 2;
          if (constraints.maxWidth > 1000) crossAxisCount = 4;

          return GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _StatCard(
                title: "Project Portfolio",
                count: totalProjects,
                sub1: activeProjects,
                sub1Label: "Active",
                sub2: completedProjects,
                sub2Label: "Done",
                icon: Icons.folder_open_rounded,
                color: Colors.white,
                isPrimary: false, // Turned off to match Figma's white card
                progressOverride:
                    totalProjects > 0 ? completedProjects / totalProjects : 0,
                strokeColor: const Color(0xFF0F518B), // Primary Brand
                onTap: () => showCategoryModal(StatCategory.portfolio),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
              _StatCard(
                title: "Timeline Health",
                count: activeProjects,
                sub1: onTrackCount,
                sub1Label: "On Track",
                sub2: overdueCount,
                sub2Label: "Overdue",
                icon: Icons.timer_outlined,
                color: Colors.black87,
                isSub2Alert: overdueCount > 0,
                strokeColor: const Color(0xFF1E88E5), // Active Blue
                onTap: () => showCategoryModal(StatCategory.timeline),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
              _StatCard(
                title: "Task Efficiency",
                count: totalTasks,
                sub1: completedTasks,
                sub1Label: "Completed",
                sub2: totalTasks - completedTasks,
                sub2Label: "Pending",
                icon: Icons.check_box_outlined,
                color: Colors.black87,
                strokeColor: const Color(0xFF42A5F5), // Focus Blue
                onTap: () => showCategoryModal(StatCategory.completion),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
              _StatCard(
                title: "Critical Attention",
                count: criticalCount,
                sub1: criticalCount,
                sub1Label: "Critical",
                sub2: 0,
                sub2Label: "Rejected",
                icon: Icons.notifications_active_outlined,
                color: Colors.black87,
                isSub1Alert: criticalCount > 0,
                isCritical: criticalCount > 0,
                strokeColor: const Color(0xFF94A3B8), // Slate Blue (Attention)
                onTap: () => showCategoryModal(StatCategory.attention),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
            ],
          );
        }),
      ],
    );
  }
}

/// Modal dialog showing list of projects/tasks for a category
class _StatsModal extends StatelessWidget {
  final StatCategory category;
  final List<ProjectWithTasks> projects;
  final ValueChanged<String> onSelectProject;

  const _StatsModal({
    required this.category,
    required this.projects,
    required this.onSelectProject,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    String title;
    List<_ModalItem> items;

    switch (category) {
      case StatCategory.portfolio:
        title = "Project Portfolio";
        items = projects.map((p) {
          final isDone = p.isCompleted;
          return _ModalItem(
            id: p.project.id,
            name: p.project.name,
            subtext: "${p.tasks.length} tasks",
            statusText: isDone ? "Closed" : "Active",
            statusColor: isDone ? Colors.green : Colors.blue,
            isClickable: true,
          );
        }).toList();
        break;

      case StatCategory.timeline:
        title = "Timeline Health (Active Projects)";
        items = projects.where((p) => p.isActive).map((p) {
          final hasOverdue =
              p.tasks.any((t) => t.progress < 100 && t.endDate.isBefore(now));
          return _ModalItem(
            id: p.project.id,
            name: p.project.name,
            subtext: hasOverdue ? "Contains overdue tasks" : "On Schedule",
            statusText: hasOverdue ? "At Risk" : "On Track",
            statusColor: hasOverdue ? Colors.red : Colors.teal,
            isClickable: true,
          );
        }).toList();
        break;

      case StatCategory.completion:
        title = "Task Completion Status";
        items = [];
        for (final p in projects) {
          for (final t in p.tasks) {
            final isDone = t.progress == 100;
            items.add(_ModalItem(
              id: p.project.id, // Changed to project.id for routing
              name: t.task.name,
              subtext: p.project.name,
              statusText: isDone ? "Done" : "${t.progress}%",
              statusColor: isDone ? Colors.green : Colors.grey,
              isClickable: true,
            ));
          }
        }
        break;

      case StatCategory.attention:
        title = "Critical Attention & Blockers";
        items = [];
        for (final p in projects) {
          for (final t in p.tasks) {
            if (t.task.priority == 'High' &&
                t.progress < 100 &&
                t.endDate.isBefore(now)) {
              items.add(_ModalItem(
                id: p.project.id, // Changed to project.id for routing
                name: t.task.name,
                subtext: "${p.project.name} • Due ${_formatDate(t.endDate)}",
                statusText: "CRITICAL",
                statusColor: Colors.red,
                isClickable: true,
              ));
            }
          }
        }
        if (items.isEmpty) {
          items.add(_ModalItem(
            id: "empty",
            name: "No critical issues found",
            subtext: "Great job keeping things on track!",
            statusText: "Safe",
            statusColor: Colors.green,
            isClickable: false,
          ));
        }
        break;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        isDark ? const Color(0xFF374151) : Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: isDark ? const Color(0xFF1F2937) : Colors.grey.shade50,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "NAME",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    "STATUS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Items list
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: isDark
                      ? const Color(0xFF374151).withValues(alpha: 0.3)
                      : Colors.grey.shade100,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: item.isClickable
                        ? () => onSelectProject(item.id)
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.subtext,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: item.statusColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.statusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: item.statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.grey.shade50,
                border: Border(
                  top: BorderSide(
                    color:
                        isDark ? const Color(0xFF374151) : Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return "${months[date.month - 1]} ${date.day}";
  }
}

class _ModalItem {
  final String id;
  final String name;
  final String subtext;
  final String statusText;
  final Color statusColor;
  final bool isClickable;

  _ModalItem({
    required this.id,
    required this.name,
    required this.subtext,
    required this.statusText,
    required this.statusColor,
    required this.isClickable,
  });
}

class _StatCard extends StatefulWidget {
  final String title;
  final int count;
  final int sub1;
  final String sub1Label;
  final int sub2;
  final String sub2Label;
  final IconData icon;
  final Color color;
  final bool isSub1Alert;
  final bool isSub2Alert;
  final bool isPrimary;
  final bool isCritical;
  final double? progressOverride;
  final Color strokeColor;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.count,
    required this.sub1,
    required this.sub1Label,
    required this.sub2,
    required this.sub2Label,
    required this.icon,
    required this.color,
    required this.strokeColor,
    this.isSub1Alert = false,
    this.isSub2Alert = false,
    this.isPrimary = false,
    this.isCritical = false,
    this.progressOverride,
    this.onTap,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark 
        ? const Color(0xFF1E293B).withValues(alpha: 0.95) 
        : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final titleColor = isDark ? Colors.white70 : const Color(0xFF0F518B);
    
    // Deeper, more sophisticated shadows
    final shadowColor = isDark 
        ? Colors.black.withValues(alpha: 0.4) 
        : const Color(0xFF64748B).withValues(alpha: 0.15);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            gradient: isDark 
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E293B),
                      Color(0xFF0F172A),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.indigo.withValues(alpha: 0.05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: _isHovered ? 40 : 30,
                spreadRadius: _isHovered ? 4 : 2,
                offset: Offset(0, _isHovered ? 15 : 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(16),
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
                        color: widget.strokeColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TOP ROW: Title & Icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: titleColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? Colors.indigo.withValues(alpha: 0.1) 
                                    : Colors.indigo.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: isDark 
                                        ? Colors.indigo.withValues(alpha: 0.2) 
                                        : Colors.indigo.withValues(alpha: 0.1)),
                              ),
                              child: Icon(
                                widget.icon,
                                size: 20,
                                color: isDark ? Colors.indigoAccent[100] : Colors.indigoAccent,
                              ),
                            ),
                          ],
                        ),
                    const SizedBox(height: 2),

                    // TOTALS ROW
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          widget.count.toString(),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Totals",
                          style: TextStyle(
                            fontSize: 12,
                            color: titleColor,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Divider Line
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: isDark ? Colors.white10 : Colors.grey.shade100,
                    ),

                    // SUB-STATS (Bottom Left/Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SubStat(
                          value: widget.sub1,
                          label: widget.sub1Label,
                          isAlert: widget.isSub1Alert,
                          isPrimary: false,
                          textColor: textColor,
                          labelColor: titleColor,
                        ),
                        _SubStat(
                          value: widget.sub2,
                          label: widget.sub2Label,
                          isAlert: widget.isSub2Alert,
                          isPrimary: false,
                          textColor: textColor,
                          labelColor: titleColor,
                          alignEnd: true,
                        ),
                      ],
                    ),

                    // PROGRESS BAR exactly mimicking Figma style
                    Builder(
                      builder: (context) {
                        double total = (widget.sub1 + widget.sub2).toDouble();
                        if (total == 0) {
                          total = widget.count > 0 ? widget.count.toDouble() : 1.0;
                        }
                        double progress = widget.progressOverride ?? (widget.sub1 / total);
                        int percentage = (progress * 100).round();

                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 3, // Thinner line
                                    backgroundColor: isDark
                                        ? Colors.white.withAlpha(20)
                                        : Colors.grey.shade200,
                                    color: (widget.isCritical || percentage < 30) // example color logic
                                        ? Colors.red
                                        : (isDark
                                            ? Colors.blue.shade400
                                            : Colors.blue.shade500),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$percentage%',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ],
                  ),
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

class _SubStat extends StatelessWidget {
  final int value;
  final String label;
  final bool isAlert;
  final bool isPrimary;
  final Color textColor;
  final Color labelColor;
  final bool alignEnd;

  const _SubStat({
    required this.value,
    required this.label,
    required this.isAlert,
    required this.isPrimary,
    required this.textColor,
    required this.labelColor,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600, // Matched figma font weights (not bold but w600)
            color: isAlert && !isPrimary ? Colors.red : textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: labelColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
