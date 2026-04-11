import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/core/models/milestone.dart';
import 'package:project_pm/src/features/projects/modals/add_project_task_modal.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/user_color_service.dart';

@RoutePage()
class ProjectPlanPage extends HookConsumerWidget {
  const ProjectPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(currentProjectProvider);

    return projectAsync.when(
      data: (data) {
        if (data == null) {
          return const Scaffold(body: Center(child: Text("Project not found")));
        }
        return _ProjectPlanView(project: data);
      },
      error: (err, st) => Scaffold(body: Center(child: Text("Error: $err"))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
    );
  }
}

class _ProjectPlanView extends HookConsumerWidget {
  final ProjectWithTasks project;
  const _ProjectPlanView({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get current user to check role
    final currentUserAsync = ref.watch(currentUserProvider);
    final isAdmin = currentUserAsync.valueOrNull?.role == 'ADMIN';

    // Optimistic state
    final updatedProgressMap = useState<Map<String, int>>({});
    final updatedMilestoneMap = useState<Map<String, bool>>({});
    final updatedMilestoneAssigneeMap =
        useState<Map<String, Map<String, String?>>>({});

    useEffect(() {
      updatedProgressMap.value = {};
      updatedMilestoneMap.value = {};
      updatedMilestoneAssigneeMap.value = {};
      return null;
    }, [project]);

    final loadingTaskIds = useState<Set<String>>({});

    // Filter tasks into buckets
    final todoTasks = project.tasks.where((t) {
      final status = t.task.approvalStatus?.toLowerCase();
      
      // Check milestones completion
      List<Milestone> milestones = [];
      try {
        final decoded = jsonDecode(t.task.milestonesJson);
        if (decoded is List) {
          milestones = decoded.map((j) => Milestone.fromJson(j as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      final allMilestonesDone = milestones.isEmpty || milestones.every((m) => m.completed);

      // Tasks in Todo bucket if:
      // 1. Status is not 'pending_completion' and not 'approved' (standard todo)
      // 2. OR status is 'pending_completion' but NOT ALL milestones are done (auto-revert)
      // 3. OR status is 'approved' but NOT ALL milestones are done (fix stuck tasks)
      return (status != 'pending_completion' && status != 'approved') || 
             (status == 'pending_completion' && !allMilestonesDone) ||
             (status == 'approved' && !allMilestonesDone);
    }).toList()
      ..sort((a, b) => a.task.startDate.compareTo(b.task.startDate));

    final approvalTasks = project.tasks.where((t) {
      final status = t.task.approvalStatus?.toLowerCase();
      
      // Check milestones completion
      List<Milestone> milestones = [];
      try {
        final decoded = jsonDecode(t.task.milestonesJson);
        if (decoded is List) {
          milestones = decoded.map((j) => Milestone.fromJson(j as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      final allMilestonesDone = milestones.isNotEmpty && milestones.every((m) => m.completed);

      return status == 'pending_completion' && allMilestonesDone;
    }).toList()
      ..sort((a, b) => a.task.startDate.compareTo(b.task.startDate));

    final completedTasks = project.tasks.where((t) {
      final status = t.task.approvalStatus?.toLowerCase();
      
      // ONLY show in completed bucket if approval_status is 'approved' AND all milestones are done
      List<Milestone> milestones = [];
      try {
        final decoded = jsonDecode(t.task.milestonesJson);
        if (decoded is List) {
          milestones = decoded.map((j) => Milestone.fromJson(j as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      final allMilestonesDone = milestones.isEmpty || milestones.every((m) => m.completed);

      return status == 'approved' && allMilestonesDone;
    }).toList()
      ..sort((a, b) => a.task.startDate.compareTo(b.task.startDate));


    // Project Closure Logic
    final hasPendingTasks = project.tasks.any((t) {
      final status = t.task.approvalStatus?.toLowerCase();
      if (status != 'approved') return true;
      
      // Even if approved, check milestones are actually complete
      List<Milestone> milestones = [];
      try {
        final decoded = jsonDecode(t.task.milestonesJson);
        if (decoded is List) {
          milestones = decoded.map((j) => Milestone.fromJson(j as Map<String, dynamic>)).toList();
        }
      } catch (_) {}
      final allDone = milestones.isEmpty || milestones.every((m) => m.completed);
      return !allDone; // Still pending if milestones not done
    });

    final canClose = project.project.status != 'archived' &&
        project.project.status != 'completed';

    final isPendingClosure =
        project.project.approvalStatus?.toLowerCase() == 'pending_completion';
    final isProjectRejected =
        project.project.approvalStatus?.toLowerCase() == 'rejected';

    return Scaffold(
      floatingActionButton: canClose
          ? (isPendingClosure
              ? _buildWaitingClosureFab(context, isDark)
              : _buildRequestClosureFab(
                  context, ref, hasPendingTasks, isAdmin, isProjectRejected))
          : null,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            _buildProjectDetailsHeader(
                context, ref, isDark, theme, isProjectRejected),
            const SizedBox(height: 24),

            // Kanban Board
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TaskBucket(
                    title: "TASK BUCKET",
                    tasks: todoTasks,
                    isDark: isDark,
                    bucketType: 'todo',
                    onAccept: (taskItem) => _handleBucketTransition(
                        context, ref, taskItem, 'todo', isAdmin),
                    child: (taskItem) => _BoardTaskCard(
                      taskItem: taskItem,
                      isDark: isDark,
                      isAdmin: isAdmin,
                      updatedProgressMap: updatedProgressMap,
                      updatedMilestoneMap: updatedMilestoneMap,
                      updatedMilestoneAssigneeMap: updatedMilestoneAssigneeMap,
                      loadingTaskIds: loadingTaskIds,
                      isProjectRejected: isProjectRejected,
                      ref: ref,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _TaskBucket(
                    title: "APPROVAL BUCKET",
                    tasks: approvalTasks,
                    isDark: isDark,
                    bucketType: 'approval',
                    onAccept: (taskItem) => _handleBucketTransition(
                        context, ref, taskItem, 'approval', isAdmin),
                    child: (taskItem) => _BoardTaskCard(
                      taskItem: taskItem,
                      isDark: isDark,
                      isAdmin: isAdmin,
                      updatedProgressMap: updatedProgressMap,
                      updatedMilestoneMap: updatedMilestoneMap,
                      updatedMilestoneAssigneeMap: updatedMilestoneAssigneeMap,
                      loadingTaskIds: loadingTaskIds,
                      isProjectRejected: isProjectRejected,
                      ref: ref,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _TaskBucket(
                    title: "COMPLETED BUCKET",
                    tasks: completedTasks,
                    isDark: isDark,
                    bucketType: 'completed',
                    onAccept: (taskItem) => _handleBucketTransition(
                        context, ref, taskItem, 'completed', isAdmin),
                    child: (taskItem) => _BoardTaskCard(
                      taskItem: taskItem,
                      isDark: isDark,
                      isAdmin: isAdmin,
                      updatedProgressMap: updatedProgressMap,
                      updatedMilestoneMap: updatedMilestoneMap,
                      updatedMilestoneAssigneeMap: updatedMilestoneAssigneeMap,
                      loadingTaskIds: loadingTaskIds,
                      isProjectRejected: isProjectRejected,
                      ref: ref,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailsHeader(BuildContext context, WidgetRef ref,
      bool isDark, ThemeData theme, bool isProjectRejected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isProjectRejected) ...[
          _buildRejectionBanner(context, isDark),
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tasks & Plan",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            FilledButton.icon(
              onPressed: () => showDialog(
                context: context,
                builder: (context) =>
                    AddProjectTaskModal(
                      projectId: project.project.id,
                      projectStartDate: project.startDate,
                      projectDueDate: project.dueDate,
                      projectBudgetHours: project.project.plannedHours,
                      usedHours: project.tasks.fold(0.0, (sum, t) => sum + t.task.plannedHours),
                    ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add Task'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRejectionBanner(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                "Project Resubmission Required",
                style: GoogleFonts.inter(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          if (project.project.rejectionReason != null &&
              project.project.rejectionReason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Reason: ${project.project.rejectionReason}",
              style: GoogleFonts.inter(
                  color: isDark ? Colors.red.shade200 : Colors.red.shade800,
                  height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  void _handleBucketTransition(BuildContext context, WidgetRef ref,
      TaskWithAssignees taskItem, String targetBucket, bool isAdmin) async {
    final task = taskItem.task;
    final status = task.approvalStatus?.toLowerCase();

    if (targetBucket == 'approval') {
      if (status == 'approved') {
        _showError(context, 'Task already completed!');
        return;
      }
      if (status == 'pending_completion') return;

      // Check milestones if they exist
      List<Milestone> milestones = [];
      try {
        final decoded = jsonDecode(task.milestonesJson);
        if (decoded is List) {
          milestones = decoded
              .map((j) => Milestone.fromJson(j as Map<String, dynamic>))
              .toList();
        }
      } catch (_) {}

      final hasMilestones = milestones.isNotEmpty;
      final allChecked = milestones.every((m) => m.completed);
      
      // STRICT BLOCK: If milestones are present but not COMPLETED, block ALL roles
      if (hasMilestones && !allChecked) {
        _showError(context,
            'Please complete all milestones for "${task.name}" before moving to Approval!');
        return;
      }

      // ADMIN BYPASS: ONLY if milestones are EMPTY can Admin move directly to Completed
      if (isAdmin && !hasMilestones) {
        try {
          await ref.read(projectRepositoryProvider).adminCompleteTask(task.id);
          _refreshProject(ref);
          _showSuccess(context,
              'Admin: Task (no milestones) successfully bypassed and completed.');
          return;
        } catch (e) {
          _showError(context, 'Failed: $e');
          return;
        }
      }

      // Move to Approval for Employees OR for Admin with COMPLETED milestones
      try {
        await ref
            .read(projectRepositoryProvider)
            .requestTaskCompletion(task.id);
        _refreshProject(ref);
        _showSuccess(context, 'Completion request sent!');
      } catch (e) {
        _showError(context, 'Failed: $e');
      }
    } else if (targetBucket == 'completed') {
      if (!isAdmin) {
        _showError(context, 'Only Admins can approve tasks.');
        return;
      }
      if (status == 'approved') return;

      // Move to Completed: trigger approve
      try {
        await ref
            .read(projectRepositoryProvider)
            .approveTaskCompletion(task.id);
        _refreshProject(ref);
        _showSuccess(context, 'Task approved and completed!');
      } catch (e) {
        _showError(context, 'Failed: $e');
      }
    } else if (targetBucket == 'todo') {
      // Reopen or Reject logic
      if (status != 'pending_completion' && status != 'approved') return;
      
      if (!isAdmin) {
        _showError(context, 'Only Admins can reject or reopen tasks.');
        return;
      }

      // Move back to Todo: trigger rejection/reopen dialog
      _showRejectionDialog(context, ref, task);
    }
  }

  Widget _buildWaitingClosureFab(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child:
                const Icon(Icons.hourglass_empty, size: 18, color: Colors.white)
                    .animate(onPlay: (c) => c.repeat())
                    .rotate(duration: 2.seconds),
          ),
          const SizedBox(width: 8),
          Text(
            'Waiting Approval',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestClosureFab(BuildContext context, WidgetRef ref,
      bool hasPendingTasks, bool isAdmin, bool isProjectRejected) {
    return FloatingActionButton.extended(
      onPressed: () async {
        if (hasPendingTasks) {
          _showError(context,
              'Cannot complete project. Some tasks are still pending.');
          return;
        }

        if (isAdmin) {
          try {
            await ref
                .read(projectRepositoryProvider)
                .adminCompleteProject(project.project.id);
            _refreshProject(ref);
            _showSuccess(context, 'Project marked as Completed');
          } catch (e) {
            _showError(context, 'Failed: $e');
          }
          return;
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(isProjectRejected
                ? 'Resubmit Project Closure'
                : 'Request Project Closure'),
            content: Text(
              isProjectRejected
                  ? 'Your previous closure request was rejected. Do you want to resubmit closure for "${project.project.name}"?'
                  : 'All tasks are complete. Do you want to request closure for "${project.project.name}"?',
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await ref
                        .read(projectRepositoryProvider)
                        .requestProjectCompletion(project.project.id);
                    _showSuccess(
                        context,
                        isProjectRejected
                            ? 'Project closure resubmitted.'
                            : 'Project closure requested.');
                    _refreshProject(ref);
                  } catch (e) {
                    _showError(context, 'Failed: $e');
                  }
                },
                child: Text(isProjectRejected ? 'Resubmit' : 'Request Closure'),
              ),
            ],
          ),
        );
      },
      icon: Icon(isProjectRejected ? Icons.replay : Icons.check_circle_outline),
      label: Text(
        isProjectRejected ? 'Resubmit Closure' : 'Request Closure',
        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TaskBucket extends StatelessWidget {
  final String title;
  final List<TaskWithAssignees> tasks;
  final bool isDark;
  final String bucketType;
  final Function(TaskWithAssignees) onAccept;
  final Widget Function(TaskWithAssignees) child;

  const _TaskBucket({
    required this.title,
    required this.tasks,
    required this.isDark,
    required this.bucketType,
    required this.onAccept,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    switch (bucketType) {
      case 'todo':
        baseColor = isDark
            ? Colors.blue.shade900.withOpacity(0.3)
            : Colors.blue.shade50;
        break;
      case 'approval':
        baseColor = isDark
            ? Colors.orange.shade900.withOpacity(0.3)
            : Colors.orange.shade50;
        break;
      case 'completed':
        baseColor = isDark
            ? Colors.green.shade900.withOpacity(0.3)
            : Colors.green.shade50;
        break;
      default:
        baseColor = isDark ? const Color(0xFF111827) : Colors.grey.shade100;
    }

    return Expanded(
      child: DragTarget<TaskWithAssignees>(
        onWillAcceptWithDetails: (details) => true,
        onAcceptWithDetails: (details) => onAccept(details.data),
        builder: (context, candidateData, rejectedData) {
          final isOver = candidateData.isNotEmpty;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isOver
                  ? baseColor.withOpacity(isDark ? 0.6 : 0.8)
                  : baseColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isOver
                      ? Colors.blue.withOpacity(0.8)
                      : (isDark
                          ? Colors.white10
                          : Colors.black.withOpacity(0.05)),
                  width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${tasks.length}",
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => child(tasks[index]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MilestonesSection extends StatefulWidget {
  final dynamic task;
  final List<Milestone> milestones;
  final bool isDark;
  final bool isInitiallyExpanded;
  final bool isInteractive;
  final WidgetRef ref;
  final ValueNotifier<Map<String, int>> updatedProgressMap;
  final ValueNotifier<Map<String, bool>> updatedMilestoneMap;
  final ValueNotifier<Map<String, Map<String, String?>>> updatedMilestoneAssigneeMap;
  final void Function(
      BuildContext,
      WidgetRef,
      dynamic,
      List<Milestone>,
      Milestone,
      ValueNotifier<Map<String, int>>,
      ValueNotifier<Map<String, bool>>,
      ValueNotifier<Map<String, Map<String, String?>>>) toggleMilestone;

  const _MilestonesSection({
    required this.task,
    required this.milestones,
    required this.isDark,
    required this.isInitiallyExpanded,
    required this.isInteractive,
    required this.ref,
    required this.updatedProgressMap,
    required this.updatedMilestoneMap,
    required this.updatedMilestoneAssigneeMap,
    required this.toggleMilestone,
  });

  @override
  State<_MilestonesSection> createState() => _MilestonesSectionState();
}

class _MilestonesSectionState extends State<_MilestonesSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: widget.isDark ? Colors.white10 : Colors.grey.shade100)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.grey.shade500),
                  const SizedBox(width: 6),
                  Text(
                    'Milestones (${widget.milestones.length})',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Column(
                children: widget.milestones.map((m) {
                  final isMCompleted =
                      widget.updatedMilestoneMap.value[m.id] ?? m.completed;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Checkbox(
                            value: isMCompleted,
                            activeColor: Colors.blue.shade600,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            side: BorderSide(
                                color: widget.isDark
                                    ? Colors.white24
                                    : Colors.grey.shade400,
                                width: 1.5),
                            onChanged: widget.isInteractive
                                ? (val) => widget.toggleMilestone(
                                    context,
                                    widget.ref,
                                    widget.task,
                                    widget.milestones,
                                    m,
                                    widget.updatedProgressMap,
                                    widget.updatedMilestoneMap,
                                    widget.updatedMilestoneAssigneeMap)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                m.name,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: isMCompleted
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: isMCompleted
                                      ? (widget.isDark
                                          ? Colors.white38
                                          : Colors.grey.shade400)
                                      : (!widget.isInteractive
                                          ? Colors.grey.shade500
                                          : (widget.isDark
                                              ? Colors.white70
                                              : Colors.grey.shade700)),
                                  decoration: isMCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              if (isMCompleted) () {
                                // Retrieve optimistic or persistent assignee info
                                final optimisticInfo = widget.updatedMilestoneAssigneeMap.value[m.id];
                                final name = optimisticInfo?['name'] ?? m.completedBy;
                                final avatar = optimisticInfo?['avatar'] ?? m.completedByAvatar;
                                final userId = optimisticInfo?['userId'] ?? m.completedById;

                                if (name == null) return const SizedBox.shrink();

                                return Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 6),
                                        child: CircleAvatar(
                                          radius: 8,
                                          backgroundColor: UserColorService.getColorForUser(userId),
                                          backgroundImage: avatar != null
                                              ? NetworkImage(avatar)
                                              : null,
                                          child: avatar == null
                                              ? Text(name[0].toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 7,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white))
                                              : null,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          'Done by $name',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue.shade400.withOpacity(0.8),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _BoardTaskCard extends StatelessWidget {
  final TaskWithAssignees taskItem;
  final bool isDark;
  final bool isAdmin;
  final ValueNotifier<Map<String, int>> updatedProgressMap;
  final ValueNotifier<Map<String, bool>> updatedMilestoneMap;
  final ValueNotifier<Map<String, Map<String, String?>>> updatedMilestoneAssigneeMap;
  final ValueNotifier<Set<String>> loadingTaskIds;
  final bool isProjectRejected;
  final WidgetRef ref;

  const _BoardTaskCard({
    required this.taskItem,
    required this.isDark,
    required this.isAdmin,
    required this.updatedProgressMap,
    required this.updatedMilestoneMap,
    required this.updatedMilestoneAssigneeMap,
    required this.loadingTaskIds,
    required this.isProjectRejected,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final task = taskItem.task;
    final status = task.approvalStatus?.toLowerCase();

    List<Milestone> milestones = [];
    try {
      final List<dynamic> json =
          jsonDecode(task.milestonesJson) as List<dynamic>;
      milestones = json
          .map((j) => Milestone.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (_) {}

    final currentProgress =
        updatedProgressMap.value[task.id.toString()] ?? task.progress;
    final isRejected = status == 'rejected';
    final isApproval = status == 'pending_completion';
    final isCompleted = status == 'approved';

    Color statusColor;
    if (isCompleted) {
      statusColor = Colors.green.shade500;
    } else if (isRejected) {
      statusColor = Colors.red.shade600;
    } else if (isApproval) {
      statusColor = Colors.orange.shade500;
    } else if (status == 'pending_approval') {
      statusColor = Colors.purple.shade500;
    } else if (task.priority == "High" &&
        task.endDate.isBefore(DateTime.now())) {
      statusColor = Colors.red.shade800;
    } else {
      statusColor = Colors.blue.shade500;
    }

    Widget priorityTag() {
      Color pColor;
      IconData pIcon;
      switch (task.priority.toLowerCase()) {
        case 'high':
          pColor = Colors.red.shade600;
          pIcon = Icons.keyboard_double_arrow_up_rounded;
          break;
        case 'medium':
          pColor = Colors.orange.shade600;
          pIcon = Icons.keyboard_arrow_up_rounded;
          break;
        case 'low':
          pColor = Colors.green.shade600;
          pIcon = Icons.keyboard_arrow_down_rounded;
          break;
        default:
          pColor = Colors.grey.shade600;
          pIcon = Icons.drag_handle_rounded;
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: pColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(pIcon, size: 14, color: pColor),
            const SizedBox(width: 4),
            Text(
              task.priority.toUpperCase(),
              style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: pColor,
                  letterSpacing: 0.2),
            ),
          ],
        ),
      );
    }

    // Process assignees
    final assignees = taskItem.assignees;
    Widget assigneesRow = const SizedBox.shrink();
    if (assignees.isNotEmpty) {
      final displayAssignees = assignees.take(3).toList();
      final extraCount = assignees.length - 3;
      final totalWidth = 28.0 +
          (displayAssignees.length - 1) * 18.0 +
          (extraCount > 0 ? 18.0 : 0);

      assigneesRow = SizedBox(
        height: 28,
        width: totalWidth,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            for (int i = 0; i < displayAssignees.length; i++)
              Positioned(
                right: (displayAssignees.length - i - 1) * 18.0 +
                    (extraCount > 0 ? 18.0 : 0),
                child: Tooltip(
                  message: displayAssignees[i].name,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle:
                      GoogleFonts.inter(fontSize: 12, color: Colors.white),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: UserColorService.getColorForUser(displayAssignees[i].id)
                          .withOpacity(isDark ? 0.4 : 0.9),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color:
                              isDark ? const Color(0xFF1F2937) : Colors.white,
                          width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      displayAssignees[i].name.isNotEmpty
                          ? displayAssignees[i].name[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            if (extraCount > 0)
              Positioned(
                right: 0,
                child: Tooltip(
                  message: assignees.skip(3).map((a) => a.name).join(', '),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle:
                      GoogleFonts.inter(fontSize: 12, color: Colors.white),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color:
                              isDark ? const Color(0xFF1F2937) : Colors.white,
                          width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '+$extraCount',
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    final card = Container(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Status Line
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.name,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.95)
                                      : Colors.grey.shade900,
                                  height: 1.4,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              if (status == 'pending_approval')
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                          color:
                                              Colors.purple.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.lock_clock_outlined,
                                            size: 10, color: Colors.purple),
                                        const SizedBox(width: 4),
                                        Text(
                                          "AWAITING ADMIN APPROVAL",
                                          style: GoogleFonts.inter(
                                            fontSize: 7,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.purple,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isRejected)
                          const Icon(Icons.error_outline,
                              size: 20, color: Colors.red)
                        else if (isCompleted)
                          Icon(Icons.check_circle_rounded,
                              size: 20, color: Colors.green.shade500)
                        else
                          priorityTag(),
                      ],
                    ),
                    if (isRejected &&
                        task.rejectionReason != null &&
                        task.rejectionReason!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline,
                                size: 16, color: Colors.red),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                task.rejectionReason!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.red.shade200
                                      : Colors.red.shade800,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 6),
                            Text(
                              _formatDate(task.endDate),
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.timer_outlined,
                                size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              "${task.plannedHours}h",
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        if (assignees.isNotEmpty) assigneesRow,
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, right: 2),
                          child: Text(
                            "$currentProgress%",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: statusColor.withOpacity(0.9),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: currentProgress / 100.0,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.shade100,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (milestones.isNotEmpty)
                _MilestonesSection(
                  task: task,
                  milestones: milestones,
                  isDark: isDark,
                  isInitiallyExpanded: !isCompleted && !isApproval,
                  isInteractive: !isCompleted && !isApproval,
                  ref: ref,
                  updatedProgressMap: updatedProgressMap,
                  updatedMilestoneMap: updatedMilestoneMap,
                  updatedMilestoneAssigneeMap: updatedMilestoneAssigneeMap,
                  toggleMilestone: _toggleMilestone,
                ),
              if (isCompleted && isAdmin)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.orange.withOpacity(0.05)
                        : Colors.orange.shade50.withOpacity(0.5),
                    border: Border(
                        top: BorderSide(
                            color: isDark
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.orange.shade100)),
                  ),
                  child: InkWell(
                    onTap: () => _showReopenDialog(context, ref, task),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded,
                              size: 16, color: Colors.orange.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'REOPEN TASK',
                            style: GoogleFonts.inter(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
    return Draggable<TaskWithAssignees>(
      data: taskItem,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.95,
          child: Transform.scale(
            scale: 1.02,
            child: SizedBox(
              width: 320,
              child: card,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
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

  void _toggleMilestone(
      BuildContext context,
      WidgetRef ref,
      dynamic task,
      List<Milestone> milestones,
      Milestone m,
      ValueNotifier<Map<String, int>> updatedProgressMap,
      ValueNotifier<Map<String, bool>> updatedMilestoneMap,
      ValueNotifier<Map<String, Map<String, String?>>>
          updatedMilestoneAssigneeMap) async {
    try {
      final currentIsCompleted = updatedMilestoneMap.value[m.id] ?? m.completed;
      final newIsCompleted = !currentIsCompleted;

      // --- OPTIMISTIC UI: CHECKBOX & ASSIGNEE ---
      final milestonesMap = Map<String, bool>.from(updatedMilestoneMap.value);
      milestonesMap[m.id] = newIsCompleted;
      updatedMilestoneMap.value = milestonesMap;

      // Get current user for optimistic identity attribution
      final currentUser = ref.read(currentUserProvider).value;
      final userName =
          currentUser?.name ?? currentUser?.email.split('@').first ?? 'User';
      final userAvatar = currentUser?.avatarUrl;

      // Update optimistic identity map
      final assigneeMap =
          Map<String, Map<String, String?>>.from(updatedMilestoneAssigneeMap.value);
      if (newIsCompleted) {
        assigneeMap[m.id] = {'name': userName, 'avatar': userAvatar};
      } else {
        assigneeMap.remove(m.id);
      }
      updatedMilestoneAssigneeMap.value = assigneeMap;

      // Create updated milestone list for local DB persistence
      final updatedMilestones = milestones.map((milestone) {
        if (milestone.id == m.id) {
          return milestone.copyWith(
            completed: newIsCompleted,
            completedBy: newIsCompleted ? userName : null,
            completedByAvatar: newIsCompleted ? userAvatar : null,
          );
        }
        return milestone;
      }).toList();

      // Persist to local DB immediately for "zero-delay" reactivity
      final repository = ref.read(projectRepositoryProvider);
      await repository.updateTaskMilestones(task.id.toString(), updatedMilestones);

      // --- BACKGROUND API CALL ---
      final subtaskId = int.tryParse(m.id.replaceFirst('milestone_', ''));
      if (subtaskId == null) return;

      final apiService = ref.read(taskApiServiceProvider);
      final taskId =
          task.id is int ? task.id : int.tryParse(task.id.toString()) ?? 0;
      
      final response =
          await apiService.toggleSubtaskCompletion(taskId, subtaskId);

      // --- SYNC PROGRESS ---
      final newProgress = (response['parent_task_progress'] as num).toInt();
      final currentMap = Map<String, int>.from(updatedProgressMap.value);
      currentMap[task.id.toString()] = newProgress;
      updatedProgressMap.value = currentMap;

      // Invalidate to ensure consistency without full page flickers
      ref.invalidate(apiTasksProvider);
      ref.invalidate(projectsWithTasksProvider);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

void _refreshProject(WidgetRef ref) {
  ref.invalidate(apiTasksProvider);
  ref.invalidate(projectsWithTasksProvider);
  ref.invalidate(currentProjectProvider);
}

void _showSuccess(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green));
}

void _showError(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red));
}

void _showReopenDialog(BuildContext context, WidgetRef ref, dynamic task) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reopen Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Please provide a reason for reopening this task (it will be returned to the assignee with a denied status):'),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Reason for denial...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            if (controller.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a reason')));
              return;
            }
            Navigator.pop(context);
            try {
              await ref
                  .read(projectRepositoryProvider)
                  .reopenTask(task.id, controller.text.trim());
              
              _refreshProject(ref);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Task reopened and moved to Task Bucket'),
                  backgroundColor: Colors.orange,
                ));
              }
            } catch (e) {
              _showError(context, 'Failed: $e');
            }
          },
          style: FilledButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text('Reopen Task'),
        ),
      ],
    ),
  );
}

void _showRejectionDialog(BuildContext context, WidgetRef ref, dynamic task) {
  final controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reject Task Completion'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Please provide a reason for rejecting this completion (it will be returned to the Task Bucket):'),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Reason for rejection...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    actions: [
      TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel')),
      FilledButton(
        onPressed: () async {
          final reason = controller.text.trim();
          if (reason.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a reason')));
            return;
          }
          Navigator.pop(context);
          
          final status = task.approvalStatus?.toLowerCase();
          final isCompleted = status == 'approved';

          try {
            if (isCompleted) {
              await ref
                  .read(projectRepositoryProvider)
                  .reopenTask(task.id, reason);
            } else {
              await ref
                  .read(projectRepositoryProvider)
                  .rejectTaskCompletion(task.id, reason);
            }
            
            _refreshProject(ref);
            
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(isCompleted 
                  ? 'Task reopened and moved to Task Bucket' 
                  : 'Task rejected and moved to Task Bucket'),
                backgroundColor: isCompleted ? Colors.orange : Colors.red,
              ));
            }
          } catch (e) {
            _showError(context, 'Failed: $e');
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: (task.approvalStatus?.toLowerCase() == 'approved') 
            ? Colors.orange 
            : Colors.red
        ),
        child: Text((task.approvalStatus?.toLowerCase() == 'approved') 
          ? 'Reopen Task' 
          : 'Reject Task'),
      ),
    ],
    ),
  );
}
