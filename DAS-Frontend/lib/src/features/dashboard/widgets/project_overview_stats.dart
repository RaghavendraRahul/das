import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/routes/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../critical_attention_provider.dart';

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

    // Attention - Centralized Sync
    final criticalItemsAsync = ref.watch(criticalItemsProvider);
    final criticalItemsList = criticalItemsAsync.valueOrNull ?? [];
    final totalAttentionCount = criticalItemsList.length;

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
          if (constraints.maxWidth > 650) crossAxisCount = 2;
          if (constraints.maxWidth > 1200) crossAxisCount = 4;

          // Use mainAxisExtent (fixed card height) so content NEVER overflows,
          // regardless of screen width. Cards are always 168px tall.
          return GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 220,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
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
                strokeColor: const Color(0xFF05263E),
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
                strokeColor: const Color(0xFF05263E),
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
                strokeColor: const Color(0xFF05263E),
                onTap: () => showCategoryModal(StatCategory.completion),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
              _StatCard(
                title: "Critical Attention",
                count: totalAttentionCount,
                sub1: totalAttentionCount,
                sub1Label: "Critical",
                sub2: 0,
                sub2Label: "",
                icon: Icons.notifications_active_outlined,
                color: Colors.black87,
                isSub1Alert: totalAttentionCount > 0,
                isCritical: totalAttentionCount > 0,
                strokeColor: const Color(0xFF05263E),
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
class _StatsModal extends ConsumerWidget {
  final StatCategory category;
  final List<ProjectWithTasks> projects;
  final ValueChanged<String> onSelectProject;

  const _StatsModal({
    required this.category,
    required this.projects,
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
        final criticalItemsAsync = ref.read(criticalItemsProvider);
        final criticalItemsList = criticalItemsAsync.valueOrNull ?? [];

        for (final item in criticalItemsList) {
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
                        isDark ? const Color(0xFF05263E).withOpacity(0.7) : Colors.grey.shade200,
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
                      ? const Color(0xFF05263E).withOpacity(0.7).withOpacity(0.3)
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
                        isDark ? const Color(0xFF05263E).withOpacity(0.7) : Colors.grey.shade200,
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
        ? const Color(0xFF0B1A2E)
        : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF05263E);          // Max contrast
    final mutedColor = isDark ? const Color(0xFFB0C8E0) : const Color(0xFF05263E).withOpacity(0.7); // Muted but visible
    
    // Deeper, more sophisticated shadows
    final shadowColor = isDark 
        ? Colors.black.withOpacity(0.5) 
        : const Color(0xFF05263E).withOpacity(0.12);

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
                      Color(0xFF0B1A2E),
                      Color(0xFF081526),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF162D4A) : const Color(0xFFD4E2F0),
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
                    width: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            widget.strokeColor.withOpacity(0.6),
                            widget.strokeColor,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                     padding: const EdgeInsets.fromLTRB(18, 16, 14, 10),
                     child: LayoutBuilder(builder: (context, cc) {
                       final isCompact = cc.maxWidth < 260;
                       final iconSz   = isCompact ? 18.0 : 20.0;
                       final iconPad  = isCompact ?  8.0 :  9.0;
                       final countSz  = isCompact ? 28.0 : 32.0;
                       final titleSz  = isCompact ? 13.0 : 15.0;
                       final subValSz = isCompact ? 14.0 : 16.0;
                       final subLblSz = isCompact ?  9.0 : 10.0;
                       final vGap     = isCompact ?  6.0 : 10.0;
                       return Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          // TOP ROW: Title & Icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title.toUpperCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: titleSz,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                        color: widget.strokeColor,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: isCompact ? 1 : 2),
                                    Container(
                                      height: 2,
                                      width: isCompact ? 20 : 28,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            widget.strokeColor,
                                            widget.strokeColor.withOpacity(0.2),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                             Container(
                               padding: EdgeInsets.all(iconPad),
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: isDark 
                                     ? widget.strokeColor.withOpacity(0.15) 
                                     : widget.strokeColor.withOpacity(0.1),
                                 border: Border.all(
                                     color: isDark 
                                         ? widget.strokeColor.withOpacity(0.3) 
                                         : widget.strokeColor.withOpacity(0.2)),
                               ),
                               child: Icon(
                                 widget.icon,
                                 size: iconSz,
                                 color: isDark ? Colors.white : widget.strokeColor,
                               ),
                             ),
                           ],
                         ),
                      SizedBox(height: vGap),

                      // TOTALS ROW
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.count.toString(),
                                style: GoogleFonts.outfit(
                                  fontSize: countSz,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Totals',
                            style: GoogleFonts.outfit(
                              fontSize: isCompact ? 9 : 11,
                              fontWeight: FontWeight.w600,
                              color: mutedColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: vGap),

                    // Divider Line
                    Divider(
                      height: isCompact ? 10 : 18,
                      thickness: 1,
                      color: isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFD4E2F0),
                    ),

                    // SUB-STATS (Bottom Left/Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.sub1Label.isNotEmpty)
                          _SubStat(
                            value: widget.sub1,
                            label: widget.sub1Label,
                            isAlert: widget.isSub1Alert,
                            isPrimary: false,
                            textColor: textColor,
                            labelColor: mutedColor,
                            valueFontSize: subValSz,
                            labelFontSize: subLblSz,
                          ),
                        if (widget.sub2Label.isNotEmpty)
                          _SubStat(
                            value: widget.sub2,
                            label: widget.sub2Label,
                            isAlert: widget.isSub2Alert,
                            isPrimary: false,
                            textColor: textColor,
                            labelColor: mutedColor,
                            alignEnd: true,
                            valueFontSize: subValSz,
                            labelFontSize: subLblSz,
                          ),
                      ],
                    ),

                    const Spacer(),

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
                          padding: EdgeInsets.only(top: isCompact ? 0 : 2.0),
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
                                  style: GoogleFonts.inter(
                                    fontSize: isCompact ? 9.0 : 11.0,
                                    fontWeight: FontWeight.w700,
                                    color: mutedColor,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    ],
                    ); // end return Column
                  }), // end LayoutBuilder
                  ),  // end Padding
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
  final double valueFontSize;
  final double labelFontSize;

  const _SubStat({
    required this.value,
    required this.label,
    required this.isAlert,
    required this.isPrimary,
    required this.textColor,
    required this.labelColor,
    this.alignEnd = false,
    this.valueFontSize = 17,
    this.labelFontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          value.toString(),
          style: GoogleFonts.inter(
            fontSize: valueFontSize,
            fontWeight: FontWeight.w700,
            color: isAlert && !isPrimary ? Colors.red : textColor,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: labelFontSize,
            color: labelColor,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
