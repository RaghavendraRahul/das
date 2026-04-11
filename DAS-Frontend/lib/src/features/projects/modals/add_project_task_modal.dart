import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';
import '../providers/api_providers.dart';
import '../../../core/utils/user_color_service.dart';
import 'package:uuid/uuid.dart';

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

  const AddProjectTaskModal({
    super.key,
    required this.projectId,
    this.projectStartDate,
    this.projectDueDate,
    this.projectBudgetHours = 0.0,
    this.usedHours = 0.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final plannedHoursController = useTextEditingController(text: '0.0');
    final priority = useState<String>('MEDIUM');
    // Constrain initial dates within project range
    final projectStart = projectStartDate ?? DateTime(2024);
    final projectEnd = projectDueDate ?? DateTime(2035);
    final now = DateTime.now();
    final initialStart = now.isBefore(projectStart) ? projectStart : (now.isAfter(projectEnd) ? projectStart : now);
    final initialDue = initialStart.add(const Duration(days: 7)).isAfter(projectEnd) ? projectEnd : initialStart.add(const Duration(days: 7));
    final startDate = useState<DateTime>(initialStart);
    final dueDate = useState<DateTime>(initialDue);
    final selectedAssignees = useState<List<User>>([]);
    final milestones = useState<List<_Milestone>>([]);
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

    Future<void> createTask() async {
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

      // Planned hours budget check
      final enteredHours = double.tryParse(plannedHoursController.text.trim()) ?? 0.0;
      if (projectBudgetHours > 0) {
        final remaining = projectBudgetHours - usedHours;
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

        final cleanProjectId = int.tryParse(projectId) ??
            int.tryParse(projectId.replaceFirst('api_project_', '')) ??
            0;

        await apiService.createTask(cleanProjectId, taskData);

        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Task created successfully!'),
              ]),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }

        ref.invalidate(apiTasksProvider);
        ref.invalidate(apiProjectProvider(cleanProjectId));
        ref.invalidate(projectsWithTasksProvider);
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

    final selectedPriority =
        _priorities.firstWhere((p) => p['value'] == priority.value);

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
            // ── Gradient Header ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.indigo.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.task_alt,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add New Task',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text('Fill in the details below to create a task',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
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
                    // Task Title
                    _SectionLabel('Task Title', labelColor),
                    TextField(
                      controller: titleController,
                      style: TextStyle(color: textColor, fontSize: 15),
                      decoration: _inputDeco(
                        hint: 'e.g. Design the login screen',
                        borderColor: borderColor,
                        surfaceColor: surfaceColor,
                        prefixIcon:
                            Icon(Icons.title, size: 18, color: labelColor),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _SectionLabel('Planned Hours', labelColor),
                    TextField(
                      controller: plannedHoursController,
                      style: TextStyle(color: textColor, fontSize: 15),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDeco(
                        hint: 'e.g. 8.0',
                        borderColor: borderColor,
                        surfaceColor: surfaceColor,
                        prefixIcon:
                            Icon(Icons.timer, size: 18, color: labelColor),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Priority
                    _SectionLabel('Priority', labelColor),
                    Row(
                      children: _priorities.map((p) {
                        final isSelected = priority.value == p['value'];
                        final color = Color(p['color'] as int);
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => priority.value = p['value'] as String,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withOpacity(0.15)
                                    : surfaceColor,
                                border: Border.all(
                                  color: isSelected ? color : borderColor,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(p['icon'] as IconData,
                                      color: color, size: 18),
                                  const SizedBox(height: 4),
                                  Text(
                                    p['label'] as String,
                                    style: TextStyle(
                                      color: isSelected ? color : labelColor,
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                        if (milestones.value.isNotEmpty)
                          // Removed weight badge as per request
                          Container(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _MilestoneList(
                      milestones: milestones,
                      nameCtrl: milestoneNameController,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      labelColor: labelColor,
                      textColor: textColor,
                    ),
                  ],
                ),
              ),
            ),

            // ── Footer ───────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  // Priority badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color((selectedPriority['color'] as int))
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(selectedPriority['icon'] as IconData,
                            size: 14,
                            color: Color(selectedPriority['color'] as int)),
                        const SizedBox(width: 4),
                        Text(
                          selectedPriority['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(selectedPriority['color'] as int),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: labelColor)),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: isLoading.value ? null : createTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: isLoading.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(isLoading.value ? 'Creating...' : 'Create Task',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    prefixIcon: prefixIcon,
    filled: true,
    fillColor: surfaceColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5)),
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
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: Colors.blue.shade400),
                const SizedBox(width: 8),
                Text(DateFormat('MMM dd, yyyy').format(date.value),
                    style: TextStyle(color: textColor, fontSize: 13)),
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
                    ? Text(u.name[0].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))
                    : null,
              ),
              label: Text(u.name, style: const TextStyle(fontSize: 13)),
              deleteIcon: const Icon(Icons.close, size: 14),
              onDeleted: () {
                selectedAssignees.value = selectedAssignees.value
                    .where((user) => user.id != u.id)
                    .toList();
              },
              backgroundColor: surfaceColor,
              side: BorderSide(color: borderColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            )),
        ActionChip(
          avatar: Icon(Icons.person_add_outlined,
              size: 16, color: Colors.blue.shade600),
          label: Text('Add',
              style: TextStyle(color: Colors.blue.shade600, fontSize: 13)),
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
                    child: Text(m.title,
                        style: TextStyle(color: textColor, fontSize: 13)),
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
                icon: Icon(Icons.add, size: 18, color: labelColor),
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
                                ? Text(user.name[0].toUpperCase(),
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
