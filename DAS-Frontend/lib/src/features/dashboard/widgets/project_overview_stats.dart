import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../critical_attention_provider.dart';
import '../dashboard_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';

enum StatCategory { portfolio, timeline, completion, attention }

class ProjectOverviewStats extends ConsumerWidget {
  final List<ProjectWithTasks> projects;
  final int? totalCountOverride;
  final String searchQuery;

  const ProjectOverviewStats({
    super.key,
    required this.projects,
    required this.searchQuery,
    this.totalCountOverride,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. WATCH the backend-calculated statistics
    final statsAsync = ref.watch(dashboardOverviewStatsProvider);

    return statsAsync.when(
      loading: () => const _LoadingStats(),
      error: (err, stack) => _ErrorStats(error: err.toString()),
      data: (stats) {
        // EXTRACT data from backward provided Map
        final portfolio = stats['project_portfolio'] ?? {};
        final timeline = stats['timeline_health'] ?? {};
        final efficiency = stats['task_efficiency'] ?? {};
        final attention = stats['critical_attention'] ?? {};

        // Portfolio values
        final totalProjects = portfolio['total'] ?? 0;
        final activeProjects = portfolio['active'] ?? 0;
        final completedProjects = portfolio['done'] ?? 0;

        // Timeline values
        final onTrackCount = timeline['on_track'] ?? 0;
        final overdueCount = timeline['overdue'] ?? 0;

        // Efficiency values
        final totalTasks = efficiency['total'] ?? 0;
        final completedTasks = efficiency['completed'] ?? 0;
        final pendingTasks = efficiency['pending'] ?? 0;

        // Attention values
        final totalAttentionCount = attention['total'] ?? 0;
        final criticalCount = attention['critical'] ?? 0;
        final rejectedCount = attention['rejected'] ?? 0;

        void showCategoryModal(StatCategory category) {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (ctx) => _StatsModal(
              category: category,
              projects: projects,
              searchQuery: searchQuery,
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
              if (constraints.maxWidth > 700) crossAxisCount = 2;
              if (constraints.maxWidth > 1400) crossAxisCount = 4;

              return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisExtent: 200,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                children: [
                  _StatCard(
                    title: "Project Portfolio",
                    count: totalProjects,
                    sub1: activeProjects,
                    sub1Label: "Active Files",
                    sub2: completedProjects,
                    sub2Label: "Completed",
                    icon: Icons.account_balance_wallet_rounded,
                    isPrimary: false,
                    strokeColor: const Color(0xFF3B82F6),
                    progressOverride: totalProjects > 0
                        ? (completedProjects / totalProjects)
                        : 0,
                    onTap: () => showCategoryModal(StatCategory.portfolio),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  _StatCard(
                    title: "Timeline Health",
                    count: activeProjects,
                    sub1: onTrackCount,
                    sub1Label: "On-Track",
                    sub2: overdueCount,
                    sub2Label: "Delayed",
                    icon: Icons.shield_rounded,
                    isSub2Alert: overdueCount > 0,
                    // Risk view: progress = % of delayed projects
                    // 0% = all healthy ✅   |   100% = all overdue 🔴
                    progressOverride: activeProjects > 0
                        ? (overdueCount / activeProjects)
                        : 0.0,
                    strokeColor: const Color(0xFF1D4ED8), // Fixed Royal Blue
                    onTap: () => showCategoryModal(StatCategory.timeline),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  _StatCard(
                    title: "Task Efficiency",
                    count: totalTasks,
                    sub1: completedTasks,
                    sub1Label: "Completed",
                    sub2: pendingTasks,
                    sub2Label: "Pending",
                    icon: Icons.bolt_rounded,
                    strokeColor: const Color(0xFF14B8A6),
                    onTap: () => showCategoryModal(StatCategory.completion),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                  _StatCard(
                    title: "Critical Attention",
                    count: totalAttentionCount,
                    sub1: criticalCount,
                    sub1Label: "Blockers",
                    sub2: rejectedCount,
                    sub2Label: "Rejected",
                    icon: Icons.priority_high_rounded,
                    isSub1Alert: criticalCount > 0,
                    isSub2Alert: rejectedCount > 0,
                    isCritical: totalAttentionCount > 0,
                    strokeColor: const Color(0xFFEF4444),
                    progressOverride: totalAttentionCount > 0 ? 0.0 : 1.0,
                    onTap: () => showCategoryModal(StatCategory.attention),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}

class _LoadingStats extends StatelessWidget {
  const _LoadingStats();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorStats extends StatelessWidget {
  final String error;
  const _ErrorStats({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          "Retry failed: $error",
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

/// Modal dialog showing list of projects/tasks for a category
class _StatsModal extends ConsumerWidget {
  final StatCategory category;
  final List<ProjectWithTasks> projects;
  final String searchQuery;
  final ValueChanged<String> onSelectProject;

  const _StatsModal({
    required this.category,
    required this.projects,
    required this.searchQuery,
    required this.onSelectProject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        if (items.isEmpty && searchQuery.isNotEmpty) {
          items.add(_ModalItem(
            id: "empty",
            name: "No matches for '$searchQuery'",
            subtext: "Try checking the spelling or changing filters",
            statusText: "Not Found",
            statusColor: Colors.grey,
            isClickable: false,
          ));
        }
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

        if (items.isEmpty && searchQuery.isNotEmpty) {
          items.add(_ModalItem(
            id: "empty",
            name: "No matches for '$searchQuery'",
            subtext: "Search narrowed too far",
            statusText: "None",
            statusColor: Colors.grey,
            isClickable: false,
          ));
        }
        break;

      case StatCategory.completion:
        title = "Task Completion Status";
        items = [];
        final filterMode = ref.read(dashboardProjectTypeProvider);
        final currentUserId = ref.read(currentUserIdProvider);
        for (final p in projects) {
          for (final t in p.tasks) {
            // If 'my' mode: only show tasks where current user is an assignee
            if (filterMode == 'my' && currentUserId != null) {
              final isAssigned = t.assignees.any((u) => u.id == currentUserId);
              if (!isAssigned) continue;
            }
            final isDone = t.progress == 100;
            items.add(_ModalItem(
              id: p.project.id,
              name: t.task.name,
              subtext: p.project.name,
              statusText: isDone ? "Done" : "${t.progress}%",
              statusColor: isDone ? Colors.green : Colors.grey,
              isClickable: true,
            ));
          }
        }

        if (items.isEmpty) {
          items.add(_ModalItem(
            id: "empty",
            name: filterMode == 'my' ? "No tasks assigned to you" : "No tasks found",
            subtext: filterMode == 'my' ? "You have no task assignments in these projects" : "Try searching by project or task name",
            statusText: "Empty",
            statusColor: Colors.grey,
            isClickable: false,
          ));
        }
        break;

      case StatCategory.attention:
        title = "Critical Attention & Blockers";
        items = [];
        final criticalItemsAsync = ref.read(criticalItemsProvider);
        final allCriticalItems = criticalItemsAsync.valueOrNull ?? [];
        
        // Match filtering logic in the modal
        final filteredItems = allCriticalItems.where((item) {
          return projects.any((p) => p.project.id == item.projectId);
        }).toList();

        for (final item in filteredItems) {
          items.add(_ModalItem(
            id: item.projectId,
            name: item.title,
            subtext: item.subtitle,
            statusText: item.typeLabel,
            statusColor: item.color,
            isClickable: true,
          ));
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                        isDark ? const Color(0xFF05263E).withValues(alpha: 0.7) : Colors.grey.shade200,
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
                      ? const Color(0xFF05263E).withValues(alpha: 0.2)
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
                              color: item.statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(24),
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
                        isDark ? const Color(0xFF05263E).withValues(alpha: 0.7) : Colors.grey.shade200,
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
  final Color strokeColor;
  final bool isSub1Alert;
  final bool isSub2Alert;
  final bool isPrimary;
  final bool isCritical;
  final double? progressOverride;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.count,
    required this.sub1,
    required this.sub1Label,
    required this.sub2,
    required this.sub2Label,
    required this.icon,
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
    
    // Strict Figma Colors
    final bgColor = isDark ? const Color(0xFF0B1424) : const Color(0xFFF9FAFB);
    final shadowColor = isDark ? Colors.black45 : Colors.black.withValues(alpha: 0.03);
    final subLabelColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF9CA3AF);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: _isHovered ? 12 : 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              child: Stack(
                children: [
                  // Left Stroke: 4px, Full height, rounded left corners
                  Positioned(
                    left: 0, top: 0, bottom: 0,
                    width: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.strokeColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ICON ROW (Top-Left)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: widget.strokeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                widget.icon,
                                size: 22,
                                color: widget.strokeColor,
                              ),
                            ),
                            // Optional Badge if needed (maintaining previous logic for alerts)
                            if (widget.isCritical || widget.isSub1Alert || widget.isSub2Alert)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (widget.isCritical ? Colors.red : widget.strokeColor).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.isCritical ? 'CRITICAL' : 'OPTIMAL',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: widget.isCritical ? Colors.red : widget.strokeColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // TITLE
                        Text(
                          widget.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        
                        // MAIN METRIC
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              widget.count.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey.shade900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Total",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: isDark ? Colors.white70 : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        
                        const Spacer(),
                        const SizedBox(height: 6),
                        
                        // SUB-STATS (Active, Done, etc.)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SubStatSmall(
                              label: widget.sub1Label,
                              value: widget.sub1.toString(),
                              isAlert: widget.isSub1Alert,
                              isDark: isDark,
                              labelColor: subLabelColor,
                            ),
                            if (widget.sub2Label.isNotEmpty)
                              _SubStatSmall(
                                label: widget.sub2Label,
                                value: widget.sub2.toString(),
                                isAlert: widget.isSub2Alert,
                                isDark: isDark,
                                alignEnd: true,
                                labelColor: subLabelColor,
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // PROGRESS BAR
                        Builder(
                          builder: (context) {
                            double total = widget.count.toDouble();
                            if (total == 0) total = 1.0;
                            double prog = widget.progressOverride ?? (widget.sub1 / total);
                            return Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: prog.clamp(0.0, 1.0),
                                      minHeight: 2,
                                      backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                                      color: widget.isCritical ? Colors.red : widget.strokeColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(prog * 100).round()}%',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: subLabelColor,
                                  ),
                                ),
                              ],
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

class _SubStatSmall extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;
  final bool isDark;
  final bool alignEnd;
  final Color labelColor;

  const _SubStatSmall({
    required this.label,
    required this.value,
    required this.isAlert,
    required this.isDark,
    required this.labelColor,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isAlert ? Colors.red : (isDark ? Colors.white : Colors.black),
          ),
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: isDark ? labelColor : const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }
}
