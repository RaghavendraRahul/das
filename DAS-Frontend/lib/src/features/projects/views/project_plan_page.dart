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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/utils/user_color_service.dart';
import '../../../core/widgets/error_view.dart';
import '../../dashboard/dashboard_providers.dart';
import '../../dashboard/modals/create_new_workspace_modal.dart';

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
      error: (err, st) => Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? const Color(0xFF0F172A) 
            : const Color(0xFFF1F5F9),
        body: PremiumErrorView(
          message: err.toString(),
          onRetry: () => ref.invalidate(currentProjectProvider),
        ),
      ),
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
    final isBannerDismissed = useState(false);
    final isBannerMinimized = useState(false);

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
      final allMilestonesDone = milestones.isEmpty || milestones.every((m) => m.completed);

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
    final approvalStatus = project.project.approvalStatus?.toLowerCase();
    final isProjectRejected =
        approvalStatus == 'rejected' || approvalStatus == 'rejected_closure';
    final isClosureRejection = approvalStatus == 'rejected_closure';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      floatingActionButton: (canClose && (!isProjectRejected || isClosureRejection))
          ? (isPendingClosure
              ? _buildWaitingClosureFab(context, isDark)
              : _buildRequestClosureFab(
                  context,
                  ref,
                  hasPendingTasks,
                  isAdmin,
                  isProjectRejected,
                  todoTasks,
                  approvalTasks))
          : (project.project.status == 'completed' && isAdmin
              ? _buildAdminReopenFab(context, ref)
              : null),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            _buildProjectDetailsHeader(
                context, ref, isDark, theme, isProjectRejected, isClosureRejection, isBannerDismissed, isBannerMinimized),
            const SizedBox(height: 24),

            // Kanban Board
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TaskBucket(
                    title: "Task Bucket", // Sentence Case
                    tasks: todoTasks,
                    isDark: isDark,
                    bucketType: 'todo',
                    onAccept: (taskItem) => _handleBucketTransition(
                        context, ref, taskItem, 'todo', isAdmin, updatedProgressMap),
                    child: (taskItem) => _BoardTaskCard(
                      taskItem: taskItem,
                      isDark: isDark,
                      isAdmin: isAdmin,
                      bucketType: 'todo',
                      updatedProgressMap: updatedProgressMap,
                      updatedMilestoneMap: updatedMilestoneMap,
                      updatedMilestoneAssigneeMap: updatedMilestoneAssigneeMap,
                      loadingTaskIds: loadingTaskIds,
                      isProjectRejected: isProjectRejected,
                      isClosureRejection: isClosureRejection,
                      ref: ref,
                      project: project,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _TaskBucket(
                    title: "Approval Bucket", // Sentence Case
                    tasks: approvalTasks,
                    isDark: isDark,
                    bucketType: 'approval',
                    onAccept: (taskItem) => _handleBucketTransition(
                        context, ref, taskItem, 'approval', isAdmin, updatedProgressMap),
                    child: (taskItem) => _BoardTaskCard(
                      taskItem: taskItem,
                      isDark: isDark,
                      isAdmin: isAdmin,
                      bucketType: 'approval',
                      updatedProgressMap: updatedProgressMap,
                      updatedMilestoneMap: updatedMilestoneMap,
                      updatedMilestoneAssigneeMap: updatedMilestoneAssigneeMap,
                      loadingTaskIds: loadingTaskIds,
                      isProjectRejected: isProjectRejected,
                      isClosureRejection: isClosureRejection,
                      ref: ref,
                      project: project,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _TaskBucket(
                    title: "Completed Bucket", // Sentence Case
                    tasks: completedTasks,
                    isDark: isDark,
                    bucketType: 'completed',
                    onAccept: (taskItem) => _handleBucketTransition(
                        context, ref, taskItem, 'completed', isAdmin, updatedProgressMap),
                    child: (taskItem) => _BoardTaskCard(
                      taskItem: taskItem,
                      isDark: isDark,
                      isAdmin: isAdmin,
                      bucketType: 'completed',
                      updatedProgressMap: updatedProgressMap,
                      updatedMilestoneMap: updatedMilestoneMap,
                      updatedMilestoneAssigneeMap: updatedMilestoneAssigneeMap,
                      loadingTaskIds: loadingTaskIds,
                      isProjectRejected: isProjectRejected,
                      isClosureRejection: isClosureRejection,
                      ref: ref,
                      project: project,
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
      bool isDark, ThemeData theme, bool isProjectRejected, bool isClosureRejection, ValueNotifier<bool> isBannerDismissed, ValueNotifier<bool> isBannerMinimized) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isProjectRejected && !isBannerDismissed.value) ...[
          _buildRejectionBanner(context, isDark, isClosureRejection, isBannerDismissed, isBannerMinimized),
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "Tasks & Plan",
                  style: GoogleFonts.outfit( // Outfit for section titles
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(width: 12),
              ],
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
              icon: const Icon(Icons.add, size: 18),
              label: Text('Add Task', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF05263E),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRejectionBanner(BuildContext context, bool isDark, bool isClosureRejection, ValueNotifier<bool> isBannerDismissed, ValueNotifier<bool> isBannerMinimized) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isClosureRejection
            ? Colors.blue.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isClosureRejection
                ? Colors.blue.withOpacity(0.3)
                : Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                  isClosureRejection ? Icons.info_outline : Icons.error_outline,
                  color: isClosureRejection ? Colors.blue : Colors.red,
                  size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  isClosureRejection
                      ? "Project Closure Rejected"
                      : "Project Resubmission Required",
                  style: GoogleFonts.inter(
                      color: isClosureRejection ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => isBannerMinimized.value = !isBannerMinimized.value,
                icon: Icon(isBannerMinimized.value ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded, color: isClosureRejection ? Colors.blue : Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: isBannerMinimized.value ? "Expand" : "Minimize",
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => isBannerDismissed.value = true,
                icon: Icon(Icons.close_rounded, color: isClosureRejection ? Colors.blue : Colors.red, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 20,
              ),
            ],
          ),
          if (!isBannerMinimized.value) ...[
            if (project.project.rejectionReason != null &&
                project.project.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "Reason: ${project.project.rejectionReason}",
                style: GoogleFonts.inter(
                    color: isDark ? (isClosureRejection ? Colors.blue.shade200 : Colors.red.shade200) : (isClosureRejection ? Colors.blue.shade800 : Colors.red.shade800),
                    height: 1.4),
              ),
            ],
            const SizedBox(height: 12),
            if (!isClosureRejection)
              SizedBox(
                height: 36,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          CreateNewWorkspaceModal(projectToEdit: project),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(
                    'Edit & Resubmit',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            else
              Text(
                'The tasks have been returned to the bucket. Please finish the work and request closure again.',
                style: GoogleFonts.inter(
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade900,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ],
      ),
    );
  }

  void _handleBucketTransition(BuildContext context, WidgetRef ref,
      TaskWithAssignees taskItem, String targetBucket, bool isAdmin, 
      ValueNotifier<Map<String, int>> updatedProgressMap) async {
    final task = taskItem.task;
    final status = task.approvalStatus?.toLowerCase();

    if (targetBucket == 'approval') {
      if (status == 'approved') {
        if (context.mounted) _showError(context, 'Task already completed!');
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
        if (context.mounted) {
          _showError(context,
              'Please complete all milestones for "${task.name}" before moving to Approval!');
        }
        return;
      }

      // ADMIN BYPASS: ONLY if milestones are EMPTY can Admin move directly to Completed
      if (isAdmin && !hasMilestones) {
        try {
          await ref.read(projectRepositoryProvider).adminCompleteTask(task.id);
          _refreshProject(ref);
          if (context.mounted) {
            _showSuccess(context,
                'Admin: Task (no milestones) successfully bypassed and completed.');
          }
          return;
        } catch (e) {
          if (context.mounted) _showError(context, 'Failed: $e');
          return;
        }
      }

      // Move to Approval for Employees OR for Admin with COMPLETED milestones
      try {
        if (!hasMilestones) {
          // Task without milestones when dragged to Approvals bucket then progress bar shld get updated to 100%.
          final currentMap = Map<String, int>.from(updatedProgressMap.value);
          currentMap[task.id.toString()] = 100;
          updatedProgressMap.value = currentMap;
        }

        await ref
            .read(projectRepositoryProvider)
            .requestTaskCompletion(task.id);
        _refreshProject(ref);
        if (context.mounted) _showSuccess(context, 'Completion request sent!');
      } catch (e) {
        if (context.mounted) _showError(context, 'Failed: $e');
      }
    } else if (targetBucket == 'completed') {
      if (!isAdmin) {
        if (context.mounted) _showError(context, 'Only Admins can approve tasks.');
        return;
      }
      if (status == 'approved') return;

      // Check milestones completion if they exist
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

      if (hasMilestones && !allChecked) {
        if (context.mounted) {
          _showError(context,
              'Cannot complete task. Please finish all milestones for "${task.name}" first!');
        }
        return;
      }

      // Move to Completed: trigger approve
      try {
        await ref
            .read(projectRepositoryProvider)
            .approveTaskByTaskId(task.id);
        _refreshProject(ref);
        if (context.mounted) _showSuccess(context, 'Task approved and completed!');
      } catch (e) {
        if (context.mounted) _showError(context, 'Failed: $e');
      }
    } else if (targetBucket == 'todo') {
      // Reopen or Reject logic
      // Progress Guard: Any task with < 100% progress dropped in Todo bucket is treated as 'work in progress', no admin logic needed.
      if (task.progress < 100) return; 
      if (status == 'pending_creation' || status == 'pending_approval') return;
      if (status != 'pending_completion' && status != 'approved') return;
      
      if (!isAdmin) {
        if (context.mounted) _showError(context, 'Only Admins can reject or reopen tasks.');
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

  Widget _buildRequestClosureFab(
      BuildContext context,
      WidgetRef ref,
      bool hasPendingTasks,
      bool isAdmin,
      bool isProjectRejected,
      List<TaskWithAssignees> todoTasks,
      List<TaskWithAssignees> approvalTasks) {
    return FloatingActionButton.extended(
      onPressed: () async {
        // 1. ADMIN AUTO-BYPASS: Admins can always complete the project
        if (isAdmin) {
          try {
            await ref
                .read(projectRepositoryProvider)
                .adminCompleteProject(project.project.id);
            _refreshProject(ref);
            if (context.mounted) _showSuccess(context, 'Project marked as Completed');
          } catch (e) {
            String errorMsg = e.toString();
            if (e is Exception && errorMsg.contains('400')) {
               errorMsg = 'Cannot complete project. Some tasks are still pending.';
            }
            if (context.mounted) _showError(context, 'Failed: $errorMsg');
          }
          return;
        }

        // 2. EMPLOYEE STRICT VALIDATION: Ensure ALL tasks are fully approved/completed
        // This mirrors the backend's `project.tasks.exclude(status='DONE').count() > 0` check.
        final unfinishedTasks = project.tasks.where((t) {
          final s = t.task.approvalStatus?.toLowerCase();
          return s != 'approved';
        }).toList();

        if (unfinishedTasks.isNotEmpty) {
          if (context.mounted) {
            _showError(context, 'Please complete all tasks first.');
          }
          return;
        }

        // 3. SHOW REQUEST DIALOG
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
                    if (context.mounted) {
                      _showSuccess(
                          context,
                          isProjectRejected
                              ? 'Project closure resubmitted.'
                              : 'Project closure requested.');
                    }
                    _refreshProject(ref);
                  } catch (e) {
                    String errorMsg = e.toString();
                    if (errorMsg.contains('400')) {
                      errorMsg = 'Please complete all tasks first.';
                    }
                    if (context.mounted) _showError(context, 'Failed: $errorMsg');
                  }
                },
                child: Text(isProjectRejected ? 'Resubmit' : 'Request Closure'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.check_circle_outline),
      label: Text(
        'Request Closure',
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
    Color accentColor;
    switch (bucketType) {
      case 'todo':
        baseColor = isDark
            ? Colors.blue.shade900.withOpacity(0.15)
            : Colors.blue.shade50.withOpacity(0.5);
        accentColor = const Color(0xFF05263E);
        break;
      case 'approval':
        baseColor = isDark
            ? Colors.orange.shade900.withOpacity(0.15)
            : Colors.orange.shade50.withOpacity(0.5);
        accentColor = Colors.orange.shade700;
        break;
      case 'completed':
        baseColor = isDark
            ? Colors.green.shade900.withOpacity(0.15)
            : Colors.green.shade50.withOpacity(0.5);
        accentColor = Colors.green.shade700;
        break;
      default:
        baseColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        accentColor = Colors.grey.shade600;
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
                  ? (isDark ? accentColor.withOpacity(0.25) : accentColor.withOpacity(0.12)) // Slightly richer over state
                  : baseColor,
              borderRadius: BorderRadius.circular(24), // Smoother corners for premium look
              border: Border.all(
                  color: isOver
                      ? accentColor
                      : (isDark
                          ? Colors.white.withOpacity(0.08)
                          : const Color(0xFFE2E8F0)), // Slate-200 border in light mode
                  width: isOver ? 1.5 : 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: GoogleFonts.outfit( // Switched to Outfit for modern feel
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF0F172A), // Deep Slate
                            letterSpacing: -0.1),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: accentColor.withOpacity(0.1)),
                        ),
                        child: Text(
                          "${tasks.length}",
                          style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                      height: 1, 
                      thickness: 0.5,
                      color: isDark ? Colors.white.withOpacity(0.06) : accentColor.withOpacity(0.08)
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    style: GoogleFonts.outfit( // Outfit for sub-sections
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? Colors.white70 : const Color(0xFF475569)), // Slate-600
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
                        IgnorePointer(
                          ignoring: !widget.isInteractive,
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: isMCompleted,
                              activeColor: widget.isInteractive
                                  ? Colors.blue.shade600
                                  : (widget.isDark
                                      ? Colors.grey.shade600
                                      : Colors.grey.shade400),
                              checkColor: widget.isInteractive
                                  ? Colors.white
                                  : (widget.isDark
                                      ? Colors.grey.shade400
                                      : Colors.white70),
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
  final String bucketType;
  final ValueNotifier<Map<String, int>> updatedProgressMap;
  final ValueNotifier<Map<String, bool>> updatedMilestoneMap;
  final ValueNotifier<Map<String, Map<String, String?>>> updatedMilestoneAssigneeMap;
  final ValueNotifier<Set<String>> loadingTaskIds;
  final bool isProjectRejected;
  final bool isClosureRejection;
  final WidgetRef ref;
  final ProjectWithTasks project;

  const _BoardTaskCard({
    required this.taskItem,
    required this.isDark,
    required this.isAdmin,
    required this.bucketType,
    required this.updatedProgressMap,
    required this.updatedMilestoneMap,
    required this.updatedMilestoneAssigneeMap,
    required this.loadingTaskIds,
    required this.isProjectRejected,
    this.isClosureRejection = false,
    required this.ref,
    required this.project,
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
    // isRejected on a task means it was individually rejected by Admin (creation/completion rejection)
    // Suppress this flag when the project is in closure-rejection state — all tasks are reset
    // to 'rejected' bucket but that is a project-level action, not a per-task rejection.
    final isRejected = status == 'rejected' && !isClosureRejection;
    final isApproval = status == 'pending_completion';
    final isPendingCreation = status == 'pending_creation';
    final isCompleted = status == 'approved';

    Color statusColor;
    if (isCompleted) {
      statusColor = Colors.green.shade500;
    } else if (isRejected) {
      statusColor = Colors.red.shade600;
    } else if (isApproval) {
      statusColor = Colors.orange.shade500;
    } else if (status == 'pending_approval' || isPendingCreation) {
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
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                                style: GoogleFonts.outfit( // Outfit for task titles
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                        ? Colors.white.withOpacity(0.9)
                                      : const Color(0xFF1E293B), // Slate-800
                                  height: 1.3,
                                  letterSpacing: -0.1,
                                ),
                              ),
                              if (status == 'pending_approval' || status == 'pending_creation')
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
                        if (bucketType == 'todo' && status != 'approved')
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 16, color: isDark ? Colors.white54 : Colors.grey.shade500),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Edit Task',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddProjectTaskModal(
                                  projectId: project.project.id,
                                  projectStartDate: project.startDate,
                                  projectDueDate: project.dueDate,
                                  projectBudgetHours: project.project.plannedHours,
                                  usedHours: project.tasks.fold(
                                      0.0, (sum, t) => sum + t.task.plannedHours),
                                  existingTask: taskItem,
                                ),
                              );
                            },
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
                                size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                            const SizedBox(width: 6),
                            Text(
                              _formatDate(task.endDate),
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.timer_outlined,
                                size: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                            const SizedBox(width: 4),
                            Text(
                              "${task.plannedHours % 1 == 0 ? task.plannedHours.toInt() : task.plannedHours}h",
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
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
                            style: GoogleFonts.outfit( // Outfit for progress numbers
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: statusColor.withOpacity(0.95),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: currentProgress / 100.0,
                            minHeight: 8, // More substantial bar
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.08)
                                : const Color(0xFFF1F5F9), // Slate-100
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
                  isInitiallyExpanded: !isApproval,
                  isInteractive: bucketType == 'todo' && 
                                 project.project.status == 'active' && 
                                 project.project.approvalStatus?.toLowerCase() != 'pending_completion',
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
    // --- SWEET REMINDER FOR PENDING LOGIC ---
    final status = task.approvalStatus?.toLowerCase();
    if (status == 'pending_creation' || status == 'pending_approval') {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Task approval pending. You can continue working normally!',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.purple.shade600,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            width: 400,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }

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
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

void _refreshProject(WidgetRef ref) {
  ref.invalidate(apiTasksProvider);
  ref.invalidate(projectsWithTasksProvider);
  ref.invalidate(currentProjectProvider);
  // ADDED: Refresh dashboard stats for consistency
  ref.invalidate(filteredDashboardStatsProvider);
  ref.invalidate(dashboardProjectsProvider);
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
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a reason')));
              }
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
              if (context.mounted) _showError(context, 'Failed: $e');
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
                    .rejectTaskByTaskId(task.id, reason);
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
              if (context.mounted) _showError(context, 'Failed: $e');
            }
          },
          style: FilledButton.styleFrom(
              backgroundColor: (task.approvalStatus?.toLowerCase() == 'approved')
                  ? Colors.orange
                  : Colors.red),
          child: Text((task.approvalStatus?.toLowerCase() == 'approved')
              ? 'Reopen Task'
              : 'Reject Task'),
        ),
      ],
    ),
  );
}

Widget _buildAdminReopenFab(BuildContext context, WidgetRef ref) {
  return FloatingActionButton.extended(
    onPressed: () => _showGlobalReopenDialog(context, ref),
    label: const Text('Reopen Project'),
    icon: const Icon(Icons.refresh),
    backgroundColor: Colors.blue.shade700,
    foregroundColor: Colors.white,
  );
}

void _showGlobalReopenDialog(BuildContext context, WidgetRef ref) {
  final reasonController = TextEditingController();
  final project = ref.read(currentProjectProvider).value;
  if (project == null) return;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Reopen Project',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Why are you reopening this completed project?',
              style: GoogleFonts.inter(fontSize: 14)),
          const SizedBox(height: 12),
          TextField(
            controller: reasonController,
            autofocus: true,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter reason...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
        ),
        FilledButton(
          onPressed: () async {
            if (reasonController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Reason is mandatory'),
                    backgroundColor: Colors.red),
              );
              return;
            }

            Navigator.pop(context);

            try {
              await ref
                  .read(projectRepositoryProvider)
                  .reopenProject(project.project.id, reasonController.text.trim());
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Project Reopened'),
                      backgroundColor: Colors.green),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                );
              }
            }
          },
          child: const Text('Confirm Reopen'),
        ),
      ],
    ),
  );
}
