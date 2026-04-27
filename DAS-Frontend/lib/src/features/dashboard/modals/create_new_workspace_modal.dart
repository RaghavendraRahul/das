import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:flutter/services.dart';
import 'package:project_pm/src/core/utils/user_color_service.dart';

enum CreationStep { type, details, tasks, createClient }

enum WorkspaceType { project, course, routine, client }

/// Helper model for temporary tasks during creation
class _TempTask {
  String? id; // Added for edit mode
  String name;
  String priority;
  double plannedHours;
  DateTime? startDate;
  DateTime? endDate;
  List<int> assignees; // User IDs
  List<String> milestones;

  _TempTask({
    this.id,
    required this.name,
    this.priority = 'MEDIUM',
    this.plannedHours = 0.0,
    this.startDate,
    this.endDate,
    this.assignees = const [],
    this.milestones = const [],
  });
}

class CreateNewWorkspaceModal extends HookConsumerWidget {
  final ProjectWithTasks? projectToEdit;

  const CreateNewWorkspaceModal({super.key, this.projectToEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(
        projectToEdit != null ? CreationStep.details : CreationStep.type);
    final selectedType = useState<WorkspaceType?>(
        projectToEdit != null ? WorkspaceType.project : null);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fetch Users for Assignees
    final allUsersAsync = ref.watch(allUsersForProjectsProvider);
    final AsyncValue<List<Map<String, Object>>> usersAsync =
        allUsersAsync.whenData((users) => users
            .map<Map<String, Object>>((u) => {
                  'id': int.tryParse(u.id) ?? -1,
                  'name': u.name,
                  'email': u.email,
                })
            .where((u) => (u['id'] as int) != -1)
            .toList());

    // Common Controllers
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final plannedHoursController = useTextEditingController();

    // Project Specific
    final projectLeadId = useState<int?>(null);
    final projectAssignees = useState<List<int>>([]);
    final projectDeadline = useState<DateTime?>(null);

    // Project Date Controllers
    final deadlineController = useTextEditingController(
      text: projectDeadline.value != null
          ? DateFormat('dd/MM/yyyy').format(projectDeadline.value!)
          : '',
    );
    useEffect(() {
      deadlineController.text = projectDeadline.value != null
          ? DateFormat('dd/MM/yyyy').format(projectDeadline.value!)
          : '';
      return null;
    }, [projectDeadline.value]);

    // Task Planning State
    final taskList = useState<List<_TempTask>>([]);
    final taskNameController = useTextEditingController();
    final taskPriority = useState<String>('MEDIUM');
    final taskStartDate = useState<DateTime?>(null);
    final taskEndDate = useState<DateTime?>(null);
    final taskAssignees = useState<List<int>>([]);
    final taskPlannedHoursController = useTextEditingController();
    final taskMilestones = useState<List<String>>([]);
    final milestoneController = useTextEditingController();

    // Task Date Controllers
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

    // EFFECT: Pre-fill data if in Edit Mode
    useEffect(() {
      if (projectToEdit != null) {
        final proj = projectToEdit!.project;
        nameController.text = proj.name;
        descriptionController.text = proj.context;
        plannedHoursController.text = proj.plannedHours.toString();
        projectLeadId.value = projectToEdit!.projectLeadId;
        projectAssignees.value =
            projectToEdit!.projectAssignees.map((a) => a['id'] as int).toList();
        projectDeadline.value = proj.dueDate;

        taskList.value = projectToEdit!.tasks.map((t) {
          List<String> milestoneNames = [];
          try {
            final List<dynamic> milJson = jsonDecode(t.task.milestonesJson);
            milestoneNames = milJson.map((m) => m['name'] as String).toList();
          } catch (_) {}

          return _TempTask(
            id: t.task.id,
            name: t.task.name,
            priority: t.task.priority.toUpperCase(),
            plannedHours: t.task.plannedHours,
            startDate: t.task.startDate,
            endDate: t.task.endDate,
            assignees: t.assignees.map((u) => int.tryParse(u.id) ?? 0).toList(),
            milestones: milestoneNames,
          );
        }).toList();
      }
      return null;
    }, [projectToEdit]);

    // Course/Routine Specific (not handled in edit mode for now)
    final instructorController = useTextEditingController();
    final scheduleController = useTextEditingController();
    final routineFrequency = useState<String>('Monthly');

    // Client Selection
    final selectedClientId = useState<int?>(null);
    final approvedClientsAsync = ref.watch(approvedClientsProvider);

    // New Client Creation
    final showNewClientForm = useState<bool>(false);
    final newClientNameController = useTextEditingController();
    final newClientCompanyController = useTextEditingController();
    final newClientPhoneController = useTextEditingController();
    final newClientEmailController = useTextEditingController();
    final isCreatingClient = useState<bool>(false);

    // Editing State for Tasks
    final editingTaskIndex = useState<int?>(null);
    final localError = useState<String?>(null);

    useEffect(() {
      if (localError.value != null) {
        final timer = Timer(const Duration(seconds: 4), () {
          localError.value = null;
        });
        return timer.cancel;
      }
      return null;
    }, [localError.value]);

    void goBack() {
      if (step.value == CreationStep.tasks) {
        step.value = CreationStep.details;
      } else if (step.value == CreationStep.details ||
          step.value == CreationStep.createClient) {
        step.value = CreationStep.type;
        selectedType.value = null;
      }
    }

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
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF05263E),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (step.value != CreationStep.type)
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Material(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: goBack,
                                      borderRadius: BorderRadius.circular(12),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.arrow_back_rounded,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      projectToEdit != null
                                          ? "Update Project"
                                          : "Create New Project",
                                      style: GoogleFonts.outfit(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                child: IconButton(
                                  icon: const Icon(Icons.close_rounded,
                                      color: Colors.white, size: 20),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _Breadcrumb(
                            currentStep: step.value,
                            isDark: isDark,
                            selectedType: selectedType.value,
                          ),
                        ],
                      ),
                    ),

                    // Body
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(isNarrow ? 16.0 : 24.0),
                        child: _buildBody(
                          context,
                          ref,
                          step.value,
                          isDark,
                          isNarrow, // New Parameter
                          selectedType.value,
                          (t) => selectedType.value = t,
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
                          usersAsync,
                          projectAssignees,
                          instructorController,
                          scheduleController,
                          routineFrequency,
                          goBack,
                          (state, {DateTime? maxDate, DateTime? minDate}) =>
                              pickDate(context, state,
                                  maxDate: maxDate, minDate: minDate),
                          () => step.value = CreationStep.tasks,
                          plannedHoursController,
                          () {
                            if (selectedType.value == WorkspaceType.client) {
                              step.value = CreationStep.createClient;
                            } else {
                              step.value = CreationStep.details;
                            }
                          },
                          editingTaskIndex,
                          (msg) => localError.value = msg,
                          selectedClientId,
                          approvedClientsAsync,
                          showNewClientForm,
                          newClientNameController,
                          newClientCompanyController,
                          newClientPhoneController,
                          newClientEmailController,
                          isCreatingClient,
                        ),
                      ),
                    ),
                  ],
                ),
                if (localError.value != null)
                  Positioned(
                    top: 12,
                    left: 20,
                    right: 20,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 350),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final clampedValue = value.clamp(0.0, 1.0);
                        return Transform.translate(
                          offset: Offset(0, -20 * (1 - clampedValue)),
                          child: Opacity(
                            opacity: clampedValue,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE11D48),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline_rounded,
                                      color: Colors.white, size: 20),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      localError.value!,
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded,
                                        color: Colors.white70, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => localError.value = null,
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
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CreationStep step,
    bool isDark,
    bool isNarrow,
    WorkspaceType? selectedType,
    Function(WorkspaceType) onSelectType,
    TextEditingController nameController,
    TextEditingController descriptionController,
    ValueNotifier<int?> projectLeadId,
    AsyncValue<List<Map<String, Object>>> usersAsync,
    ValueNotifier<DateTime?> projectDeadline,
    TextEditingController deadlineController,
    ValueNotifier<List<_TempTask>> taskList,
    TextEditingController taskNameController,
    ValueNotifier<String> taskPriority,
    ValueNotifier<DateTime?> taskStartDate,
    ValueNotifier<DateTime?> taskEndDate,
    TextEditingController taskStartController,
    TextEditingController taskEndController,
    ValueNotifier<List<int>> taskAssignees,
    TextEditingController taskPlannedHoursController,
    ValueNotifier<List<String>> taskMilestones,
    TextEditingController milestoneController,
    AsyncValue<List<Map<String, Object>>> backendUsersAsync,
    ValueNotifier<List<int>> projectAssignees,
    TextEditingController instructorController,
    TextEditingController scheduleController,
    ValueNotifier<String> routineFrequency,
    VoidCallback onBack,
    Function(ValueNotifier<DateTime?>, {DateTime? maxDate, DateTime? minDate})
        onPickDate,
    VoidCallback onStartPlanning,
    TextEditingController plannedHoursController,
    VoidCallback onContinue,
    ValueNotifier<int?> editingTaskIndex,
    Function(String) onError,
    ValueNotifier<int?> selectedClientId,
    AsyncValue<List<Map<String, dynamic>>> approvedClientsAsync,
    ValueNotifier<bool> showNewClientForm,
    TextEditingController newClientNameController,
    TextEditingController newClientCompanyController,
    TextEditingController newClientPhoneController,
    TextEditingController newClientEmailController,
    ValueNotifier<bool> isCreatingClient,
  ) {
    switch (step) {
      case CreationStep.type:
        return Column(
          children: [
            _SelectionCard(
              title: "New Project",
              description: "Software, Design, Marketing tasks with deadlines.",
              icon: Icons.developer_mode_rounded,
              type: WorkspaceType.project,
              isSelected: selectedType == WorkspaceType.project,
              isDark: isDark,
              onTap: () => onSelectType(WorkspaceType.project),
            ),
            const SizedBox(height: 16),
            /* _SelectionCard(
              title: "Class / Course",
              description: "Syllabus, Lessons, and Training Modules.",
              icon: Icons.school_rounded,
              type: WorkspaceType.course,
              isSelected: selectedType == WorkspaceType.course,
              isDark: isDark,
              onTap: () => onSelectType(WorkspaceType.course),
            ),
            const SizedBox(height: 16), */
            _SelectionCard(
              title: "Routine Work",
              description: "Weekly meeting, CRM, and daily admin.",
              icon: Icons.coffee_rounded,
              type: WorkspaceType.routine,
              isSelected: selectedType == WorkspaceType.routine,
              isDark: isDark,
              onTap: () => onSelectType(WorkspaceType.routine),
            ),
            const SizedBox(height: 16),
            _SelectionCard(
              title: "Create Client",
              description: "Add new client for projects and routines.",
              icon: Icons.person_add_rounded,
              type: WorkspaceType.client,
              isSelected: selectedType == WorkspaceType.client,
              isDark: isDark,
              onTap: () => onSelectType(WorkspaceType.client),
            ),
            const Spacer(),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.grey.shade50,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            fontSize: 15)),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: selectedType != null ? () => onContinue() : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF05263E),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor:
                          const Color(0xFF05263E).withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Continue",
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),
          ],
        );

      case CreationStep.details:
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Badge(
                    label: _getWorkspaceLabel(selectedType!), isDark: isDark),
                const SizedBox(height: 16),
                if (projectToEdit?.project.approvalStatus == 'REJECTED' &&
                    projectToEdit?.project.rejectionReason != null &&
                    projectToEdit!.project.rejectionReason!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFFCA5A5), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.gavel_rounded,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PROJECT REJECTION FEEDBACK',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF991B1B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                projectToEdit!.project.rejectionReason!,
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF7F1D1D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 1,
                                color: const Color(0xFFFCA5A5)
                                    .withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Please align with the feedback above and resubmit for approval.',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF991B1B)
                                      .withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                if (selectedType == WorkspaceType.project) ...[
                  _buildTextField(
                      nameController, "Project Name", "e.g. Q3 Marketing Plan"),
                  const SizedBox(height: 24),
                  _buildTextField(descriptionController, "Description / Goal",
                      "Brief description...",
                      maxLines: 4),
                  const SizedBox(height: 24),
                  _buildUserMultiSelect(
                      projectAssignees, usersAsync, "Project Assignees", isDark,
                      onRemove: (id) {
                    if (projectLeadId.value == id) projectLeadId.value = null;
                  }),
                  const SizedBox(height: 24),
                  _buildClientDropdown(
                      selectedClientId, approvedClientsAsync, "Client (Optional)", isDark),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                          child: _buildUserDropdown(projectLeadId, usersAsync,
                              projectAssignees, "Project Lead", isDark)),
                      const SizedBox(width: 24),
                      Expanded(
                          child: _buildTextField(
                              deadlineController, "Deadline *", "dd/MM/yyyy",
                              suffixIcon: Icons.calendar_today_rounded,
                              readOnly: true,
                              onTap: () => onPickDate(projectDeadline))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                      plannedHoursController, "Planned Hours", "e.g. 160",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                      ]),
                ] /* else if (selectedType == WorkspaceType.course) ...[
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
                  _buildTextField(descriptionController,
                      "Description / Syllabus Summary", "Brief overview...",
                      maxLines: 4),
                ] */
                else if (selectedType == WorkspaceType.routine) ...[
                  _buildTextField(
                      nameController, "Routine Name", "e.g. Daily Standup"),
                  const SizedBox(height: 24),
                  _buildClientDropdown(
                      selectedClientId, approvedClientsAsync, "Client (Optional)", isDark),
                  const SizedBox(height: 24),
                  _buildDropdown(
                      label: "Frequency",
                      value: routineFrequency.value,
                      items: ["Monthly"],
                      onChanged: (val) {
                        if (val != null) routineFrequency.value = val;
                      },
                      isDark: isDark),
                  const SizedBox(height: 24),
                  _buildTextField(descriptionController, "Description / Notes",
                      "Routine details...",
                      maxLines: 4),
                ],
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: onBack,
                        child: Text("BACK",
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade500,
                                letterSpacing: 1.2,
                                fontSize: 13))),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please enter a name")));
                          return;
                        }
                        if (selectedType == WorkspaceType.project) {
                          if (projectDeadline.value == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please select a deadline"),
                                    backgroundColor: Colors.red));
                            return;
                          }
                          onStartPlanning();
                        } else {
                          await _createWorkspace(
                              context,
                              ref,
                              selectedType,
                              nameController.text,
                              descriptionController.text,
                              instructorController.text,
                              scheduleController.text,
                              routineFrequency.value,
                              selectedClientId.value);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF05263E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                        shadowColor:
                            const Color(0xFF05263E).withValues(alpha: 0.3),
                      ),
                      child: Text(
                        selectedType == WorkspaceType.project
                            ? (projectToEdit != null
                                ? "CONTINUE TO PLAN"
                                : "START PLANNING")
                            : (projectToEdit != null
                                ? "UPDATE WORKSPACE"
                                : "CREATE WORKSPACE"),
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case CreationStep.tasks:
        final projectLimit =
            double.tryParse(plannedHoursController.text) ?? 0.0;
        final totalPlanned =
            taskList.value.fold<double>(0, (sum, t) => sum + t.plannedHours);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Task Planning",
                            style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF05263E),
                                letterSpacing: -0.5)),
                        const SizedBox(width: 16),
                        if (projectLimit > 0)
                          _BudgetBadge(
                              projectLimit: projectLimit,
                              totalPlanned: totalPlanned,
                              isDark: isDark),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("PROJECT: ${nameController.text.toUpperCase()}",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF3B82F6),
                          letterSpacing: 1.2,
                        )),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (taskList.value.isEmpty &&
                        taskNameController.text.isNotEmpty) {
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
                    }
                    if (taskList.value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Add at least one task")));
                      return;
                    }
                    if (projectToEdit != null) {
                      await _updateProjectWithTasks(
                          context,
                          ref,
                          projectToEdit!.project.id,
                          nameController.text,
                          descriptionController.text,
                          projectLeadId.value,
                          projectDeadline.value,
                          taskList.value,
                          projectAssignees.value,
                          projectLimit);
                    } else {
                      await _createProjectWithTasks(
                          context,
                          ref,
                          nameController.text,
                          descriptionController.text,
                          projectLeadId.value,
                          projectDeadline.value,
                          taskList.value,
                          projectAssignees.value,
                          projectLimit,
                          selectedClientId.value);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 6,
                    shadowColor: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                  icon: const Icon(Icons.verified_rounded, size: 20),
                  label: Text(
                    projectToEdit != null
                        ? "RESUBMIT FOR APPROVAL"
                        : "CREATE PROJECT",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800, letterSpacing: 0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: isNarrow
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
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
                              taskPlannedHoursController:
                                  taskPlannedHoursController,
                              taskMilestones: taskMilestones,
                              milestoneController: milestoneController,
                              backendUsersAsync: usersAsync,
                              projectAssignees: projectAssignees.value,
                              taskList: taskList,
                              onPickDate: onPickDate,
                              projectDeadline: projectDeadline.value,
                              projectPlannedHours: projectLimit,
                              editingTaskIndex: editingTaskIndex,
                              onError: onError),
                          const SizedBox(height: 24),
                          _buildTaskList(
                              isNarrow,
                              isDark,
                              usersAsync,
                              taskList,
                              editingTaskIndex,
                              taskNameController,
                              taskPriority,
                              taskStartDate,
                              taskEndDate,
                              taskStartController,
                              taskEndController,
                              taskAssignees,
                              taskPlannedHoursController,
                              taskMilestones),
                        ],
                      ),
                    )
                  : Row(
                      children: [
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
                                backendUsersAsync: usersAsync,
                                projectAssignees: projectAssignees.value,
                                taskList: taskList,
                                onPickDate: onPickDate,
                                projectDeadline: projectDeadline.value,
                                projectPlannedHours: projectLimit,
                                editingTaskIndex: editingTaskIndex,
                                onError: onError)),
                        const SizedBox(width: 32),
                        Expanded(
                            flex: 4,
                            child: _buildTaskList(
                                isNarrow,
                                isDark,
                                usersAsync,
                                taskList,
                                editingTaskIndex,
                                taskNameController,
                                taskPriority,
                                taskStartDate,
                                taskEndDate,
                                taskStartController,
                                taskEndController,
                                taskAssignees,
                                taskPlannedHoursController,
                                taskMilestones)),
                      ],
                    ),
            ),
          ],
        );

      case CreationStep.createClient:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Create New Client",
                    style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF05263E),
                        letterSpacing: -0.5)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                        newClientNameController, "Client Name", "e.g. Acme Corp"),
                    const SizedBox(height: 24),
                    _buildTextField(
                        newClientCompanyController, "Company Name", "e.g. XYZ Company"),
                    const SizedBox(height: 24),
                    _buildTextField(
                        newClientPhoneController, "Phone Number", "e.g. +1-555-0123",
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 24),
                    _buildTextField(
                        newClientEmailController, "Email", "e.g. contact@example.com",
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF05263E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    side: const BorderSide(
                        color: Color(0xFF05263E), width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    "BACK",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.8),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (newClientNameController.text.isEmpty ||
                        newClientCompanyController.text.isEmpty ||
                        newClientPhoneController.text.isEmpty ||
                        newClientEmailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please fill all fields"),
                          backgroundColor: Colors.orange));
                      return;
                    }
                    await _createClient(
                        context,
                        ref,
                        newClientNameController.text,
                        newClientCompanyController.text,
                        newClientPhoneController.text,
                        newClientEmailController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 6,
                    shadowColor:
                        const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                  child: Text(
                    "CREATE CLIENT",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.8),
                  ),
                ),
              ],
            ),
          ],
        );
    }
  }

  Widget _buildTaskList(
    bool isNarrow,
    bool isDark,
    AsyncValue<List<Map<String, Object>>> usersAsync,
    ValueNotifier<List<_TempTask>> taskList,
    ValueNotifier<int?> editingTaskIndex,
    TextEditingController taskNameController,
    ValueNotifier<String> taskPriority,
    ValueNotifier<DateTime?> taskStartDate,
    ValueNotifier<DateTime?> taskEndDate,
    TextEditingController taskStartController,
    TextEditingController taskEndController,
    ValueNotifier<List<int>> taskAssignees,
    TextEditingController taskPlannedHoursController,
    ValueNotifier<List<String>> taskMilestones,
  ) {
    const brandNavy = Color(0xFF05263E);
    const brandAccent = Color(0xFF7EC8F4);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: brandNavy.withValues(alpha: 0.15), width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 25,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Planned Tasks",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: isDark ? brandAccent : brandNavy,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: brandNavy.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: brandNavy.withValues(alpha: 0.1)),
                ),
                child: Text(
                  "${taskList.value.length} Tasks",
                  style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: brandNavy),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (isNarrow)
            taskList.value.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 48, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          "No tasks added yet",
                          style: GoogleFonts.outfit(
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: taskList.value.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = taskList.value[index];
                      final isEditing = editingTaskIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isEditing
                              ? brandNavy.withValues(alpha: 0.04)
                              : (isDark
                                  ? const Color(0xFF111827)
                                  : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isEditing
                                ? brandNavy
                                : (isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200),
                            width: isEditing ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.name,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: isDark ? Colors.white : brandNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      _TaskTag(
                                        label: "${task.plannedHours}h",
                                        color: Colors.blue,
                                      ),
                                      _TaskTag(
                                        label: task.priority,
                                        color: _getPriorityColor(task.priority),
                                      ),
                                      if (task.assignees.isNotEmpty)
                                        _TaskTag(
                                            label:
                                                "${task.assignees.length} Assigned",
                                            color: const Color(0xFF10B981)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit_rounded,
                                  size: 20,
                                  color: brandNavy.withValues(alpha: 0.6)),
                              onPressed: () {
                                editingTaskIndex.value = index;
                                taskNameController.text = task.name;
                                taskPriority.value =
                                    task.priority.toUpperCase();
                                taskPlannedHoursController.text =
                                    task.plannedHours.toString();
                                taskStartDate.value = task.startDate;
                                taskEndDate.value = task.endDate;
                                if (task.startDate != null) {
                                  taskStartController.text =
                                      DateFormat('dd/MM/yyyy')
                                          .format(task.startDate!);
                                }
                                if (task.endDate != null) {
                                  taskEndController.text =
                                      DateFormat('dd/MM/yyyy')
                                          .format(task.endDate!);
                                }
                                taskAssignees.value = List.from(task.assignees);
                                taskMilestones.value =
                                    List.from(task.milestones);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 20, color: Color(0xFFFB7185)),
                              onPressed: () {
                                if (editingTaskIndex.value == index) {
                                  editingTaskIndex.value = null;
                                  taskNameController.clear();
                                  taskPlannedHoursController.clear();
                                }
                                taskList.value = [...taskList.value]
                                  ..removeAt(index);
                                if (editingTaskIndex.value != null &&
                                    editingTaskIndex.value! > index) {
                                  editingTaskIndex.value =
                                      editingTaskIndex.value! - 1;
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
          else
            Expanded(
              child: taskList.value.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            "No tasks added yet",
                            style: GoogleFonts.outfit(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: taskList.value.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = taskList.value[index];
                        final isEditing = editingTaskIndex.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isEditing
                                ? brandNavy.withValues(alpha: 0.04)
                                : (isDark
                                    ? const Color(0xFF111827)
                                    : Colors.white),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isEditing
                                  ? brandNavy
                                  : (isDark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade200),
                              width: isEditing ? 1.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.name,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color:
                                            isDark ? Colors.white : brandNavy,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: [
                                        _TaskTag(
                                          label: "${task.plannedHours}h",
                                          color: Colors.blue,
                                        ),
                                        _TaskTag(
                                          label: task.priority,
                                          color:
                                              _getPriorityColor(task.priority),
                                        ),
                                        if (task.assignees.isNotEmpty)
                                          _TaskTag(
                                              label:
                                                  "${task.assignees.length} Assigned",
                                              color: const Color(0xFF10B981)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit_rounded,
                                    size: 20,
                                    color: brandNavy.withValues(alpha: 0.6)),
                                onPressed: () {
                                  editingTaskIndex.value = index;
                                  taskNameController.text = task.name;
                                  taskPriority.value =
                                      task.priority.toUpperCase();
                                  taskPlannedHoursController.text =
                                      task.plannedHours.toString();
                                  taskStartDate.value = task.startDate;
                                  taskEndDate.value = task.endDate;
                                  if (task.startDate != null) {
                                    taskStartController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(task.startDate!);
                                  }
                                  if (task.endDate != null) {
                                    taskEndController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(task.endDate!);
                                  }
                                  taskAssignees.value =
                                      List.from(task.assignees);
                                  taskMilestones.value =
                                      List.from(task.milestones);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded,
                                    size: 20, color: Color(0xFFFB7185)),
                                onPressed: () {
                                  if (editingTaskIndex.value == index) {
                                    editingTaskIndex.value = null;
                                    taskNameController.clear();
                                    taskPlannedHoursController.clear();
                                  }
                                  taskList.value = [...taskList.value]
                                    ..removeAt(index);
                                  if (editingTaskIndex.value != null &&
                                      editingTaskIndex.value! > index) {
                                    editingTaskIndex.value =
                                        editingTaskIndex.value! - 1;
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toUpperCase()) {
      case 'CRITICAL':
        return const Color(0xFFFB7185);
      case 'HIGH':
        return const Color(0xFFF59E0B);
      case 'MEDIUM':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF10B981);
    }
  }

  Future<void> _createWorkspace(
      BuildContext context,
      WidgetRef ref,
      WorkspaceType? type,
      String name,
      String desc,
      String instructor,
      String schedule,
      String? frequency,
      int? clientId) async {
    try {
      final apiService = ref.read(taskApiServiceProvider);
      String finalDescription = desc;
      if (type == WorkspaceType.course) {
        finalDescription =
            "Instructor: $instructor\nSchedule: $schedule\n\n$desc";
      } else if (type == WorkspaceType.routine) {
        finalDescription = "Frequency: $frequency\n\n$desc";
      }

      final catalogType = type == WorkspaceType.course ? 'COURSE' : 'ROUTINE';
      await apiService.createCatalogItem(
          name: name,
          description: finalDescription,
          catalogType: catalogType,
          isActive: true,
          clientId: clientId);
      ref.invalidate(apiCatalogProvider);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
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
      int? clientId) async {
    try {
      final apiService = ref.read(taskApiServiceProvider);
      final tasksPayload = tasks
          .map((t) => {
                'title': t.name,
                'priority': t.priority,
                if (t.startDate != null)
                  'start_date': DateFormat('yyyy-MM-dd').format(t.startDate!),
                if (t.endDate != null)
                  'due_date': DateFormat('yyyy-MM-dd').format(t.endDate!),
                'assignees': t.assignees,
                'planned_hours': t.plannedHours,
                'milestones': t.milestones.map((m) => {'title': m}).toList(),
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
          clientId: clientId);

      ref.invalidate(apiProjectsProvider);
      ref.invalidate(apiTasksProvider);
      ref.invalidate(projectsWithTasksProvider);
      ref.invalidate(paginatedDashboardProjectsProvider);
      ref.invalidate(projectsPageProjectsProvider);
      ref.invalidate(currentProjectProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Project created successfully"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      String errorMsg = e.toString();
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          errorMsg =
              data.entries.map((ent) => "${ent.key}: ${ent.value}").join("\n");
        } else if (data != null) {
          errorMsg = data.toString();
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: $errorMsg"), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _updateProjectWithTasks(
      BuildContext context,
      WidgetRef ref,
      String projectId,
      String name,
      String desc,
      int? leadId,
      DateTime? deadline,
      List<_TempTask> tasks,
      List<int> assignees,
      double plannedHours) async {
    try {
      final apiService = ref.read(taskApiServiceProvider);
      final projectData = {
        'name': name,
        'description': desc,
        'project_lead': leadId,
        if (deadline != null)
          'deadline': DateFormat('yyyy-MM-dd').format(deadline),
        'assignees': assignees,
        'planned_hours': plannedHours,
        'approval_status': 'PENDING', // Force pending status on resubmit
        'is_approved': false,
      };

      final intProjId =
          int.tryParse(projectId.replaceFirst('api_project_', '')) ?? 0;
      await apiService.updateProject(intProjId, projectData);

      final originalTaskIds =
          projectToEdit?.tasks.map((t) => t.task.id).toSet() ?? {};
      final currentTaskIds =
          tasks.where((t) => t.id != null).map((t) => t.id!).toSet();
      final tasksToDelete = originalTaskIds.difference(currentTaskIds);

      for (final tid in tasksToDelete) {
        final tidString = tid.toString();
        final intTid = int.tryParse(tidString
                .replaceFirst('api_project_task_', '')
                .replaceFirst('api_task_', '')) ??
            0;
        if (intTid > 0) await apiService.deleteTask(intTid);
      }

      for (final t in tasks) {
        final taskPayload = {
          'title': t.name,
          'priority': t.priority,
          if (t.startDate != null)
            'start_date': DateFormat('yyyy-MM-dd').format(t.startDate!),
          if (t.endDate != null)
            'due_date': DateFormat('yyyy-MM-dd').format(t.endDate!),
          'assignees': t.assignees,
          'planned_hours': t.plannedHours,
          'milestones': t.milestones.map((m) => {'title': m}).toList(),
          'approval_status': 'PENDING',
        };

        if (t.id != null) {
          final intTid =
              int.tryParse(t.id!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          await apiService.updateTask(intTid, taskPayload);
        } else {
          await apiService.createTask(intProjId, taskPayload);
        }
      }

      ref.invalidate(apiProjectsProvider);
      ref.invalidate(apiTasksProvider);
      ref.invalidate(projectsWithTasksProvider);
      ref.invalidate(paginatedDashboardProjectsProvider);
      ref.invalidate(projectsPageProjectsProvider);
      ref.invalidate(currentProjectProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Project updated successfully"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      String errorMsg = e.toString();
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          errorMsg =
              data.entries.map((ent) => "${ent.key}: ${ent.value}").join("\n");
        } else if (data != null) {
          errorMsg = data.toString();
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error: $errorMsg"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _createClient(
      BuildContext context,
      WidgetRef ref,
      String clientName,
      String companyName,
      String phoneNumber,
      String email) async {
    try {
      final apiService = ref.read(taskApiServiceProvider);
      await apiService.createClient(
          clientName: clientName,
          companyName: companyName,
          phoneNumber: phoneNumber,
          email: email);

      ref.invalidate(approvedClientsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Client created successfully"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      String errorMsg = e.toString();
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          errorMsg =
              data.entries.map((ent) => "${ent.key}: ${ent.value}").join("\n");
        } else if (data != null) {
          errorMsg = data.toString();
        }
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: $errorMsg"), backgroundColor: Colors.red));
      }
    }
  }

  Widget _buildUserDropdown(
      ValueNotifier<int?> selectedUserId,
      AsyncValue<List<Map<String, Object>>> usersAsync,
      ValueNotifier<List<int>> allowedIds,
      String label,
      bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            color: const Color(0xFF05263E),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        usersAsync.when(
          loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, __) => const Text("Error"),
          data: (users) {
            final filteredUsers =
                users.where((u) => allowedIds.value.contains(u['id'])).toList();
            if (filteredUsers.isEmpty) {
              return Text("Select Assignees first",
                  style: GoogleFonts.outfit(
                      color: Colors.grey,
                      fontSize: 13,
                      fontStyle: FontStyle.italic));
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: filteredUsers.map((user) {
                final userId = user['id'] as int;
                final isSelected = selectedUserId.value == userId;
                return InkWell(
                  onTap: () => selectedUserId.value = userId,
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF05263E).withValues(alpha: 0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF05263E)
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor:
                              UserColorService.getColorForUser(userId),
                          child: Text(
                            ((user['name'] as String?) ?? 'U')[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text((user['name'] as String?) ?? 'User',
                            style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: isSelected
                                    ? const Color(0xFF05263E)
                                    : Colors.grey.shade600)),
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
      AsyncValue<List<Map<String, Object>>> usersAsync,
      String label,
      bool isDark,
      {Function(int)? onRemove}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            color: const Color(0xFF05263E),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        usersAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text("Error"),
          data: (users) {
            final availableUsers = users
                .where((u) => !selectedIds.value.contains(u['id']))
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int>(
                  key: ValueKey('project_assignee_${selectedIds.value.length}'),
                  initialValue: null,
                  style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Add Assignee",
                    hintStyle: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.grey.shade200, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFF05263E), width: 2),
                    ),
                  ),
                  items: availableUsers
                      .map((u) => DropdownMenuItem<int>(
                          value: u['id'] as int,
                          child: Text((u['name'] as String?) ?? 'User',
                              style: GoogleFonts.outfit())))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      selectedIds.value = [...selectedIds.value, val];
                    }
                  },
                ),
                const SizedBox(height: 12),
                if (selectedIds.value.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedIds.value.map((id) {
                      final user = users.firstWhere((u) => u['id'] == id,
                          orElse: () => <String, Object>{});
                      return Chip(
                        backgroundColor:
                            const Color(0xFF05263E).withValues(alpha: 0.05),
                        side: BorderSide(
                            color:
                                const Color(0xFF05263E).withValues(alpha: 0.1)),
                        label: Text((user['name'] as String?) ?? 'User',
                            style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF05263E))),
                        onDeleted: () {
                          selectedIds.value =
                              selectedIds.value.where((x) => x != id).toList();
                          onRemove?.call(id);
                        },
                        deleteIconColor: const Color(0xFF05263E),
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
        return "New Project";
      case WorkspaceType.course:
        return "Class / Course";
      case WorkspaceType.routine:
        return "Routine Work";
      case WorkspaceType.client:
        return "Create Client";
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
  final ValueNotifier<List<int>> taskAssignees;
  final TextEditingController taskPlannedHoursController;
  final ValueNotifier<List<String>> taskMilestones;
  final TextEditingController milestoneController;
  final AsyncValue<List<Map<String, Object>>> backendUsersAsync;
  final List<int> projectAssignees;
  final ValueNotifier<List<_TempTask>> taskList;
  final Function(ValueNotifier<DateTime?>,
      {DateTime? maxDate, DateTime? minDate}) onPickDate;
  final DateTime? projectDeadline;
  final double projectPlannedHours;
  final ValueNotifier<int?> editingTaskIndex;
  final Function(String) onError;

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
    required this.editingTaskIndex,
    required this.onError,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const brandNavy = Color(0xFF05263E);
    const brandAccent = Color(0xFF7EC8F4);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(taskNameController, "Task Name", "e.g. Setup Repo"),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        taskPlannedHoursController, "Hours", "e.g. 8",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ])),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildPriorityDropdown(
                        taskPriority, isDark, brandNavy)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        taskStartController, "Start Date", "dd/MM/yyyy",
                        readOnly: true,
                        suffixIcon: Icons.calendar_today_rounded,
                        onTap: () => onPickDate(taskStartDate,
                            maxDate: projectDeadline))),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildTextField(
                        taskEndController, "Due Date", "dd/MM/yyyy",
                        readOnly: true,
                        suffixIcon: Icons.event_rounded,
                        onTap: () => onPickDate(taskEndDate,
                            maxDate: projectDeadline,
                            minDate: taskStartDate.value))),
              ],
            ),
            const SizedBox(height: 24),
            Text("ASSIGN TO",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: brandNavy,
                  letterSpacing: 0.8,
                )),
            const SizedBox(height: 12),
            backendUsersAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, __) => Text("Error: $e",
                  style: const TextStyle(color: Colors.red, fontSize: 11)),
              data: (users) {
                final teamMembers = users
                    .where((u) => projectAssignees.contains(u['id']))
                    .toList();
                final availableForTask = teamMembers
                    .where((u) => !taskAssignees.value.contains(u['id']))
                    .toList();
                if (teamMembers.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                        "Select Project members in 'Details' step first.",
                        style: GoogleFonts.outfit(
                            color: Colors.orange.shade700,
                            fontSize: 12,
                            fontStyle: FontStyle.italic)),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (availableForTask.isNotEmpty)
                      DropdownButtonFormField<int>(
                        key: ValueKey(
                            'task_assignee_${taskAssignees.value.length}'),
                        style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Add Team Member",
                          hintStyle: GoogleFonts.outfit(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                              fontStyle: FontStyle.italic),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: brandNavy, width: 2),
                          ),
                        ),
                        items: availableForTask
                            .map((u) => DropdownMenuItem<int>(
                                value: u['id'] as int,
                                child: Text((u['name'] as String?) ?? 'User',
                                    style: GoogleFonts.outfit())))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            taskAssignees.value = [...taskAssignees.value, val];
                          }
                        },
                      ),
                    const SizedBox(height: 12),
                    if (taskAssignees.value.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: taskAssignees.value.map((id) {
                          final user = users.firstWhere((u) => u['id'] == id,
                              orElse: () => <String, Object>{});
                          return Chip(
                            backgroundColor: brandNavy.withValues(alpha: 0.05),
                            side: BorderSide(
                                color: brandNavy.withValues(alpha: 0.1)),
                            label: Text((user['name'] as String?) ?? 'User',
                                style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: brandNavy)),
                            onDeleted: () {
                              taskAssignees.value = taskAssignees.value
                                  .where((x) => x != id)
                                  .toList();
                            },
                            deleteIconColor: brandNavy,
                          );
                        }).toList(),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text("MILESTONES",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: brandNavy,
                  letterSpacing: 0.8,
                )),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    milestoneController,
                    "",
                    "e.g. Design Approved",
                    onSubmitted: () {
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
                const SizedBox(width: 8),
                Material(
                  color: brandNavy,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      if (milestoneController.text.isNotEmpty) {
                        taskMilestones.value = [
                          ...taskMilestones.value,
                          milestoneController.text
                        ];
                        milestoneController.clear();
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.add_rounded,
                          color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            ),
            if (taskMilestones.value.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: taskMilestones.value
                    .map((m) => Chip(
                          backgroundColor: brandAccent.withValues(alpha: 0.1),
                          side: BorderSide(
                              color: brandAccent.withValues(alpha: 0.2)),
                          label: Text(m,
                              style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: brandNavy)),
                          onDeleted: () {
                            taskMilestones.value = taskMilestones.value
                                .where((x) => x != m)
                                .toList();
                          },
                          deleteIconColor: brandNavy,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (taskNameController.text.isEmpty) {
                    onError(
                        "TASK NAME REQUIRED: Please enter a name for this task.");
                    return;
                  }

                  if (taskAssignees.value.isEmpty) {
                    onError(
                        "RECIPIENT REQUIRED: Please assign at least one team member to this task.");
                    return;
                  }

                  final taskHours =
                      double.tryParse(taskPlannedHoursController.text) ?? 0.0;

                  double otherTasksHours = 0;
                  for (int i = 0; i < taskList.value.length; i++) {
                    if (editingTaskIndex.value != i) {
                      otherTasksHours += taskList.value[i].plannedHours;
                    }
                  }

                  if ((otherTasksHours + taskHours) > projectPlannedHours &&
                      projectPlannedHours > 0) {
                    onError(
                        "OVER BUDGET: Total planned hours (${otherTasksHours + taskHours}h) would exceed project budget (${projectPlannedHours}h).");
                    return;
                  }

                  final task = _TempTask(
                    id: editingTaskIndex.value != null
                        ? taskList.value[editingTaskIndex.value!].id
                        : null,
                    name: taskNameController.text,
                    priority: taskPriority.value,
                    plannedHours: taskHours,
                    startDate: taskStartDate.value,
                    endDate: taskEndDate.value,
                    assignees: List.from(taskAssignees.value),
                    milestones: List.from(taskMilestones.value),
                  );

                  if (editingTaskIndex.value != null) {
                    final list = [...taskList.value];
                    list[editingTaskIndex.value!] = task;
                    taskList.value = list;
                    editingTaskIndex.value = null;
                  } else {
                    taskList.value = [...taskList.value, task];
                  }

                  taskNameController.clear();
                  taskPlannedHoursController.clear();
                  taskStartController.clear();
                  taskEndController.clear();
                  taskPriority.value = 'MEDIUM';
                  taskStartDate.value = null;
                  taskEndDate.value = null;
                  taskAssignees.value = [];
                  taskMilestones.value = [];
                  milestoneController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandNavy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 4,
                  shadowColor: brandNavy.withValues(alpha: 0.3),
                ),
                icon: Icon(
                    editingTaskIndex.value != null
                        ? Icons.save_rounded
                        : Icons.add_task_rounded,
                    size: 20),
                label: Text(
                    editingTaskIndex.value != null
                        ? "UPDATE TASK"
                        : "ADD TO PROJECT PLAN",
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800, letterSpacing: 1.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final CreationStep currentStep;
  final bool isDark;
  final WorkspaceType? selectedType;
  const _Breadcrumb(
      {required this.currentStep,
      required this.isDark,
      required this.selectedType});

  @override
  Widget build(BuildContext context) {
    final steps = [
      _step("TYPE", CreationStep.type),
      if (selectedType == WorkspaceType.client)
        _step("CLIENT", CreationStep.createClient)
      else
        _step("DETAILS", CreationStep.details),
      if (selectedType == WorkspaceType.project)
        _step("TASKS", CreationStep.tasks),
    ];

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          steps[i],
          if (i < steps.length - 1)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getColor(CreationStep.values[i]),
                      _getColor(CreationStep.values[i + 1]),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Color _getColor(CreationStep step) {
    if (step == currentStep) return const Color(0xFF7EC8F4);
    if (step.index < currentStep.index) return Colors.white;
    return Colors.white.withValues(alpha: 0.3);
  }

  Widget _step(String label, CreationStep step) {
    final isActive = step == currentStep;
    final isPast = step.index < currentStep.index;
    final color = _getColor(step);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isActive ? color : (isPast ? Colors.white : Colors.transparent),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: isPast
              ? const Icon(Icons.check_rounded,
                  size: 14, color: Color(0xFF05263E))
              : Text(
                  "${step.index + 1}",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive ? const Color(0xFF05263E) : color,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
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
  const _SelectionCard(
      {required this.title,
      required this.description,
      required this.icon,
      required this.type,
      required this.isSelected,
      required this.isDark,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    const brandNavy = Color(0xFF05263E);
    final color = type == WorkspaceType.project
        ? const Color(0xFF3B82F6)
        : (type == WorkspaceType.course
            ? const Color(0xFF10B981)
            : const Color(0xFF8B5CF6));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.08)
              : (isDark ? const Color(0xFF1F2937) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: color.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: isSelected ? Colors.white : color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: isDark ? Colors.white : brandNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 24),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool isDark;
  const _Badge({required this.label, required this.isDark});
  @override
  Widget build(BuildContext context) {
    const brandNavy = Color(0xFF05263E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: brandNavy,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: brandNavy.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _BudgetBadge extends StatelessWidget {
  final double projectLimit;
  final double totalPlanned;
  final bool isDark;
  const _BudgetBadge(
      {required this.projectLimit,
      required this.totalPlanned,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    const brandNavy = Color(0xFF05263E);
    final remaining = projectLimit - totalPlanned;
    final isOver = totalPlanned > projectLimit;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: (isOver ? const Color(0xFFFB7185) : const Color(0xFF10B981))
                .withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    (isOver ? const Color(0xFFFB7185) : const Color(0xFF10B981))
                        .withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  isOver
                      ? Icons.warning_amber_rounded
                      : Icons.account_balance_wallet_rounded,
                  size: 14,
                  color: isOver
                      ? const Color(0xFFFB7185)
                      : const Color(0xFF10B981)),
              const SizedBox(width: 8),
              Text(
                "Budget: ${projectLimit.toStringAsFixed(0)}h | Planned: ${totalPlanned.toStringAsFixed(0)}h",
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isOver
                        ? const Color(0xFFFB7185)
                        : (isDark ? const Color(0xFF10B981) : brandNavy)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: (isOver ? const Color(0xFFFB7185) : const Color(0xFFF59E0B))
                .withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    (isOver ? const Color(0xFFFB7185) : const Color(0xFFF59E0B))
                        .withValues(alpha: 0.2)),
          ),
          child: Text(
            isOver
                ? "Exceeded: ${(-remaining).toStringAsFixed(0)}h"
                : "Remaining: ${remaining.toStringAsFixed(0)}h",
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isOver
                  ? const Color(0xFFFB7185)
                  : (isDark
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFFB45309)),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskTag extends StatelessWidget {
  final String label;
  final Color color;
  const _TaskTag({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.5),
      ),
    );
  }
}

Widget _buildPriorityDropdown(
    ValueNotifier<String> priority, bool isDark, Color brandNavy) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "PRIORITY",
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          color: brandNavy,
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        initialValue: priority.value,
        items: const [
          DropdownMenuItem(value: 'LOW', child: Text('Low')),
          DropdownMenuItem(value: 'MEDIUM', child: Text('Medium')),
          DropdownMenuItem(value: 'HIGH', child: Text('High')),
          DropdownMenuItem(value: 'CRITICAL', child: Text('Critical')),
        ],
        onChanged: (val) => priority.value = val!,
        style: GoogleFonts.outfit(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: brandNavy, width: 2),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTextField(
    TextEditingController controller, String label, String hint,
    {int maxLines = 1,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onSubmitted}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label.isNotEmpty) ...[
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            color: const Color(0xFF05263E),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
      ],
      TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontStyle: FontStyle.italic),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF05263E), width: 2),
          ),
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, size: 18, color: const Color(0xFF05263E))
              : null,
        ),
      ),
    ],
  );
}

Widget _buildDropdown(
    {required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isDark}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          color: const Color(0xFF05263E),
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        initialValue: value,
        items: items
            .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s, style: GoogleFonts.outfit(fontSize: 14))))
            .toList(),
        onChanged: onChanged,
        style: GoogleFonts.outfit(
            fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF05263E), width: 2),
          ),
        ),
      ),
    ],
  );
}

Widget _buildClientDropdown(
    ValueNotifier<int?> selectedClientId,
    AsyncValue<List<Map<String, dynamic>>> clientsAsync,
    String label,
    bool isDark) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          color: const Color(0xFF05263E),
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        height: 56,
        child: clientsAsync.when(
          loading: () => const Center(
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))),
          error: (_, __) => const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("Error loading clients"),
          ),
          data: (clients) {
            if (clients.isEmpty) {
              return DropdownButtonFormField<int?>(
                initialValue: null,
                items: const [],
                onChanged: null,
                style: GoogleFonts.outfit(
                    fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "No approved clients available",
                  hintStyle: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                      fontStyle: FontStyle.italic),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF05263E), width: 2),
                  ),
                ),
              );
            }
            return DropdownButtonFormField<int?>(
              initialValue: selectedClientId.value,
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text("Select a client", style: TextStyle(fontStyle: FontStyle.italic)),
                ),
                ...clients.map((client) {
                  final id = client['id'] as int;
                  final name = (client['client_name'] ?? client['name'] ?? 'Unknown') as String;
                  return DropdownMenuItem<int?>(
                    value: id,
                    child: Text(name, style: GoogleFonts.outfit(fontSize: 14)),
                  );
                })
              ],
              onChanged: (value) {
                selectedClientId.value = value;
              },
              style: GoogleFonts.outfit(
                  fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF05263E), width: 2),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
