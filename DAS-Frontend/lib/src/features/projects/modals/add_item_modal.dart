import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:drift/drift.dart' as drift;
import '../providers/api_providers.dart';
import 'package:uuid/uuid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/user_color_service.dart';
import 'dart:convert';
import '../../../core/models/milestone.dart';
import '../../dashboard/dashboard_providers.dart';

class AddItemModal extends HookConsumerWidget {
  final String projectId;

  const AddItemModal({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final activeTab = useState(0);

    useEffect(() {
      void listener() => activeTab.value = tabController.index;
      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 650,
        height: 800,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Tabs Header
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TabBar(
                      controller: tabController,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      labelColor: Colors.blue.shade700,
                      unselectedLabelColor: Colors.grey.shade600,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                      tabs: const [
                        Tab(text: "Standard"),
                        Tab(text: "Recurring"),
                        Tab(text: "Routine"),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _StandardTab(projectId: projectId),
                  _RecurringTab(projectId: projectId),
                  _RoutineTab(projectId: projectId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StandardTab extends HookConsumerWidget {
  final String projectId;
  const _StandardTab({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final githubController = useTextEditingController();
    final figmaController = useTextEditingController();

    final priority = useState<String>('Medium');
    final startDate = useState<DateTime>(DateTime.now());
    final deadline =
        useState<DateTime>(DateTime.now().add(const Duration(days: 7)));

    final selectedAssignees = useState<List<User>>([]);
    final milestones = useState<List<Milestone>>([]);

    // Effect to clear Due Date if it's before Start Date
    useEffect(() {
      if (deadline.value.isBefore(startDate.value)) {
        deadline.value = startDate.value.add(const Duration(days: 7));
      }
      return null;
    }, [startDate.value]);

    final milestoneNameController = useTextEditingController();
    final milestoneWeightController = useTextEditingController();
    final allUsersAsync = ref.watch(allUsersForProjectsProvider);

    return _BaseTabContent(
      title: "Add Standard Item",
      onCancel: () => Navigator.pop(context),
      onCreate: () async {
        if (nameController.text.isEmpty) {
          return _showError(context, "Name required");
        }
        final idsJson =
            jsonEncode(selectedAssignees.value.map((u) => u.id).toList());
        final milestonesJson =
            jsonEncode(milestones.value.map((m) => m.toJson()).toList());

        final newTask = TasksCompanion(
          id: drift.Value(const Uuid().v4()),
          projectId: drift.Value(projectId),
          name: drift.Value(nameController.text),
          priority: drift.Value(priority.value),
          startDate: drift.Value(startDate.value),
          endDate: drift.Value(deadline.value),
          progress: const drift.Value(0),
          assigneesJson: drift.Value(idsJson),
          milestonesJson: drift.Value(milestonesJson),
          approvalStatus: const drift.Value('pending_creation'),
          githubLink: drift.Value(
              githubController.text.isEmpty ? null : githubController.text),
          figmaLink: drift.Value(
              figmaController.text.isEmpty ? null : figmaController.text),
          taskType: const drift.Value('standard'),
        );
        await ref.read(projectRepositoryProvider).createTask(newTask);
        ref.invalidate(apiTasksProvider);
        ref.invalidate(projectsWithTasksProvider);
        ref.invalidate(currentProjectProvider);
        ref.invalidate(filteredDashboardStatsProvider);
        ref.invalidate(dashboardProjectsProvider);
        if (context.mounted) Navigator.pop(context);
      },
      createLabel: "Create Standard",
      children: [
        _buildRow([
          _buildField(
            flex: 2,
            label: "Name",
            child: TextField(
              controller: nameController,
              decoration: _inputDecoration("Task Name"),
            ),
          ),
          _buildField(
            flex: 1,
            label: "Priority",
            child: _buildPriorityDropdown(priority),
          ),
        ]),
        const SizedBox(height: 16),
        _buildRow([
          _DatePickerField(label: "Start Date", dateState: startDate),
          _DatePickerField(
              label: "Deadline", dateState: deadline, minDate: startDate.value),
        ]),
        const SizedBox(height: 16),
        _buildRow([
          _buildField(
            label: "GitHub",
            child: TextField(
              controller: githubController,
              decoration:
                  _inputDecoration("URL", icon: FontAwesomeIcons.github),
            ),
          ),
          _buildField(
            label: "Figma",
            child: TextField(
              controller: figmaController,
              decoration: _inputDecoration("URL", icon: FontAwesomeIcons.figma),
            ),
          ),
        ]),
        const SizedBox(height: 24),
        _buildAssigneesSection(context, allUsersAsync, selectedAssignees),
        const SizedBox(height: 24),
        _buildMilestonesSection(
            milestones, milestoneNameController, milestoneWeightController),
      ],
    );
  }
}

class _RecurringTab extends HookConsumerWidget {
  final String projectId;
  const _RecurringTab({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final priority = useState<String>('Medium');
    final startDate = useState<DateTime>(DateTime.now());
    final nextOccurrence =
        useState<DateTime>(DateTime.now().add(const Duration(days: 30)));
    final pattern = useState<String>('Monthly');

    final selectedAssignees = useState<List<User>>([]);
    final milestones = useState<List<Milestone>>([]);

    // Effect to clear nextOccurrence if it's before Start Date
    useEffect(() {
      if (nextOccurrence.value.isBefore(startDate.value)) {
        nextOccurrence.value = startDate.value.add(const Duration(days: 30));
      }
      return null;
    }, [startDate.value]);

    final milestoneNameController = useTextEditingController();
    final milestoneWeightController = useTextEditingController();
    final allUsersAsync = ref.watch(allUsersForProjectsProvider);

    return _BaseTabContent(
      title: "Add Recurring Item",
      onCancel: () => Navigator.pop(context),
      onCreate: () async {
        if (nameController.text.isEmpty) {
          return _showError(context, "Name required");
        }
        final idsJson =
            jsonEncode(selectedAssignees.value.map((u) => u.id).toList());
        final milestonesJson =
            jsonEncode(milestones.value.map((m) => m.toJson()).toList());

        final newTask = TasksCompanion(
          id: drift.Value(const Uuid().v4()),
          projectId: drift.Value(projectId),
          name: drift.Value(nameController.text),
          priority: drift.Value(priority.value),
          startDate: drift.Value(startDate.value),
          endDate: drift.Value(nextOccurrence.value),
          progress: const drift.Value(0),
          assigneesJson: drift.Value(idsJson),
          milestonesJson: drift.Value(milestonesJson),
          approvalStatus: const drift.Value('pending_creation'),
          taskType: const drift.Value('recurring'),
          recurrencePattern: drift.Value(pattern.value),
          nextOccurrence: drift.Value(nextOccurrence.value),
        );
        await ref.read(projectRepositoryProvider).createTask(newTask);
        ref.invalidate(apiTasksProvider);
        ref.invalidate(projectsWithTasksProvider);
        ref.invalidate(currentProjectProvider);
        ref.invalidate(filteredDashboardStatsProvider);
        ref.invalidate(dashboardProjectsProvider);
        if (context.mounted) Navigator.pop(context);
      },
      createLabel: "Create Recurring",
      children: [
        _buildRow([
          _buildField(
            flex: 2,
            label: "Name",
            child: TextField(
              controller: nameController,
              decoration: _inputDecoration("e.g. Monthly System Audit",
                  icon: Icons.bolt),
            ),
          ),
          _buildField(
            flex: 1,
            label: "Priority",
            child: _buildPriorityDropdown(priority),
          ),
        ]),
        const SizedBox(height: 16),
        _buildRow([
          _DatePickerField(label: "Start Date", dateState: startDate),
          _DatePickerField(
              label: "Next Occurrence",
              dateState: nextOccurrence,
              minDate: startDate.value),
        ]),
        const SizedBox(height: 16),
        _buildField(
          label: "Recurrence Pattern",
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: pattern.value,
                          isExpanded: true,
                          items: [
                            'Daily',
                            'Weekly',
                            'Monthly',
                            'Quarterly',
                            'Yearly'
                          ]
                              .map((p) =>
                                  DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) pattern.value = val;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                    "This task will automatically regenerate after completion.",
                    style:
                        TextStyle(color: Colors.blue.shade700, fontSize: 11)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildAssigneesSection(context, allUsersAsync, selectedAssignees),
        const SizedBox(height: 24),
        _buildMilestonesSection(
            milestones, milestoneNameController, milestoneWeightController,
            isRecurring: true),
      ],
    );
  }
}

class _RoutineTab extends HookConsumerWidget {
  final String projectId;
  const _RoutineTab({required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final priority = useState<String>('Medium');
    final startDate = useState<DateTime>(DateTime.now());
    final deadline =
        useState<DateTime>(DateTime.now().add(const Duration(days: 1)));

    final selectedAssignees = useState<List<User>>([]);

    // Effect to clear Due Date if it's before Start Date
    useEffect(() {
      if (deadline.value.isBefore(startDate.value)) {
        deadline.value = startDate.value.add(const Duration(days: 1));
      }
      return null;
    }, [startDate.value]);

    final allUsersAsync = ref.watch(allUsersForProjectsProvider);

    return _BaseTabContent(
      title: "Add Routine Item",
      onCancel: () => Navigator.pop(context),
      onCreate: () async {
        if (nameController.text.isEmpty) {
          return _showError(context, "Name required");
        }
        final idsJson =
            jsonEncode(selectedAssignees.value.map((u) => u.id).toList());

        final newTask = TasksCompanion(
          id: drift.Value(const Uuid().v4()),
          projectId: drift.Value(projectId),
          name: drift.Value(nameController.text),
          priority: drift.Value(priority.value),
          startDate: drift.Value(startDate.value),
          endDate: drift.Value(deadline.value),
          progress: const drift.Value(0),
          assigneesJson: drift.Value(idsJson),
          milestonesJson: const drift.Value('[]'),
          approvalStatus: const drift.Value('pending_creation'),
          taskType: const drift.Value('routine'),
        );
        await ref.read(projectRepositoryProvider).createTask(newTask);
        ref.invalidate(apiTasksProvider);
        ref.invalidate(projectsWithTasksProvider);
        ref.invalidate(currentProjectProvider);
        ref.invalidate(filteredDashboardStatsProvider);
        ref.invalidate(dashboardProjectsProvider);
        if (context.mounted) Navigator.pop(context);
      },
      createLabel: "Create Routine",
      buttonColor: Colors.blue.shade700,
      children: [
        _buildRow([
          _buildField(
            flex: 2,
            label: "Name",
            child: TextField(
              controller: nameController,
              decoration: _inputDecoration("Task Name", icon: Icons.bolt),
            ),
          ),
          _buildField(
            flex: 1,
            label: "Priority",
            child: _buildPriorityDropdown(priority),
          ),
        ]),
        const SizedBox(height: 16),
        _buildRow([
          _DatePickerField(label: "Start Date", dateState: startDate),
          _DatePickerField(
              label: "Deadline", dateState: deadline, minDate: startDate.value),
        ]),
        const SizedBox(height: 24),
        _buildAssigneesSection(context, allUsersAsync, selectedAssignees),
      ],
    );
  }
}

class _BaseTabContent extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onCancel;
  final VoidCallback onCreate;
  final String createLabel;
  final Color? buttonColor;

  const _BaseTabContent({
    required this.title,
    required this.children,
    required this.onCancel,
    required this.onCreate,
    required this.createLabel,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onCancel,
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: onCreate,
                style: buttonColor != null
                    ? FilledButton.styleFrom(backgroundColor: buttonColor)
                    : null,
                child: Text(createLabel),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Helper UI Builders
Widget _buildRow(List<Widget> children) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: children.asMap().entries.map((e) {
      return Expanded(
          child: Padding(
        padding: EdgeInsets.only(right: e.key == children.length - 1 ? 0 : 16),
        child: e.value,
      ));
    }).toList(),
  );
}

Widget _buildField(
    {required String label, required Widget child, int flex = 1}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      const SizedBox(height: 8),
      child,
    ],
  );
}

InputDecoration _inputDecoration(String hint, {IconData? icon}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: icon != null ? Icon(icon, size: 16, color: Colors.grey) : null,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    isDense: true,
  );
}

Widget _buildPriorityDropdown(ValueNotifier<String> priority) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: priority.value,
        isExpanded: true,
        items: ['Low', 'Medium', 'High', 'Critical']
            .map((p) => DropdownMenuItem(
                value: p, child: Text(p, style: const TextStyle(fontSize: 14))))
            .toList(),
        onChanged: (val) {
          if (val != null) priority.value = val;
        },
      ),
    ),
  );
}

Widget _buildAssigneesSection(BuildContext context,
    AsyncValue<List<User>> allUsers, ValueNotifier<List<User>> selected) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Assignees",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      const SizedBox(height: 12),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ...selected.value.map((u) => _AssigneeChip(
              user: u,
              onDelete: () {
                selected.value = [...selected.value]..remove(u);
              })),
          InkWell(
            onTap: () async {
              final user = await showDialog<User>(
                context: context,
                builder: (context) => _AssigneeSelector(
                  allUsers: allUsers.value ?? [],
                  selectedIds: selected.value.map((u) => u.id).toSet(),
                ),
              );
              if (user != null) selected.value = [...selected.value, user];
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade300, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text("Add",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildMilestonesSection(ValueNotifier<List<Milestone>> milestones,
    TextEditingController nameCtrl, TextEditingController weightCtrl,
    {bool isRecurring = false}) {
  final totalWeight = milestones.value.fold(0, (sum, m) => sum + m.weight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const Text("Milestones",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const Spacer(),
          if (isRecurring) ...[
            TextButton.icon(
              onPressed: () {
                milestones.value = [
                  Milestone(
                      id: const Uuid().v4(),
                      name: "Planning",
                      weight: 20,
                      completed: false),
                  Milestone(
                      id: const Uuid().v4(),
                      name: "Development",
                      weight: 50,
                      completed: false),
                  Milestone(
                      id: const Uuid().v4(),
                      name: "Testing",
                      weight: 20,
                      completed: false),
                  Milestone(
                      id: const Uuid().v4(),
                      name: "Deployment",
                      weight: 10,
                      completed: false),
                ];
              },
              icon: const Icon(Icons.auto_awesome,
                  size: 14, color: Colors.purple),
              label: const Text("Auto Generate",
                  style: TextStyle(fontSize: 11, color: Colors.purple)),
            ),
            const SizedBox(width: 8),
          ],
          Text("Total: $totalWeight%",
              style: TextStyle(
                  color: totalWeight == 100 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ...milestones.value.asMap().entries.map((entry) {
              final idx = entry.key;
              final m = entry.value;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade100)),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child:
                            Text(m.name, style: const TextStyle(fontSize: 13))),
                    Text("${m.weight}%",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 8),
                    IconButton(
                      icon:
                          const Icon(Icons.close, size: 14, color: Colors.grey),
                      onPressed: () {
                        final newList = [...milestones.value];
                        newList.removeAt(idx);
                        milestones.value = newList;
                      },
                    )
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                          hintText: "Add Step",
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(fontSize: 12)),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: weightCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: "%",
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(fontSize: 12)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.blue, size: 20),
                    onPressed: () {
                      final n = nameCtrl.text.trim();
                      final w = int.tryParse(weightCtrl.text) ?? 0;
                      if (n.isNotEmpty && w > 0) {
                        milestones.value = [
                          ...milestones.value,
                          Milestone(
                              id: const Uuid().v4(),
                              name: n,
                              weight: w,
                              completed: false)
                        ];
                        nameCtrl.clear();
                        weightCtrl.clear();
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ],
  );
}

void _showError(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _AssigneeChip extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;
  const _AssigneeChip({required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
              radius: 10,
              backgroundColor: UserColorService.getColorForUser(user.id),
              backgroundImage: user.avatarUrl.isNotEmpty
                  ? NetworkImage(user.avatarUrl)
                  : null,
              child: user.avatarUrl.isEmpty
                  ? Text(UserColorService.getInitials(user.name),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))
                  : null),
          const SizedBox(width: 6),
          Text(user.name,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          InkWell(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final ValueNotifier<DateTime> dateState;
  final DateTime? minDate;

  const _DatePickerField(
      {required this.label, required this.dateState, this.minDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final effectiveFirstDate = minDate ?? DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: dateState.value.isBefore(effectiveFirstDate)
                  ? effectiveFirstDate
                  : dateState.value,
              firstDate: effectiveFirstDate,
              lastDate: DateTime(2035),
            );
            if (picked != null) dateState.value = picked;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(DateFormat('MM/dd/yyyy').format(dateState.value),
                    style: const TextStyle(fontSize: 14)),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _AssigneeSelector extends StatelessWidget {
  final List<User> allUsers;
  final Set<String> selectedIds;

  const _AssigneeSelector({required this.allUsers, required this.selectedIds});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 400,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Select Assignee",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView(
                children:
                    allUsers.where((u) => !selectedIds.contains(u.id)).map((u) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: UserColorService.getColorForUser(u.id),
                        backgroundImage: u.avatarUrl.isNotEmpty
                            ? NetworkImage(u.avatarUrl)
                            : null,
                        child: u.avatarUrl.isEmpty
                            ? Text(UserColorService.getInitials(u.name),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))
                            : null),
                    title: Text(u.name),
                    onTap: () => Navigator.pop(context, u),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
