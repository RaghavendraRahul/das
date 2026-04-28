import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import '../providers/api_providers.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'dart:convert';
import '../../../core/utils/user_color_service.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Data Model ──────────────────────────────────────────────────────────────

class _Milestone {
  final String id;
  final String title;
  final int progressWeight;

  _Milestone(
      {required this.id, required this.title, required this.progressWeight});

  Map<String, dynamic> toJson() => {
        'title': title,
        'progress_weight': progressWeight,
      };
}

// ─── Priority Config ──────────────────────────────────────────────────────────

const _priorities = [
  {
    'value': 'LOW',
    'label': 'Low',
    'color': 0xFF22C55E,
    'icon': Icons.arrow_downward
  },
  {
    'value': 'MEDIUM',
    'label': 'Medium',
    'color': 0xFFF59E0B,
    'icon': Icons.remove
  },
  {
    'value': 'HIGH',
    'label': 'High',
    'color': 0xFFEF4444,
    'icon': Icons.arrow_upward
  },
  {
    'value': 'CRITICAL',
    'label': 'Critical',
    'color': 0xFF7C3AED,
    'icon': Icons.local_fire_department
  },
];

// ─── Main Modal ───────────────────────────────────────────────────────────────

class AddProjectTaskModal extends HookConsumerWidget {
  final String projectId;
  final DateTime? projectStartDate;
  final DateTime? projectDueDate;
  final double projectBudgetHours; // project's total planned_hours budget
  final double usedHours;          // sum of plannedHours of existing tasks
  final TaskWithAssignees? existingTask;

  const AddProjectTaskModal({
    super.key,
    required this.projectId,
    this.projectStartDate,
    this.projectDueDate,
    this.projectBudgetHours = 0.0,
    this.usedHours = 0.0,
    this.existingTask,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = existingTask?.task;
    final titleController = useTextEditingController(text: task?.name ?? '');
    final plannedHoursController = useTextEditingController(text: task?.plannedHours.toString() ?? '0.0');
    final priority = useState<String>(task?.priority.toUpperCase() ?? 'MEDIUM');
    // Constrain initial dates within project range
    final projectStart = projectStartDate ?? DateTime(2024);
    final projectEnd = projectDueDate ?? DateTime(2035);
    final now = DateTime.now();
    final initialStart = task?.startDate ?? (now.isBefore(projectStart) ? projectStart : (now.isAfter(projectEnd) ? projectStart : now));
    final initialDue = task?.endDate ?? (initialStart.add(const Duration(days: 7)).isAfter(projectEnd) ? projectEnd : initialStart.add(const Duration(days: 7)));
    final startDate = useState<DateTime>(initialStart);
    final dueDate = useState<DateTime>(initialDue);
    final selectedAssignees = useState<List<User>>(existingTask?.assignees ?? []);
    
    // Load existing milestones
    List<_Milestone> initialMilestones = [];
    if (task?.milestonesJson != null && task!.milestonesJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(task.milestonesJson);
        if (decoded is List) {
          initialMilestones = decoded.map((m) => _Milestone(
            id: m['id']?.toString() ?? const Uuid().v4(),
            title: m['title']?.toString() ?? m['name']?.toString() ?? '',
            progressWeight: m['progress_weight'] ?? 0,
          )).toList();
        }
      } catch (_) {}
    }
    final milestones = useState<List<_Milestone>>(initialMilestones);
    final isLoading = useState(false);

    // Effect to clear Due Date if it's before Start Date
    useEffect(() {
      if (dueDate.value.isBefore(startDate.value)) {
        dueDate.value = startDate.value.add(const Duration(days: 7));
      }
      return null;
    }, [startDate.value]);

    final milestoneNameController = useTextEditingController();

    final allUsersAsync = ref.watch(allUsersForProjectsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final surfaceColor =
        isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF8FAFC);
    final borderColor =
        isDark ? const Color(0xFF3A3A5C) : const Color(0xFFE2E8F0);
    final labelColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);

    // Total milestone weight - REMOVED manual calculation

    Future<void> saveTask() async {
      if (titleController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.warning_amber, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Task title is required'),
            ]),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      final enteredHours = double.tryParse(plannedHoursController.text.trim()) ?? 0.0;
      if (enteredHours <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.timer_off, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Planned hours is required and must be greater than 0.'),
            ]),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      if (selectedAssignees.value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.person_off, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Please select at least one assignee.'),
            ]),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      // Planned hours budget check
      if (projectBudgetHours > 0) {
        final existingTaskHours = task?.plannedHours ?? 0.0;
        final remaining = (projectBudgetHours - usedHours) + existingTaskHours;
        if (enteredHours > remaining) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Icon(Icons.timer_off, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(
                    'Planned hours ($enteredHours h) exceeds remaining budget (${remaining.toStringAsFixed(1)} h). '
                    'Total project budget: ${projectBudgetHours.toStringAsFixed(1)} h.')),
              ]),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          return;
        }
      }

      isLoading.value = true;
      try {
        final apiService = ref.read(taskApiServiceProvider);

        // Auto-distribute weights evenly
        final distributedMilestones =
            milestones.value.asMap().entries.map((entry) {
          final idx = entry.key;
          final m = entry.value;
          if (milestones.value.isEmpty) return m.toJson();

          final count = milestones.value.length;
          final weight = 100 ~/ count;
          final remainder = 100 % count;
          // Add remainder to the last item
          final finalWeight = weight + (idx == count - 1 ? remainder : 0);

          return {
            'title': m.title,
            'progress_weight': finalWeight,
          };
        }).toList();

        final taskData = {
          'title': titleController.text.trim(),
          'priority': priority.value, // uppercase: LOW, MEDIUM, HIGH, CRITICAL
          'start_date': DateFormat('yyyy-MM-dd').format(startDate.value),
          'due_date': DateFormat('yyyy-MM-dd').format(dueDate.value),
          'planned_hours': double.tryParse(plannedHoursController.text.trim()) ?? 0.0,
          'assignees': selectedAssignees.value
              .map((u) => int.tryParse(u.id) ?? 0)
              .toList(),
          'milestones': distributedMilestones,
        };

        // If it was rejected, reset status so it goes back to admin for approval
        if (existingTask?.task.approvalStatus == 'rejected') {
          taskData['approval_status'] = 'pending_creation';
        }

        if (existingTask != null) {
          final cleanTaskId = int.tryParse(existingTask!.task.id) ??
              int.tryParse(existingTask!.task.id.replaceFirst('api_project_task_', '')) ??
              int.tryParse(existingTask!.task.id.replaceFirst('api_task_', '')) ??
              0;
          await apiService.updateTask(cleanTaskId, taskData);
        } else {
          final cleanProjectId = int.tryParse(projectId) ??
              int.tryParse(projectId.replaceFirst('api_project_', '')) ??
              0;
          await apiService.createTask(cleanProjectId, taskData);
        }

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(existingTask != null ? 'Task updated successfully!' : 'Task created successfully!'),
              ]),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }

        ref.invalidate(apiTasksProvider);
        if (existingTask == null) {
          final cleanProjectId = int.tryParse(projectId) ??
              int.tryParse(projectId.replaceFirst('api_project_', '')) ?? 0;
          ref.invalidate(apiProjectProvider(cleanProjectId));
        }
        ref.invalidate(currentProjectProvider);
        ref.invalidate(paginatedDashboardProjectsProvider);
        ref.invalidate(projectsPageProjectsProvider);
        // Refresh individual dashboards as well
        ref.invalidate(dashboardProjectsProvider);
        ref.invalidate(filteredDashboardStatsProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed: $e', maxLines: 2)),
              ]),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: bgColor,
      elevation: 24,
      child: Container(
        width: 580,
        constraints: const BoxConstraints(maxHeight: 780),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Premium Header ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E40AF), const Color(0xFF1E1B4B)]
                      : [const Color(0xFF1D4ED8), const Color(0xFF05263E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      existingTask != null ? Icons.edit_document : Icons.add_task,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          existingTask != null ? 'Edit Task' : 'Add New Task',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          existingTask != null 
                            ? 'Update details for this task' 
                            : 'Fill in details below to create a task',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (projectBudgetHours > 0) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _HeaderBadge(
                                icon: Icons.analytics_outlined,
                                label: 'Total: ${projectBudgetHours % 1 == 0 ? projectBudgetHours.toInt() : projectBudgetHours.toStringAsFixed(1)}h',
                              ),
                              _HeaderBadge(
                                icon: Icons.history_toggle_off,
                                label: 'Used: ${usedHours % 1 == 0 ? usedHours.toInt() : usedHours.toStringAsFixed(1)}h',
                              ),
                              _HeaderBadge(
                                icon: Icons.hourglass_empty_rounded,
                                label: 'Remaining: ${(projectBudgetHours - usedHours) % 1 == 0 ? (projectBudgetHours - usedHours).toInt() : (projectBudgetHours - usedHours).toStringAsFixed(1)}h',
                                highlight: true,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ── Form Body ────────────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rejection Reason Banner
                    if (existingTask?.task.approvalStatus == 'rejected' &&
                        existingTask?.task.rejectionReason != null &&
                        existingTask!.task.rejectionReason!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.red.withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Color(0xFFEF4444), size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TASK REJECTED BY ADMIN',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFEF4444),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    existingTask!.task.rejectionReason!,
                                    style: GoogleFonts.inter(
                                      color: isDark
                                          ? Colors.red.shade200
                                          : Colors.red.shade900,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Please modify the task details and resubmit for approval.',
                                    style: GoogleFonts.inter(
                                      color: isDark
                                          ? Colors.red.shade300.withOpacity(0.7)
                                          : Colors.red.shade700,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Task Title
                    _SectionLabel('Task Title', labelColor),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      style: GoogleFonts.inter(
                        color: textColor, 
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: _inputDeco(
                        hint: 'e.g. Design the login screen',
                        borderColor: borderColor,
                        surfaceColor: surfaceColor,
                        prefixIcon:
                            Icon(Icons.title_rounded, size: 20, color: labelColor),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _SectionLabel('Planned Hours', labelColor),
                    const SizedBox(height: 8),
                    TextField(
                      controller: plannedHoursController,
                      style: GoogleFonts.inter(
                        color: textColor, 
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDeco(
                        hint: 'e.g. 8.0',
                        borderColor: borderColor,
                        surfaceColor: surfaceColor,
                        prefixIcon:
                            Icon(Icons.timer_outlined, size: 20, color: labelColor),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Priority
                    _SectionLabel('Priority', labelColor),
                    const SizedBox(height: 12),
                    Row(
                      children: _priorities.map((p) {
                        final isSelected = priority.value == p['value'];
                        final color = Color(p['color'] as int);
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => priority.value = p['value'] as String,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeOutCirc,
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withOpacity(0.12)
                                    : surfaceColor,
                                border: Border.all(
                                  color: isSelected ? color : borderColor,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Icon(p['icon'] as IconData,
                                      color: color, size: 20),
                                  const SizedBox(height: 6),
                                  Text(
                                    p['label'] as String,
                                    style: GoogleFonts.inter(
                                      color: isSelected ? color : labelColor,
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Dates
                    Row(
                      children: [
                        Expanded(
                          child: _DateField(
                            label: 'Start Date',
                            date: startDate,
                            minDate: projectStartDate,
                            maxDate: projectDueDate,
                            labelColor: labelColor,
                            textColor: textColor,
                            borderColor: borderColor,
                            surfaceColor: surfaceColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _DateField(
                            label: 'Due Date',
                            date: dueDate,
                            minDate: startDate.value,
                            maxDate: projectDueDate,
                            labelColor: labelColor,
                            textColor: textColor,
                            borderColor: borderColor,
                            surfaceColor: surfaceColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Assignees
                    _SectionLabel('Assignees', labelColor),
                    _AssigneeRow(
                      allUsersAsync: allUsersAsync,
                      selectedAssignees: selectedAssignees,
                      labelColor: labelColor,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 20),

                    // Milestones
                    Row(
                      children: [
                        _SectionLabel('Milestones', labelColor),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _MilestoneList(
                      milestones: milestones,
                      nameCtrl: milestoneNameController,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      labelColor: labelColor,
                      textColor: textColor,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // ── Premium Footer ───────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
                  ),
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: labelColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Submit Button
                  ElevatedButton(
                    onPressed: isLoading.value ? null : saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF3B82F6) : const Color(0xFF05263E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading.value) ...[
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ] else ...[
                          Icon(existingTask != null ? Icons.save_as_rounded : Icons.add_rounded, size: 20),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          isLoading.value 
                            ? 'Saving...' 
                            : (existingTask != null ? 'Update Task' : 'Create Task'),
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
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
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

InputDecoration _inputDeco({
  required String hint,
  required Color borderColor,
  required Color surfaceColor,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.inter(
        color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500),
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: surfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.inter(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─── Date Field ───────────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  final String label;
  final ValueNotifier<DateTime> date;
  final DateTime? minDate;
  final DateTime? maxDate;
  final Color labelColor, textColor, borderColor, surfaceColor;

  const _DateField({
    required this.label,
    required this.date,
    this.minDate,
    this.maxDate,
    required this.labelColor,
    required this.textColor,
    required this.borderColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label, labelColor),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final effectiveFirstDate = minDate ?? DateTime(2024);
            final effectiveLastDate = maxDate ?? DateTime(2035);

            final picked = await showDatePicker(
              context: context,
              initialDate: date.value.isBefore(effectiveFirstDate)
                  ? effectiveFirstDate
                  : (date.value.isAfter(effectiveLastDate)
                      ? effectiveLastDate
                      : date.value),
              firstDate: effectiveFirstDate,
              lastDate: effectiveLastDate,
            );
            if (picked != null) date.value = picked;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month_rounded,
                    size: 18, color: Colors.blue.shade500),
                const SizedBox(width: 10),
                Text(
                  DateFormat('MMM dd, yyyy').format(date.value),
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Assignee Row ─────────────────────────────────────────────────────────────

class _AssigneeRow extends StatelessWidget {
  final AsyncValue<List<User>> allUsersAsync;
  final ValueNotifier<List<User>> selectedAssignees;
  final Color labelColor, surfaceColor, borderColor;

  const _AssigneeRow({
    required this.allUsersAsync,
    required this.selectedAssignees,
    required this.labelColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...selectedAssignees.value.map((u) => Chip(
              avatar: CircleAvatar(
                backgroundColor: UserColorService.getColorForUser(u.id),
                backgroundImage:
                    u.avatarUrl.isNotEmpty ? NetworkImage(u.avatarUrl) : null,
                child: u.avatarUrl.isEmpty
                    ? Text(UserColorService.getInitials(u.name),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                    : null,
              ),
              label: Text(
                u.name,
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
              deleteIcon: const Icon(Icons.close_rounded, size: 14),
              onDeleted: () {
                selectedAssignees.value = selectedAssignees.value
                    .where((user) => user.id != u.id)
                    .toList();
              },
              backgroundColor: surfaceColor,
              side: BorderSide(color: borderColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            )),
        ActionChip(
          avatar: Icon(Icons.person_add_rounded,
              size: 16, color: Colors.blue.shade600),
          label: Text(
            'Add Member',
            style: GoogleFonts.inter(
                color: Colors.blue.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w700),
          ),
          onPressed: () async {
            final available = allUsersAsync.value ?? [];
            final result = await showDialog<User>(
              context: context,
              builder: (ctx) => _AssigneePicker(
                allUsers: available,
                selectedIds: selectedAssignees.value.map((u) => u.id).toSet(),
              ),
            );
            if (result != null) {
              selectedAssignees.value = [...selectedAssignees.value, result];
            }
          },
          backgroundColor: Colors.blue.withOpacity(0.08),
          side: BorderSide(color: Colors.blue.shade200),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ],
    );
  }
}

// ─── Milestone List ───────────────────────────────────────────────────────────

class _MilestoneList extends StatelessWidget {
  final ValueNotifier<List<_Milestone>> milestones;
  final TextEditingController nameCtrl;
  final Color surfaceColor, borderColor, labelColor, textColor;

  const _MilestoneList({
    required this.milestones,
    required this.nameCtrl,
    required this.surfaceColor,
    required this.borderColor,
    required this.labelColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Existing milestones
          ...milestones.value.asMap().entries.map((entry) {
            final idx = entry.key;
            final m = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      m.title,
                      style: GoogleFonts.inter(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final newList = [...milestones.value];
                      newList.removeAt(idx);
                      milestones.value = newList;
                    },
                    child: Icon(Icons.remove_circle_outline,
                        size: 18, color: Colors.red.shade400),
                  ),
                ],
              ),
            );
          }),

          // Add new milestone row
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: nameCtrl,
              style: TextStyle(color: textColor, fontSize: 13),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _addMilestone(),
              decoration: InputDecoration(
                hintText: 'Add milestone (press Enter)',
                hintStyle: TextStyle(color: labelColor, fontSize: 13),
                isDense: true,
                border: InputBorder.none,
                icon: InkWell(
                  onTap: _addMilestone,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.add, size: 18, color: labelColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addMilestone() {
    final name = nameCtrl.text.trim();
    if (name.isNotEmpty) {
      milestones.value = [
        ...milestones.value,
        _Milestone(
          id: const Uuid().v4(),
          title: name,
          progressWeight: 0, // Placeholder, calculated on submit
        ),
      ];
      nameCtrl.clear();
    }
  }
}

// ─── Assignee Picker Dialog ───────────────────────────────────────────────────

class _AssigneePicker extends StatelessWidget {
  final List<User> allUsers;
  final Set<String> selectedIds;

  const _AssigneePicker({required this.allUsers, required this.selectedIds});

  @override
  Widget build(BuildContext context) {
    final available =
        allUsers.where((u) => !selectedIds.contains(u.id)).toList();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 320,
        height: 420,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.people_outline, size: 20),
                const SizedBox(width: 8),
                const Text('Select Assignee',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: available.isEmpty
                  ? const Center(child: Text('No more users to add'))
                  : ListView.builder(
                      itemCount: available.length,
                      itemBuilder: (context, index) {
                        final user = available[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: UserColorService.getColorForUser(user.id),
                            backgroundImage: user.avatarUrl.isNotEmpty
                                ? NetworkImage(user.avatarUrl)
                                : null,
                            child: user.avatarUrl.isEmpty
                                ? Text(UserColorService.getInitials(user.name),
                                    style:
                                        const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
                                : null,
                          ),
                          title: Text(user.name),
                          onTap: () => Navigator.pop(context, user),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          hoverColor: Colors.blue.withOpacity(0.05),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header Budget Badge ──────────────────────────────────────────────────────

class _HeaderBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;

  const _HeaderBadge({
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: highlight
            ? Colors.white.withOpacity(0.25)
            : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withOpacity(0.9)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: highlight ? FontWeight.w900 : FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
