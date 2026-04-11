import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';

import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import '../../../core/utils/user_color_service.dart';

enum CreationStep { type, details, tasks }

enum WorkspaceType { project, course, routine }

/// Helper model for temporary tasks during creation
class _TempTask {
  String name;
  String priority;
  double plannedHours;
  DateTime? startDate;
  DateTime? endDate;
  List<String> assignees; // User IDs
  List<String> milestones;

  _TempTask({
    required this.name,
    this.priority = 'Medium',
    this.plannedHours = 0.0,
    this.startDate,
    this.endDate,
    this.assignees = const [],
    this.milestones = const [],
  });
}

class CreateNewWorkspaceModal extends HookConsumerWidget {
  const CreateNewWorkspaceModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(CreationStep.type);
    final selectedType = useState<WorkspaceType?>(null);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch Users for Assignees (Use allUsersForProjectsProvider to show ALL users including admins/managers)
    final allUsersAsync = ref.watch(allUsersForProjectsProvider);
    final usersAsync = allUsersAsync.whenData((users) => users
        .map((u) => {
              'id': int.tryParse(u.id) ?? -1,
              'name': u.name,
              'email': u.email,
            })
        .where((u) => u['id'] != -1)
        .toList());
    final backendUsersAsync = usersAsync;

    // Common Controllers
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final plannedHoursController = useTextEditingController();

    // Project Specific
    final projectLeadId = useState<int?>(null);
    final projectAssignees =
        useState<List<int>>([]); // CHANGED: Added projectAssignees
    // usersAsync already defined above
    final projectDeadline = useState<DateTime?>(null);

    // Project Date Controllers (Hoisted to avoid Hook crash)
    final deadlineController = useTextEditingController(
      text: projectDeadline.value != null
          ? DateFormat('dd/MM/yyyy').format(projectDeadline.value!)
          : '',
    );
    // Effects to sync controllers with state
    useEffect(() {
      deadlineController.text = projectDeadline.value != null
          ? DateFormat('dd/MM/yyyy').format(projectDeadline.value!)
          : '';
      return null;
    }, [projectDeadline.value]);

    // Task Planning State
    final taskList = useState<List<_TempTask>>([]);
    final taskNameController = useTextEditingController();
    final taskPriority = useState<String>('Medium');
    final taskStartDate = useState<DateTime?>(null);
    final taskEndDate = useState<DateTime?>(null);
    final taskAssignees = useState<List<String>>([]);
    final taskPlannedHoursController = useTextEditingController();
    final taskMilestones = useState<List<String>>([]);
    final milestoneController = useTextEditingController();

    // Task Date Controllers (Hoisted)
    final taskStartController = useTextEditingController(
      text: taskStartDate.value != null
          ? DateFormat('dd/MM/yyyy').format(taskStartDate.value!)
          : '',
    );
    final taskEndController = useTextEditingController(
      text: taskEndDate.value != null
          ? DateFormat('dd/MM/yyyy').format(taskEndDate.value!)
          : '',
    );
    // Sync Task Date Controllers
    useEffect(() {
      taskStartController.text = taskStartDate.value != null
          ? DateFormat('dd/MM/yyyy').format(taskStartDate.value!)
          : '';
      return null;
    }, [taskStartDate.value]);
    useEffect(() {
      taskEndController.text = taskEndDate.value != null
          ? DateFormat('dd/MM/yyyy').format(taskEndDate.value!)
          : '';
      return null;
    }, [taskEndDate.value]);
    // Effect to clear Due Date if it's before Start Date
    useEffect(() {
      if (taskStartDate.value != null &&
          taskEndDate.value != null &&
          taskEndDate.value!.isBefore(taskStartDate.value!)) {
        taskEndDate.value = null;
      }
      return null;
    }, [taskStartDate.value]);

    // Course Specific Controllers
    final instructorController = useTextEditingController();
    final scheduleController = useTextEditingController();

    // Routine Specific Controllers
    final routineCategory = useState<String>('Work');
    final routineFrequency = useState<String>('Daily');

    void goBack() {
      if (step.value == CreationStep.tasks) {
        step.value = CreationStep.details;
      } else if (step.value == CreationStep.details) {
        step.value = CreationStep.type;
        selectedType.value = null; // Reset selection on back to type
      }
    }

    void selectType(WorkspaceType type) {
      selectedType.value = type;
    }

    void handleContinue() {
      if (selectedType.value != null) {
        step.value = CreationStep.details;
      }
    }

    // Helper to pick date
    Future<void> pickDate(
        BuildContext context, ValueNotifier<DateTime?> dateState,
        {DateTime? maxDate, DateTime? minDate}) async {
      final now = DateTime.now();
      final effectiveFirstDate = minDate ?? now;
      final initialDate = dateState.value != null &&
              !dateState.value!.isBefore(effectiveFirstDate)
          ? dateState.value!
          : effectiveFirstDate;

      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: effectiveFirstDate,
        lastDate: maxDate ?? now.add(const Duration(days: 365 * 5)),
      );
      if (picked != null) {
        dateState.value = picked;
      }
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 700;
          final dialogWidth = isNarrow ? constraints.maxWidth : 900.0;
          final dialogHeight = isNarrow ? constraints.maxHeight * 0.95 : 800.0;

          return Container(
            width: dialogWidth,
            height: dialogHeight,
            constraints: BoxConstraints(
              maxWidth: 900,
              maxHeight: constraints.maxHeight * 0.95,
            ),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (step.value != CreationStep.type)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: InkWell(
                            onTap: goBack,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back_rounded,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create New Project",
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF002E6A), // Standard Navy Blue
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _Breadcrumb(
                              currentStep: step.value,
                              isDark: isDark,
                              isProject: selectedType.value == WorkspaceType.project,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey.shade400,
                        splashRadius: 24,
                      ),
                    ],
                  ),
                ),

                // Body
                Expanded(
                  child: step.value == CreationStep.tasks
                      ? Padding(
                          padding: EdgeInsets.all(isNarrow ? 16.0 : 24.0),
                          child: _buildBody(
                            context,
                            ref,
                            step.value,
                            isDark,
                            selectedType.value,
                            selectType,
                            nameController,
                            descriptionController,
                            projectLeadId,
                            usersAsync,
                            projectDeadline,
                            deadlineController,
                            taskList,
                            taskNameController,
                            taskPriority,
                            taskStartDate,
                            taskEndDate,
                            taskStartController,
                            taskEndController,
                            taskAssignees,
                            taskPlannedHoursController,
                            taskMilestones,
                            milestoneController,
                            backendUsersAsync,
                            projectAssignees,
                            instructorController,
                            scheduleController,
                            routineCategory,
                            routineFrequency,
                            goBack,
                            (state, {DateTime? maxDate, DateTime? minDate}) =>
                                pickDate(context, state, maxDate: maxDate, minDate: minDate),
                            () {
                              step.value = CreationStep.tasks;
                            },
                            plannedHoursController,
                            handleContinue,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(isNarrow ? 16.0 : 24.0),
                          child: _buildBody(
                            context,
                            ref,
                            step.value,
                            isDark,
                            selectedType.value,
                            selectType,
                            nameController,
                            descriptionController,
                            projectLeadId,
                            usersAsync,
                            projectDeadline,
                            deadlineController,
                            taskList,
                            taskNameController,
                            taskPriority,
                            taskStartDate,
                            taskEndDate,
                            taskStartController,
                            taskEndController,
                            taskAssignees,
                            taskPlannedHoursController,
                            taskMilestones,
                            milestoneController,
                            backendUsersAsync,
                            projectAssignees,
                            instructorController,
                            scheduleController,
                            routineCategory,
                            routineFrequency,
                            goBack,
                            (state, {DateTime? maxDate, DateTime? minDate}) =>
                                pickDate(context, state, maxDate: maxDate, minDate: minDate),
                            () {
                              step.value = CreationStep.tasks;
                            },
                            plannedHoursController,
                            handleContinue,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CreationStep step,
    bool isDark,
    WorkspaceType? selectedType,
    Function(WorkspaceType) onSelectType,
    TextEditingController nameController,
    TextEditingController descController,
    ValueNotifier<int?> projectLeadId,
    AsyncValue<List<dynamic>> usersAsync,
    ValueNotifier<DateTime?> projectDeadline,
    TextEditingController deadlineController,
    // Task Props
    ValueNotifier<List<_TempTask>> taskList,
    TextEditingController taskNameController,
    ValueNotifier<String> taskPriority,
    ValueNotifier<DateTime?> taskStartDate,
    ValueNotifier<DateTime?> taskEndDate,
    TextEditingController taskStartController,
    TextEditingController taskEndController,
    ValueNotifier<List<String>> taskAssignees,
    TextEditingController taskPlannedHoursController,
    ValueNotifier<List<String>> taskMilestones,
    TextEditingController milestoneController,
    AsyncValue<List<dynamic>> backendUsersAsync,
    ValueNotifier<List<int>> projectAssignees, // Corrected type and position
    // Course Props
    // Course Props
    TextEditingController instructorController,
    TextEditingController scheduleController,
    // Routine Props
    ValueNotifier<String> routineCategory,
    ValueNotifier<String> routineFrequency,
    VoidCallback onBack,
    Function(ValueNotifier<DateTime?>, {DateTime? maxDate, DateTime? minDate})
        onPickDate,
    VoidCallback onStartPlanning,
    TextEditingController plannedHoursController,
    VoidCallback onContinue,
  ) {
    final projectLimit = double.tryParse(plannedHoursController.text) ?? 0.0;
    final totalPlanned =
        taskList.value.fold<double>(0, (sum, t) => sum + t.plannedHours);
    final remainingHours = projectLimit - totalPlanned;
    switch (step) {
      case CreationStep.type:
        return Column(
          children: [
            Column(
              children: [
                _SelectionCard(
                  title: "Dev Project",
                  description: "Software, Design, Marketing tasks with deadlines.",
                  icon: Icons.developer_mode_rounded,
                  type: WorkspaceType.project,
                  isSelected: selectedType == WorkspaceType.project,
                  isDark: isDark,
                  onTap: () => onSelectType(WorkspaceType.project),
                ),
                const SizedBox(height: 16),
                _SelectionCard(
                  title: "Class / Course",
                  description: "Syllabus, Lessons, and Training Modules.",
                  icon: Icons.school_rounded,
                  type: WorkspaceType.course,
                  isSelected: selectedType == WorkspaceType.course,
                  isDark: isDark,
                  onTap: () => onSelectType(WorkspaceType.course),
                ),
                const SizedBox(height: 16),
                _SelectionCard(
                  title: "Routing Group",
                  description: "Weekly meeting, CRM, and daily admin.",
                  icon: Icons.coffee_rounded,
                  type: WorkspaceType.routine,
                  isSelected: selectedType == WorkspaceType.routine,
                  isDark: isDark,
                  onTap: () => onSelectType(WorkspaceType.routine),
                ),
              ],
            ),
            const Spacer(),
            // Bottom Bar for first step
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: selectedType != null ? onContinue : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: Colors.grey.shade200,
                    ),
                    child: Text(
                      "Continue",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case CreationStep.details:
        // Determine colors for the card
        final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
        final borderColor =
            isDark ? Colors.grey.shade700 : Colors.grey.shade200;

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Badge(
                        label: _getWorkspaceLabel(selectedType!), isDark: isDark),
                  ],
                ),
                const SizedBox(height: 32),

              // Dynamic Fields based on Type
              if (selectedType == WorkspaceType.project) ...[
                _buildTextField(
                    nameController, "Project Name", "e.g. Q3 Marketing Plan"),
                const SizedBox(height: 24),
                _buildTextField(descController, "Description / Goal",
                    "Brief description...",
                    maxLines: 4),
                const SizedBox(height: 24),
                // CHANGED: Added Project Assignees Field
                _buildUserMultiSelect(
                    projectAssignees, usersAsync, "Project Assignees", isDark,
                    onRemove: (id) {
                  if (projectLeadId.value == id) {
                    projectLeadId.value = null; // Clear lead if removed
                  }
                }),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildUserDropdown(
                          projectLeadId,
                          usersAsync,
                          projectAssignees, // Pass assignees to filter
                          "Project Lead",
                          isDark),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildTextField(
                          deadlineController, "Deadline *", "dd/MM/yyyy",
                          suffixIcon: Icons.calendar_today_rounded,
                          readOnly: true,
                          onTap: () => onPickDate(projectDeadline)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                    plannedHoursController, "Planned Hours", "e.g. 160",
                    keyboardType: TextInputType.number),
              ] else if (selectedType == WorkspaceType.course) ...[
                // Course Form - FULL WIDTH NAME, REMOVED SUBJECT CODE
                _buildTextField(
                    nameController, "Course Name", "e.g. Advanced Flutter"),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextField(instructorController,
                            "Instructor", "e.g. Dr. Smith")),
                    const SizedBox(width: 24),
                    Expanded(
                        child: _buildTextField(scheduleController, "Schedule",
                            "e.g. Mon/Wed 10-11 AM")),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(descController,
                    "Description / Syllabus Summary", "Brief overview...",
                    maxLines: 4),
              ] else if (selectedType == WorkspaceType.routine) ...[
                // Routine Form
                _buildTextField(
                    nameController, "Routine Name", "e.g. Daily Standup"),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: "Category",
                        value: routineCategory.value,
                        items: ["Work", "Health", "Personal", "Study"],
                        onChanged: (val) {
                          if (val != null) routineCategory.value = val;
                        },
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDropdown(
                        label: "Frequency",
                        value: routineFrequency.value,
                        items: ["Daily", "Weekly", "Monthly"],
                        onChanged: (val) {
                          if (val != null) routineFrequency.value = val;
                        },
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                    descController, "Description / Notes", "Routine details...",
                    maxLines: 4),
              ],

              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onBack,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      textStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    child: const Text("Back"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a name")),
                        );
                        return;
                      }

                      if (selectedType == WorkspaceType.project) {
                        // Validation: Deadline is mandatory
                        if (projectDeadline.value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a deadline"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        // Move to Step 2
                        onStartPlanning();
                      } else {
                        // Create Immediately for other types
                        await _createWorkspace(
                          context,
                          ref,
                          selectedType,
                          nameController.text,
                          descController.text,
                          instructorController.text,
                          scheduleController.text,
                          routineCategory.value,
                          routineFrequency.value,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    child: Text(selectedType == WorkspaceType.project
                        ? "Start Plan"
                        : "Create Workspace"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      case CreationStep.tasks:
        return LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Task Planning",
                            style: GoogleFonts.inter(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          if (projectLimit > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: (remainingHours >= 0
                                        ? Colors.green
                                        : Colors.red)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: (remainingHours >= 0
                                            ? Colors.green
                                            : Colors.red)
                                        .withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                remainingHours >= 0
                                    ? "${remainingHours.toStringAsFixed(1)}h Remaining"
                                    : "${(remainingHours * -1).toStringAsFixed(1)}h Over Budget",
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: remainingHours >= 0
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        "Project: ${nameController.text}",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (taskList.value.isEmpty) {
                        if (taskNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please fill in the task name to add a task",
                                  style:
                                      GoogleFonts.inter(color: Colors.white)),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                            ),
                          );
                          return;
                        } else {
                          // Auto-add the task
                          final newTask = _TempTask(
                            name: taskNameController.text,
                            priority: taskPriority.value,
                            plannedHours: double.tryParse(
                                    taskPlannedHoursController.text) ??
                                0.0,
                            startDate: taskStartDate.value,
                            endDate: taskEndDate.value,
                            assignees: List.from(taskAssignees.value),
                            milestones: List.from(taskMilestones.value),
                          );
                          taskList.value = [...taskList.value, newTask];
                        }
                      }

                      // FINAL CREATE for Project
                      await _createProjectWithTasks(
                        context,
                        ref,
                        nameController.text,
                        descController.text,
                        projectLeadId.value,
                        projectDeadline.value,
                        taskList.value,
                        projectAssignees.value, // Pass assignees
                        double.tryParse(plannedHoursController.text) ?? 0.0,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981), // Emerald Green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 20),
                    label: const Text("Create Project"),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // LEFT: ADD TASK FORM
                            Expanded(
                              flex: 6,
                              child: _AddTaskForm(
                                context: context,
                                isDark: isDark,
                                taskNameController: taskNameController,
                                taskPriority: taskPriority,
                                taskStartDate: taskStartDate,
                                taskEndDate: taskEndDate,
                                taskStartController: taskStartController,
                                taskEndController: taskEndController,
                                taskAssignees: taskAssignees,
                                taskPlannedHoursController:
                                    taskPlannedHoursController,
                                taskMilestones: taskMilestones,
                                milestoneController: milestoneController,
                                backendUsersAsync: backendUsersAsync,
                                projectAssignees: projectAssignees
                                    .value, // Pass project assignees
                                taskList: taskList,
                                onPickDate: onPickDate,
                                projectDeadline: projectDeadline.value,
                                projectPlannedHours: projectLimit,
                              ),
                            ),
                            const SizedBox(width: 32),

                            // RIGHT: TASK LIST
                            Expanded(
                              flex: 4,
                              child: _buildTaskList(isDark, taskList),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(children: [
                          _AddTaskForm(
                            context: context,
                            isDark: isDark,
                            taskNameController: taskNameController,
                            taskPriority: taskPriority,
                            taskStartDate: taskStartDate,
                            taskEndDate: taskEndDate,
                            taskStartController: taskStartController,
                            taskEndController: taskEndController,
                            taskAssignees: taskAssignees,
                            taskPlannedHoursController: taskPlannedHoursController,
                            taskMilestones: taskMilestones,
                            milestoneController: milestoneController,
                            backendUsersAsync: backendUsersAsync,
                            projectAssignees: projectAssignees.value,
                            taskList: taskList,
                            onPickDate: onPickDate,
                            projectDeadline: projectDeadline.value,
                            projectPlannedHours: projectLimit,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                              height: 400,
                              child: _buildTaskList(isDark, taskList)),
                        ]))),
            ],
          );
        });
    }
  }

  Widget _buildTaskList(bool isDark, ValueNotifier<List<_TempTask>> taskList) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Planned Tasks",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700, fontSize: 18)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("${taskList.value.length} Tasks",
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: taskList.value.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.assignment_outlined,
                              size: 48,
                              color: isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300),
                        ),
                        const SizedBox(height: 24),
                        Text("No tasks added yet",
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade800)),
                        const SizedBox(height: 8),
                        Text(
                            "Use the form on the left to add tasks\nto your project plan.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                color: isDark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade500,
                                height: 1.5)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: taskList.value.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = taskList.value[index];
                      Color priorityColor = Colors.orange;
                      if (task.priority == 'High') priorityColor = Colors.red;
                      if (task.priority == 'Low') priorityColor = Colors.green;

                      return Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF111827)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(width: 4, color: priorityColor),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(task.name,
                                                  style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                final newList = [
                                                  ...taskList.value
                                                ];
                                                newList.removeAt(index);
                                                taskList.value = newList;
                                              },
                                              child: Icon(
                                                  Icons.delete_outline_rounded,
                                                  size: 18,
                                                  color: Colors.grey.shade400),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_today_rounded,
                                                size: 12,
                                                color: Colors.grey.shade500),
                                            const SizedBox(width: 4),
                                            Text(
                                              task.endDate != null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(task.endDate!)
                                                  : 'No Deadline',
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade500),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                    color: priorityColor
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Text(task.priority,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: priorityColor)))
                                          ],
                                        ),
                                        if (task.assignees.isNotEmpty ||
                                            task.milestones.isNotEmpty) ...[
                                          const SizedBox(height: 12),
                                          Wrap(
                                            spacing: 12,
                                            runSpacing: 8,
                                            children: [
                                              if (task.assignees.isNotEmpty)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .people_outline_rounded,
                                                        size: 14,
                                                        color: Colors
                                                            .grey.shade500),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                        "${task.assignees.length}",
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600)),
                                                  ],
                                                ),
                                              if (task.milestones.isNotEmpty)
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.flag_outlined,
                                                        size: 14,
                                                        color: Colors
                                                            .grey.shade500),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                        "${task.milestones.length}",
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600)),
                                                  ],
                                                ),
                                            ],
                                          )
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _createWorkspace(
    BuildContext context,
    WidgetRef ref,
    WorkspaceType type,
    String name,
    String desc,
    String instructor,
    String schedule,
    String? category,
    String? frequency,
  ) async {
    try {
      final projectRepo = ref.read(projectRepositoryProvider);
      final apiService = ref.read(taskApiServiceProvider);
      final newId = 'proj-${DateTime.now().millisecondsSinceEpoch}';

      String finalDescription = desc;
      if (type == WorkspaceType.course) {
        finalDescription =
            "Instructor: $instructor\nSchedule: $schedule\n\n$desc";
      } else if (type == WorkspaceType.routine) {
        finalDescription =
            "Category: $category\nFrequency: $frequency\n\n$desc";
      }

      if (type == WorkspaceType.project) {
        await projectRepo.createProject(
          ProjectsCompanion(
            id: Value(newId),
            name: Value(name),
            context: Value(finalDescription),
            status: const Value('active'),
            approvalStatus: const Value('pending_creation'),
            dueDate:
                Value(schedule.isNotEmpty ? DateTime.tryParse(schedule) : null),
          ),
        );
        ref.invalidate(apiProjectsProvider);
      } else {
        final catalogType = type == WorkspaceType.course ? 'COURSE' : 'ROUTINE';
        await apiService.createCatalogItem(
          name: name,
          description: finalDescription,
          catalogType: catalogType,
          isActive: true,
        );

        ref.invalidate(apiCatalogProvider);
        if (type == WorkspaceType.course) {
          ref.invalidate(apiCoursesProvider);
        } else {
          ref.invalidate(apiRoutinesProvider);
        }
      }

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "${type == WorkspaceType.project ? 'Project' : type == WorkspaceType.course ? 'Course' : 'Routine'} '$name' Created!",
                style: GoogleFonts.inter()),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _createProjectWithTasks(
    BuildContext context,
    WidgetRef ref,
    String name,
    String desc,
    int? leadId,
    DateTime? deadline,
    List<_TempTask> tasks,
    List<int> assignees,
    double plannedHours,
  ) async {
    try {
      final apiService = ref.read(taskApiServiceProvider);

      final tasksPayload = tasks
          .map((t) => <String, dynamic>{
                'name': t.name,
                'priority': t.priority,
                if (t.startDate != null)
                  'start_date':
                      '${t.startDate!.year}-${t.startDate!.month.toString().padLeft(2, '0')}-${t.startDate!.day.toString().padLeft(2, '0')}',
                if (t.endDate != null)
                  'end_date':
                      '${t.endDate!.year}-${t.endDate!.month.toString().padLeft(2, '0')}-${t.endDate!.day.toString().padLeft(2, '0')}',
                'assignees':
                    t.assignees.map((a) => int.tryParse(a) ?? a).toList(),
                'planned_hours': t.plannedHours,
                'milestones': t.milestones,
              })
          .toList();

      await apiService.createProjectWithTasks(
        name: name,
        description: desc,
        projectLead: leadId,
        deadline: deadline,
        tasks: tasksPayload,
        assignees: assignees,
        plannedHours: plannedHours,
      );

      ref.invalidate(apiProjectsProvider);
      ref.invalidate(apiTasksProvider);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Project '$name' with ${tasks.length} tasks created!",
                style: GoogleFonts.inter()),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: Colors.grey.shade500)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.inter(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildUserDropdown(
      ValueNotifier<int?> selectedUserId,
      AsyncValue<List<dynamic>> usersAsync,
      ValueNotifier<List<int>> allowedIds,
      String label,
      bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade600)),
        const SizedBox(height: 12),
        usersAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error loading users',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.red),
            ),
          ),
          data: (users) {
            final filteredUsers =
                users.where((u) => allowedIds.value.contains(u['id'])).toList();

            if (filteredUsers.isEmpty) {
              return Text(
                "Select Assignees first",
                style: GoogleFonts.inter(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontStyle: FontStyle.italic),
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 12,
              children: filteredUsers.map((user) {
                final userId = user['id'] as int;
                final isSelected = selectedUserId.value == userId;
                final userName =
                    (user['name'] ?? user['email'] ?? 'User') as String;
                final initial =
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?';

                return InkWell(
                  onTap: () {
                    selectedUserId.value = userId;
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withValues(alpha: 0.1)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : (isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: UserColorService.getColorForUser(userId),
                          child: Text(
                            initial,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          userName,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.blue
                                : (isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade800),
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle_rounded,
                              size: 14, color: Colors.blue)
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserMultiSelect(
    ValueNotifier<List<int>> selectedIds,
    AsyncValue<List<dynamic>> usersAsync,
    String label,
    bool isDark, {
    Function(int)? onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        usersAsync.when(
          loading: () => const LinearProgressIndicator(minHeight: 2),
          error: (_, __) => const Text("Error loading users",
              style: TextStyle(color: Colors.red)),
          data: (users) {
            final availableUsers = users
                .where((u) => !selectedIds.value.contains(u['id']))
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                    color: isDark ? const Color(0xFF374151) : Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      hint: Text("Add Assignee",
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.grey.shade500)),
                      items: availableUsers.map((u) {
                        return DropdownMenuItem<int>(
                          value: u['id'] as int,
                          child: Text(
                            u['name'] ?? u['email'] ?? 'User ${u['id']}',
                            style: GoogleFonts.inter(
                                color: isDark ? Colors.white : Colors.black87),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          selectedIds.value = [...selectedIds.value, val];
                        }
                      },
                      dropdownColor:
                          isDark ? const Color(0xFF374151) : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (selectedIds.value.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedIds.value.map((id) {
                      final user = users
                          .cast<Map<String, dynamic>>()
                          .firstWhere((u) => u['id'] == id, orElse: () => {});
                      final name = user['name'] ?? user['email'] ?? 'User $id';
                      return Chip(
                        label:
                            Text(name, style: GoogleFonts.inter(fontSize: 12)),
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        onDeleted: () {
                          selectedIds.value =
                              selectedIds.value.where((x) => x != id).toList();
                          onRemove?.call(id);
                        },
                        side: BorderSide(color: Colors.blue.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      );
                    }).toList(),
                  ),
              ],
            );
          },
        )
      ],
    );
  }

  String _getWorkspaceLabel(WorkspaceType type) {
    switch (type) {
      case WorkspaceType.project:
        return "Dev Project";
      case WorkspaceType.course:
        return "Class / Course";
      case WorkspaceType.routine:
        return "Routine Group";
    }
  }
}

class _AddTaskForm extends HookConsumerWidget {
  final BuildContext context;
  final bool isDark;
  final TextEditingController taskNameController;
  final ValueNotifier<String> taskPriority;
  final ValueNotifier<DateTime?> taskStartDate;
  final ValueNotifier<DateTime?> taskEndDate;
  final TextEditingController taskStartController;
  final TextEditingController taskEndController;
  final ValueNotifier<List<String>> taskAssignees;
  final TextEditingController taskPlannedHoursController;
  final ValueNotifier<List<String>> taskMilestones;
  final TextEditingController milestoneController;
  final AsyncValue<List<dynamic>> backendUsersAsync;
  final List<int> projectAssignees;
  final ValueNotifier<List<_TempTask>> taskList;
  final Function(ValueNotifier<DateTime?>,
      {DateTime? maxDate, DateTime? minDate}) onPickDate;
  final DateTime? projectDeadline;
  final double projectPlannedHours;

  const _AddTaskForm({
    required this.context,
    required this.isDark,
    required this.taskNameController,
    required this.taskPriority,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.taskStartController,
    required this.taskEndController,
    required this.taskAssignees,
    required this.taskPlannedHoursController,
    required this.taskMilestones,
    required this.milestoneController,
    required this.backendUsersAsync,
    required this.projectAssignees,
    required this.taskList,
    required this.onPickDate,
    this.projectDeadline,
    required this.projectPlannedHours,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    final hintColor = isDark ? Colors.grey.shade500 : Colors.grey.shade400;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_task_rounded,
                        color: Colors.blue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text("Add New Task",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700, fontSize: 18)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                        taskNameController, "Task Name", "e.g. Setup Repo"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      taskPlannedHoursController,
                      "Hours",
                      "e.g. 8",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildPriorityDropdown(
                        taskPriority, isDark, borderColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      taskStartController,
                      "Start Date",
                      "dd/MM/yyyy",
                      readOnly: true,
                      suffixIcon: Icons.calendar_today_rounded,
                      onTap: () =>
                          onPickDate(taskStartDate, maxDate: projectDeadline),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      taskEndController,
                      "Due Date",
                      "dd/MM/yyyy",
                      readOnly: true,
                      suffixIcon: Icons.event_rounded,
                      onTap: () => onPickDate(taskEndDate,
                          maxDate: projectDeadline,
                          minDate: taskStartDate.value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text("Assignees",
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              backendUsersAsync.when(
                data: (users) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Select Assignees",
                          style: GoogleFonts.inter(
                              fontSize: 14, color: hintColor)),
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey.shade400),
                      items: users
                          .where((u) => projectAssignees
                              .contains(u['id']))
                          .map((u) => DropdownMenuItem<String>(
                              value: u['id'].toString(),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: UserColorService.getColorForUser(u['id']),
                                    child: Text(
                                      (u['name'] ?? 'U')[0].toUpperCase(),
                                      style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${u['name'] ?? u['email'] ?? 'User ${u['id']}'}',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.grey.shade800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )))
                          .toList(),
                      onChanged: (val) {
                        if (val != null && !taskAssignees.value.contains(val)) {
                          taskAssignees.value = [...taskAssignees.value, val];
                        }
                      },
                      dropdownColor:
                          isDark ? const Color(0xFF374151) : Colors.white,
                    ),
                  ),
                ),
                loading: () => const LinearProgressIndicator(minHeight: 2),
                error: (_, __) => const Text("Error loading users",
                    style: TextStyle(color: Colors.red)),
              ),
              if (taskAssignees.value.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: taskAssignees.value.map((uid) {
                    final users = backendUsersAsync.valueOrNull ?? [];
                    final user = users
                        .cast<Map<String, dynamic>>()
                        .where((u) => u['id'].toString() == uid)
                        .firstOrNull;
                    final userName = user != null
                        ? (user['name'] ?? user['email'] ?? 'User $uid')
                        : 'User $uid';
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.blue.withValues(alpha: 0.2)
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isDark
                                ? Colors.blue.withValues(alpha: 0.3)
                                : Colors.blue.shade100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(userName.toString(),
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.blue.shade100
                                      : Colors.blue.shade700)),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              taskAssignees.value = taskAssignees.value
                                  .where((id) => id != uid)
                                  .toList();
                            },
                            child: Icon(Icons.close_rounded,
                                size: 14,
                                color: isDark
                                    ? Colors.blue.shade200
                                    : Colors.blue.shade400),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 24),
              Text("Milestones",
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: milestoneController,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Add key milestone...",
                          hintStyle: GoogleFonts.inter(color: hintColor),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onSubmitted: (_) {
                          if (milestoneController.text.isNotEmpty) {
                            taskMilestones.value = [
                              ...taskMilestones.value,
                              milestoneController.text
                            ];
                            milestoneController.clear();
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(11)),
                          border: Border(
                              left: BorderSide(color: Colors.grey.shade200))),
                      child: IconButton(
                        onPressed: () {
                          if (milestoneController.text.isNotEmpty) {
                            taskMilestones.value = [
                              ...taskMilestones.value,
                              milestoneController.text
                            ];
                            milestoneController.clear();
                          }
                        },
                        icon: const Icon(Icons.add_rounded, color: Colors.blue),
                        tooltip: "Add Milestone",
                      ),
                    ),
                  ],
                ),
              ),
              if (taskMilestones.value.isNotEmpty) ...[
                const SizedBox(height: 12),
                Column(
                  children: taskMilestones.value
                      .map((m) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.orange.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.flag_rounded,
                                    size: 16, color: Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text(m,
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500))),
                                InkWell(
                                  onTap: () {
                                    taskMilestones.value = taskMilestones.value
                                        .where((im) => im != m)
                                        .toList();
                                  },
                                  child: Icon(Icons.close_rounded,
                                      size: 16, color: Colors.grey.shade400),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                )
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (taskNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please fill in the task fields",
                              style: GoogleFonts.inter(color: Colors.white)),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(20),
                        ),
                      );
                      return;
                    }

                    final newTask = _TempTask(
                      name: taskNameController.text,
                      priority: taskPriority.value,
                      plannedHours:
                          double.tryParse(taskPlannedHoursController.text) ??
                              0.0,
                      startDate: taskStartDate.value,
                      endDate: taskEndDate.value,
                      assignees: List.from(taskAssignees.value),
                      milestones: List.from(taskMilestones.value),
                    );
                    taskList.value = [...taskList.value, newTask];

                    taskNameController.clear();
                    taskPlannedHoursController.clear();
                    taskPriority.value = 'Medium';
                    taskStartDate.value = null;
                    taskEndDate.value = null;
                    taskAssignees.value = [];
                    taskMilestones.value = [];
                    milestoneController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  label: Text("Add to Plan",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: Colors.grey.shade500)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown(
      ValueNotifier<String> priority, bool isDark, Color borderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Priority",
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
            color: isDark ? null : Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: priority.value,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 20, color: Colors.grey.shade400),
              items: ["Low", "Medium", "High"].map((p) {
                Color color;
                if (p == 'High') {
                  color = Colors.red;
                } else if (p == 'Medium') {
                  color = Colors.orange;
                } else {
                  color = Colors.green;
                }

                return DropdownMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            p,
                            style: GoogleFonts.inter(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ));
              }).toList(),
              onChanged: (val) => priority.value = val!,
              dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final CreationStep currentStep;
  final bool isDark;
  final bool isProject;

  const _Breadcrumb(
      {required this.currentStep,
      required this.isDark,
      required this.isProject});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _step("TYPE", CreationStep.type),
        _arrow(),
        _step("DETAILS", CreationStep.details),
        if (isProject) ...[
          _arrow(),
          _step("TASKS", CreationStep.tasks),
        ],
      ],
    );
  }

  Widget _step(String label, CreationStep? step) {
    final isActive = step == currentStep;
    final isPast = step != null && step.index < currentStep.index;

    Color color;
    if (isActive) {
      color = const Color(0xFF002E6A); // Active step in theme color
    } else if (isPast) {
      color = Colors.grey.shade600;
    } else {
      color = Colors.grey.shade400;
    }

    // Convert to title case for cleaner 14pt appearance
    final displayLabel = label.substring(0, 1).toUpperCase() + label.substring(1).toLowerCase();

    return Text(
      displayLabel,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: color,
      ),
    );
  }

  Widget _arrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Icon(
        Icons.chevron_right_rounded,
        size: 16,
        color: Colors.grey.shade400,
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final WorkspaceType type;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor();
    final bgColor = isDark 
        ? (isSelected ? themeColor.withValues(alpha: 0.15) : const Color(0xFF1F2937))
        : (isSelected ? Colors.white : const Color(0xFFF9FAFB));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: themeColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF002E6A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
          ],
        ),
      ),
    );
  }

  Color _getThemeColor() {
    switch (type) {
      case WorkspaceType.project:
        return const Color(0xFF3B82F6);
      case WorkspaceType.course:
        return const Color(0xFF10B981);
      case WorkspaceType.routine:
        return const Color(0xFF8B5CF6);
    }
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool isDark;

  const _Badge({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }
}
