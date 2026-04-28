import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:project_pm/src/features/today/widgets/task_config_modal.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';
import 'package:project_pm/src/features/today/today_providers.dart';
import 'package:project_pm/src/features/settings/planner_settings_provider.dart';
import 'package:project_pm/src/features/today/today_repository.dart';
import 'review_task_dialog.dart';

class DayPlanner extends HookConsumerWidget {
  const DayPlanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final isQuadrantView = ref.watch(plannerSettingsProvider);

    // Animation controller for the global pulse and scan effects
    final pulseController = useAnimationController(
      duration: 3.seconds,
    )..repeat(reverse: true);
    // Pending Box Visibility State
    final isPendingBoxVisible = useState(true);

    // Watch API today plan data
    final apiTodayPlanAsync = ref.watch(apiTodayPlanProvider);

    // Calculate total duration strings
    String formatDuration(int totalMinutes) {
      final hours = totalMinutes ~/ 60;
      final minutes = totalMinutes % 60;
      return '${hours}hr ${minutes}min';
    }

    // Display Date logic
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    // Check if day is finalized: if there is an active session for the selected date
    final activeSessionAsync =
        ref.watch(apiActiveSessionProvider(selectedDateStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final now = DateTime.now();
    bool isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    useEffect(() {
      debugPrint(
          'DayPlanner: isToday=$isToday, isFinalized=$isFinalized, date=$selectedDateStr');
      if (isFinalized) {
        debugPrint('DayPlanner: Session detected for $selectedDateStr');
      }
      return null;
    }, [isToday, isFinalized, selectedDateStr]);

    String dateHeader;
    if (isToday) {
      dateHeader = "Today's Plan";
    } else {
      dateHeader = "Plan for ${const [
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
      ][selectedDate.month - 1]} ${selectedDate.day}";
    }

    final horizontalPadding =
        MediaQuery.of(context).size.width < 600 ? 12.0 : 24.0;

    const sidebarBlue = Color(0xFF05263E);

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateHeader,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 0.3,
                      color: isDark ? Colors.white : sidebarBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  apiTodayPlanAsync.when(
                    data: (apiItems) {
                      final apiTotal = apiItems.fold<int>(
                          0,
                          (sum, item) =>
                              sum +
                              (item['planned_duration_minutes'] as int? ?? 0));
                      return Text(
                        "Total Hours : ${formatDuration(apiTotal)}",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? const Color(0xFFFBBF24)
                              : const Color(0xFFF97316),
                        ),
                      );
                    },
                    loading: () => Text(
                      "Total Hours : --",
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFFFBBF24)
                              : const Color(0xFFF97316),
                          fontWeight: FontWeight.w600),
                    ),
                    error: (_, __) => Text(
                      "Total Hours : --",
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFFFBBF24)
                              : const Color(0xFFF97316),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Add Task Button (Blue)
                  _FeatureButton(
                    label: 'Add Task',
                    icon: Icons.add_rounded,
                    backgroundColor: const Color(0xFFDBEAFE),
                    foregroundColor: const Color(0xFF1D4ED8),
                    onPressed: (isFinalized || isReadOnly)
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => TaskConfigModal(
                                showQuadrantSelector: true,
                                onConfirm: ({
                                  required String name,
                                  required int duration,
                                  String? description,
                                  List<String>? selectedMilestoneIds,
                                  String? quadrant,
                                }) async {
                                  try {
                                    final apiService =
                                        ref.read(taskApiServiceProvider);
                                    final userId =
                                        ref.read(currentUserIdProvider);
                                    await apiService.addItemToTodayPlan(
                                      itemType: 'custom',
                                      title: name,
                                      planDate: selectedDateStr,
                                      description: description,
                                      plannedDurationMinutes: duration,
                                      quadrant: quadrant ?? 'Q1',
                                      userId: userId,
                                    );
                                    ref.invalidate(apiTodayPlanProvider);
                                    ref.invalidate(apiPendingItemsProvider(
                                        selectedDateStr));
                                  } catch (e) {
                                    debugPrint('Error adding custom task: $e');
                                  }
                                },
                              ),
                            );
                          },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quadrants Stack
          Expanded(
            child: apiTodayPlanAsync.when(
              data: (apiPlanItems) => isQuadrantView
                  ? _buildQuadrantList(
                      context, apiPlanItems, isFinalized, pulseController.value)
                  : _ApiListView(
                      apiItems: apiPlanItems, isFinalized: isFinalized),
              loading: () => isQuadrantView 
                  ? _buildQuadrantList(context, [], isFinalized, pulseController.value)
                  : const Center(child: CircularProgressIndicator()),
              error: (_, __) => isQuadrantView
                  ? _buildQuadrantList(context, [], isFinalized, pulseController.value)
                  : const Center(child: Text("Error loading plan")),
            ),
          ),

          const SizedBox(height: 8),

          // Fixed Pending Box with Overflow Protection
          if (ref.watch(apiPendingItemsProvider(selectedDateStr)).maybeWhen(
              data: (items) => items.isNotEmpty, orElse: () => false)) ...[
            if (isPendingBoxVisible.value)
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.18, // Reduced height (18% of screen)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pending Tasks",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: 0.1,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isPendingBoxVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              isPendingBoxVisible.value =
                                  !isPendingBoxVisible.value;
                            },
                          ),
                        ],
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: _PendingBox(
                            pendingAsync: ref.watch(
                                apiPendingItemsProvider(selectedDateStr)),
                            onDrop: (data) async {
                              if (isFinalized) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Day Plan has started. Planning interactions are locked."),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              if (data is! Map<String, dynamic>) return;

                              // Case 1: Existing TodayPlan item (move to inbox)
                              if (data.containsKey('id') &&
                                  !data.containsKey('type')) {
                                try {
                                  final apiService =
                                      ref.read(taskApiServiceProvider);
                                  await apiService.updateTodayPlanItem(
                                      data['id'], {
                                    'quadrant': 'inbox',
                                    'status': 'PENDING'
                                  });
                                  ref.invalidate(apiTodayPlanProvider);
                                  ref.invalidate(
                                      apiPendingItemsProvider(selectedDateStr));
                                } catch (e) {
                                  debugPrint('Error moving to pending: $e');
                                }
                              }
                              // Case 2: Catalog Item or Project Task (add with quadrant)
                              else if (data.containsKey('type')) {
                                showDialog(
                                  context: context,
                                  builder: (context) => TaskConfigModal(
                                    initialTitle: data['name'],
                                    initialDescription: data['description'],
                                    initialDuration:
                                        ((data['duration'] as num?)?.toInt() ??
                                                60)
                                            .clamp(15, 120),
                                    showQuadrantSelector: true,
                                    onConfirm: ({
                                      required String name,
                                      required int duration,
                                      String? description,
                                      List<String>? selectedMilestoneIds,
                                      String? quadrant,
                                    }) async {
                                      try {
                                        final apiService =
                                            ref.read(taskApiServiceProvider);
                                        final userId =
                                            ref.read(currentUserIdProvider);
                                        final planDate = selectedDateStr;

                                        if (data['type'] == 'catalog_item' &&
                                            data['catalog_id'] != null) {
                                          await apiService.addItemToTodayPlan(
                                            itemType: 'catalog',
                                            catalogId:
                                                parseTaskId(data['catalog_id']),
                                            planDate: planDate,
                                            plannedDurationMinutes: duration,
                                            description: description,
                                            quadrant: quadrant ?? 'Q1',
                                            userId: userId,
                                          );
                                        } else {
                                          await apiService.addItemToTodayPlan(
                                            itemType: 'custom',
                                            title: name,
                                            planDate: planDate,
                                            description: description,
                                            plannedDurationMinutes: duration,
                                            quadrant: quadrant ?? 'Q1',
                                            relatedTaskId: data['task_id'] !=
                                                    null
                                                ? parseTaskId(data['task_id'])
                                                : null,
                                            userId: userId,
                                          );
                                        }

                                        if (data['is_pending'] == true &&
                                            data['pending_id'] != null) {
                                          await apiService.deletePendingTask(
                                              data['pending_id']);
                                          ref.invalidate(
                                              apiAllPendingItemsProvider);
                                        }

                                        ref.invalidate(apiTodayPlanProvider);
                                        ref.invalidate(apiPendingItemsProvider(
                                            selectedDateStr));
                                      } catch (e) {
                                        debugPrint('Error adding to plan: $e');
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                            selectedDateStr: selectedDateStr,
                            isFinalized: isFinalized,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Header still visible when collapsed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pending Tasks",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: 0.1,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility_off, color: Colors.grey),
                    onPressed: () => isPendingBoxVisible.value = true,
                  ),
                ],
              ),
          ],

          const SizedBox(height: 8),

          if (isToday)
            Center(
              child: isFinalized
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.green.withValues(alpha: 0.15)
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 18,
                              color: isDark ? Colors.greenAccent : Colors.green),
                          const SizedBox(width: 10),
                          Text(
                            'Day Plan has started!',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.greenAccent
                                  : Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      // width: double.infinity, // Removed for smarter content-based sizing
                      child: ElevatedButton.icon(
                        onPressed: isReadOnly
                            ? null
                            : () async {
                                try {
                                  final apiService =
                                      ref.read(taskApiServiceProvider);
                                  await apiService.startDay();
                                  ref.invalidate(apiActiveSessionProvider(
                                      selectedDateStr));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Day Plan Locked! Let's get to work!"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Failed to start day: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        icon: const Icon(Icons.play_arrow_rounded, size: 24),
                        label: Text(
                          'START DAY PLAN',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF166534),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuadrantList(
    BuildContext context,
    List<Map<String, dynamic>> apiItems,
    bool isFinalized,
    double pulse,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width allows, we do 2 columns (2x2 grid), else 1 column
        const double spacing = 16.0;
        final bool isWide = constraints.maxWidth > 600;

        Widget buildBox(String q, String title, Color color) {
          return _QuadrantBox(
            quadrant: q,
            title: title,
            color: color,
            apiItems: apiItems
                .where((i) => i['quadrant']?.toString().toUpperCase() == q)
                .toList(),
            isFinalized: isFinalized,
            pulse: pulse,
          );
        }

        final q1 = buildBox('Q1', 'Q1 DO FIRST (Urgent & Important)', const Color(0xFFEF4444));
        final q2 = buildBox('Q2', 'Q2 SCHEDULE (Important, Not Urgent)', const Color(0xFFF97316));
        final q3 = buildBox('Q3', 'Q3 DELEGATE (Urgent, Not Important)', const Color(0xFFA855F7));
        final q4 = buildBox('Q4', 'Q4 ELIMINATE (Neither)', Colors.teal);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: isWide
                ? Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: q1),
                          const SizedBox(width: spacing),
                          Expanded(child: q2),
                        ],
                      ),
                      const SizedBox(height: spacing),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: q3),
                          const SizedBox(width: spacing),
                          Expanded(child: q4),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      q1,
                      const SizedBox(height: spacing),
                      q2,
                      const SizedBox(height: spacing),
                      q3,
                      const SizedBox(height: spacing),
                      q4,
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _ApiListView extends HookConsumerWidget {
  final List<Map<String, dynamic>> apiItems;
  final bool isFinalized;

  const _ApiListView({
    required this.apiItems,
    required this.isFinalized,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Optimistic local state for reordering
    final localItems = useState<List<Map<String, dynamic>>>(apiItems);

    // Sync local state only when the SET of IDs changes (not order).
    // This prevents mid-drag rebuilds that cause the assertion:
    // "_elements.contains(element) is not true".
    useEffect(() {
      final localIds = localItems.value.map((e) => e['id'].toString()).toSet();
      final serverIds = apiItems.map((e) => e['id'].toString()).toSet();
      final bool idSetChanged = localIds.length != serverIds.length ||
                               !localIds.containsAll(serverIds);
      if (idSetChanged) {
        localItems.value = apiItems;
      }
      return null;
    }, [apiItems]);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        if (isReadOnly) return false;
        return details.data is Map<String, dynamic>;
      },
      onAcceptWithDetails: (details) async {
        if (details.data is! Map<String, dynamic>) return;
        final data = details.data as Map<String, dynamic>;

        // Restriction: If day is started, notify user to use Activity Log for unplanned tasks
        // Exception: Allow reordering existing today_plan items
        if (isFinalized && data['source'] != 'today_plan') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Day has been started. For unplanned tasks, please drag them directly to the Activity Log.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }



        if (data.containsKey('type')) {
          // ── Special case: pending_item dragged to Today's Plan list ──
          if (data['type'] == 'pending_item') {
            if (data['is_today_inbox'] == true) {
              // Already a TodayPlan record (today's inbox) — ask quadrant then promote
              showDialog(
                context: context,
                builder: (ctx) => TaskConfigModal(
                  initialTitle: data['name'] ?? 'Task',
                  initialDescription: data['description'],
                  initialDuration: ((data['duration'] as num?)?.toInt() ?? 60).clamp(15, 120),
                  showQuadrantSelector: true,
                  onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                    try {
                      final apiService = ref.read(taskApiServiceProvider);
                      await apiService.updateTodayPlanItem(data['id'], {
                        'quadrant': quadrant ?? 'Q1',
                        'status': 'PLANNED',
                      });
                      ref.invalidate(apiTodayPlanProvider);
                      ref.invalidate(apiPendingItemsProvider(
                          '${ref.read(selectedDateProvider).year}-${ref.read(selectedDateProvider).month.toString().padLeft(2, '0')}-${ref.read(selectedDateProvider).day.toString().padLeft(2, '0')}'));
                    } catch (e) {
                      debugPrint('Error updating pending item: $e');
                    }
                  },
                ),
              );
              return;
            }
            // Past-pending item: show dialog then add to plan + delete pending record
            showDialog(
              context: context,
              builder: (ctx) => TaskConfigModal(
                initialTitle: data['name'] ?? 'New Task',
                initialDescription: data['description'],
                initialDuration:
                    ((data['duration'] as num?)?.toInt() ?? 60).clamp(15, 120),
                showQuadrantSelector: true,
                onConfirm: ({
                  required String name,
                  required int duration,
                  String? description,
                  List<String>? selectedMilestoneIds,
                  String? quadrant,
                }) async {
                  try {
                    final apiService = ref.read(taskApiServiceProvider);
                    final userId = ref.read(currentUserIdProvider);
                    final selectedDate = ref.read(selectedDateProvider);
                    final planDate =
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

                    final catalogId = data['catalog_id'];
                    if (catalogId != null) {
                      await apiService.addItemToTodayPlan(
                        itemType: 'catalog',
                        catalogId: parseTaskId(catalogId),
                        planDate: planDate,
                        plannedDurationMinutes: duration,
                        description: description,
                        quadrant: quadrant ?? 'Q1',
                        userId: userId,
                      );
                    } else {
                      await apiService.addItemToTodayPlan(
                        itemType: 'custom',
                        title: name,
                        planDate: planDate,
                        description: description,
                        plannedDurationMinutes: duration,
                        quadrant: quadrant ?? 'Q1',
                        userId: userId,
                      );
                    }
                    // ✅ Delete the past-pending record so it doesn't stay in Pending Tasks
                    if (data['is_pending'] == true && data['pending_id'] != null) {
                      await apiService.deletePendingTask(data['pending_id']);
                      ref.invalidate(apiAllPendingItemsProvider);
                    }
                    ref.invalidate(apiTodayPlanProvider);
                    ref.invalidate(apiPendingItemsProvider(planDate));
                  } catch (e) {
                    debugPrint('Error adding pending task in list view: $e');
                  }
                },
              ),
            );
            return;
          }

          // ── Normal catalog / template / custom item ──
          showDialog(
            context: context,
            builder: (ctx) => TaskConfigModal(
              initialTitle: data['name'] ?? 'New Task',
              initialDescription: data['description'],
              initialDuration:
                  ((data['duration'] as num?)?.toInt() ?? 60).clamp(15, 120),
              showQuadrantSelector: true,
              onConfirm: ({
                required String name,
                required int duration,
                String? description,
                List<String>? selectedMilestoneIds,
                String? quadrant,
              }) async {
                try {
                  final apiService = ref.read(taskApiServiceProvider);
                  final userId = ref.read(currentUserIdProvider);
                  final selectedDate = ref.read(selectedDateProvider);
                  final planDate =
                      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

                  if (data['type'] == 'catalog_item' ||
                      data['type'] == 'catalog_task' ||
                      data['type'] == 'template' ||
                      data['type'] == 'custom_template') {
                    await apiService.addItemToTodayPlan(
                      itemType: 'catalog',
                      catalogId: data['catalog_id'] ?? data['id'] ?? data['template_id'],
                      planDate: planDate,
                      plannedDurationMinutes: duration,
                      description: description,
                      quadrant: quadrant ?? 'Q1',
                      userId: userId,
                    );
                  } else {
                    await apiService.addItemToTodayPlan(
                      itemType: 'custom',
                      title: name,
                      planDate: planDate,
                      description: description,
                      plannedDurationMinutes: duration,
                      quadrant: quadrant ?? 'Q1',
                      relatedTaskId: data['task_id'] != null
                          ? parseTaskId(data['task_id'])
                          : null,
                      userId: userId,
                    );
                  }
                  ref.invalidate(apiTodayPlanProvider);
                } catch (e) {
                  debugPrint('Error adding task in list view: $e');
                }
              },
            ),
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isHovering 
              ? (isDark ? Colors.blue.withValues(alpha: 0.05) : Colors.blue.shade50.withValues(alpha: 0.3))
              : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: localItems.value.isEmpty
              ? Center(
                  child: Opacity(
                    opacity: 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_turned_in_rounded,
                          size: 120,
                          color: isDark ? Colors.white : const Color(0xFF05263E),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "NO TASKS PLANNED",
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: isDark ? Colors.white : const Color(0xFF05263E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "DROP ITEMS HERE TO START PLANNING",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: isDark ? Colors.white : const Color(0xFF05263E),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ReorderableListView(
                  buildDefaultDragHandles: false,
                  padding: const EdgeInsets.only(bottom: 100), // Extra space at bottom to facilitate drops
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final items = List<Map<String, dynamic>>.from(localItems.value);
                    final item = items.removeAt(oldIndex);
                    items.insert(newIndex, item);
                    localItems.value = items;

                    try {
                      final sortedIds = items.map((e) => e['id'].toString()).toList();
                      await ref.read(todayRepositoryProvider).updateItemsOrder(sortedIds);
                      ref.invalidate(apiTodayPlanProvider);
                    } catch (e) {
                      debugPrint('Error reordering items: $e');
                    }
                  },
                  children: localItems.value.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Draggable<Map<String, dynamic>>(
                      key: ValueKey(item['id']),
                      data: {
                        'source': 'today_plan',
                        'type': 'plan_item',
                        'id': item['id'],
                        'today_plan_id': item['id'],
                        'name': item['custom_title'] ??
                            item['catalog_name'] ??
                            item['name'] ??
                            'Task',
                        'duration': item['planned_duration_minutes'] ?? 60,
                        'status': item['status'] ?? 'PLANNED',
                        'planned_start': item['planned_start'],
                        'quadrant': item['quadrant'],
                      },
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? const Color(0xFF1F2937)
                                    .withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Text(
                              (item['custom_title'] ??
                                      item['catalog_name'] ??
                                      item['name'] ??
                                      'Task')
                                  .toUpperCase(),
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue)),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: _ApiPlannedItem(
                            apiItem: item,
                            isFinalized: isFinalized,
                            index: index,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _ApiPlannedItem(
                          apiItem: item,
                          isFinalized: isFinalized,
                          index: index,
                        ),
                      ),
                    );
                  }).toList(),

                ),
        );
      },
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onPressed;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

int parseTaskId(dynamic id) {
  final str = id.toString();
  final match = RegExp(r'\d+$').firstMatch(str);
  return int.parse(match?.group(0) ?? str);
}

class _QuadrantBox extends HookConsumerWidget {
  final String quadrant;
  final String title;
  final Color color;
  final List<Map<String, dynamic>> apiItems;
  final bool isFinalized;
  final double pulse;

  const _QuadrantBox({
    required this.quadrant,
    required this.title,
    required this.color,
    required this.apiItems,
    required this.isFinalized,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isReadOnly = ref.watch(isReadOnlyProvider);
    
    // Optimistic local state for reordering within this quadrant
    final localItems = useState<List<Map<String, dynamic>>>(apiItems);

    // Sync local state when apiItems from provider changes
    useEffect(() {
      // Robust order persistence: Only overwrite localItems if the set of IDs has changed.
      // This prevents the "snapback" effect where a stale server order overwrites a recent local shuffle.
      final localIds = localItems.value.map((e) => e['id'].toString()).toSet();
      final serverIds = apiItems.map((e) => e['id'].toString()).toSet();
      
      final bool idSetChanged = localIds.length != serverIds.length || 
                               !localIds.containsAll(serverIds);

      if (idSetChanged) {
        localItems.value = apiItems;
      }
      return null;
    }, [apiItems]);

    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        if (isReadOnly || isFinalized) return false;
        return details.data is Map<String, dynamic>;
      },
      onAcceptWithDetails: (details) async {

        if (details.data is! Map<String, dynamic>) return;
        final data = details.data as Map<String, dynamic>;

        // Handle moving an existing API item (Drag from another quadrant or list view)
        if (data['type'] == 'plan_item' || (data.containsKey('id') && !data.containsKey('type'))) {
          final int itemId = data['id'];
          // If it's already in this quadrant, do nothing
          if (data['quadrant'] == quadrant ||
              data['currentQuadrant'] == quadrant) {
            return;
          }

          try {
            // Move to new quadrant
            final apiService = ref.read(taskApiServiceProvider);
            await apiService
                .updateTodayPlanItem(itemId, {'quadrant': quadrant});
            ref.invalidate(apiTodayPlanProvider);
          } catch (e) {
            debugPrint('Error moving item: $e');
          }
        } else if (data.containsKey('type')) {
          if (data['type'] == 'pending_item' && data['is_today_inbox'] == true) {
            // Special Case: already a TodayPlan record, just needs quadrant update
            try {
              final apiService = ref.read(taskApiServiceProvider);
              await apiService.updateTodayPlanItem(data['id'], {
                'quadrant': quadrant,
                'status': 'PLANNED',
              });
              ref.invalidate(apiTodayPlanProvider);
              ref.invalidate(apiPendingItemsProvider(selectedDateStr));
            } catch (e) {
              debugPrint('Error updating pending item quadrant: $e');
            }
          } else {
            // Normal Catalog/Task Item Drag - OPEN DIALOG to capture Planned Remark
            showDialog(
              context: context,
              builder: (ctx) => TaskConfigModal(
                initialTitle: data['name'] ?? 'New Task',
                initialDescription: data['description'],
                initialDuration:
                    ((data['duration'] as num?)?.toInt() ?? 60).clamp(15, 120),
                showQuadrantSelector: false, // Box determines quadrant
                onConfirm: ({
                  required String name,
                  required int duration,
                  String? description,
                  List<String>? selectedMilestoneIds,
                  String? quadrant,
                }) async {
                  try {
                    final apiService = ref.read(taskApiServiceProvider);
                    final userId = ref.read(currentUserIdProvider);
                    final planDate = selectedDateStr;
                    
                    // Use the QuadrantBox's quadrant, not the modal's
                    final targetQuadrant = this.quadrant;

                    // Removed unused plannedItemId
                    if ((data['type'] == 'catalog_item' ||
                            data['type'] == 'custom_template' ||
                            data['type'] == 'template' ||
                            data['type'] == 'catalog_task') &&
                        (data['catalog_id'] != null ||
                            data['template_id'] != null ||
                            data['id'] != null)) {
                      await apiService.addItemToTodayPlan(
                        itemType: 'catalog',
                        catalogId: data['catalog_id'] ?? 
                                  data['template_id'] ?? 
                                  data['id'],
                        planDate: planDate,
                        plannedDurationMinutes: duration,
                        description: description,
                        quadrant: targetQuadrant,
                        userId: userId,
                      );
                      // plannedItemId = planItem['id'] as int?;
                    } else {
                      await apiService.addItemToTodayPlan(
                        itemType: 'custom',
                        title: name,
                        planDate: planDate,
                        description: description,
                        plannedDurationMinutes: duration,
                        quadrant: targetQuadrant,
                        relatedTaskId: data['task_id'] != null
                            ? parseTaskId(data['task_id'])
                            : (data['id'] != null &&
                                    data['type'] == 'catalog_task'
                                ? parseTaskId(data['id'])
                                : null),
                        userId: userId,
                      );
                      // plannedItemId = planItem['id'] as int?;
                    }

                    if (data['is_pending'] == true &&
                        data['pending_id'] != null) {
                      await apiService.deletePendingTask(data['pending_id']);
                      ref.invalidate(apiPendingItemsProvider(planDate));
                      ref.invalidate(apiAllPendingItemsProvider);
                    }

                    ref.invalidate(apiTodayPlanProvider);
                  } catch (e) {
                    debugPrint('Error adding item from drag: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to add: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },

              ),
            );
          }
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        final selectedQuadrant = ref.watch(selectedQuadrantProvider);
        final isSelected = selectedQuadrant == quadrant;
        
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        Color bgColor = isDark ? const Color(0xFF1F2937) : Colors.white;
        Color pillTextColor = Colors.grey;
        IconData quadrantIcon = Icons.info;
        Color iconColor = Colors.grey;

        if (quadrant == 'Q1') {
          bgColor = isDark ? const Color(0xFF2A1B1B) : const Color(0xFFFDF5F5);
          pillTextColor = const Color(0xFFEF4444);
          quadrantIcon = Icons.error_outline;
          iconColor = const Color(0xFFEF4444);
        } else if (quadrant == 'Q2') {
          bgColor = isDark ? const Color(0xFF172033) : const Color(0xFFF4F8FF);
          pillTextColor = const Color(0xFF3B82F6);
          quadrantIcon = Icons.calendar_today_rounded;
          iconColor = const Color(0xFF3B82F6);
        } else if (quadrant == 'Q3') {
          bgColor = isDark ? const Color(0xFF162B22) : const Color(0xFFF0FDF4);
          pillTextColor = const Color(0xFF10B981);
          quadrantIcon = Icons.people_alt_outlined;
          iconColor = const Color(0xFF10B981);
        } else if (quadrant == 'Q4') {
          bgColor = isDark ? const Color(0xFF2E1A33) : const Color(0xFFFAF5FF);
          pillTextColor = const Color(0xFFA855F7);
          quadrantIcon = Icons.delete_outline_rounded;
          iconColor = const Color(0xFFA855F7);
        }

        // Calculate progress logic removed as it was unused
        if (apiItems.isNotEmpty) {
          apiItems.where((i) => i['status'] == 'DONE' || i['status'] == 'COMPLETED').length;
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? pillTextColor.withValues(alpha: 0.8)
                  : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // New High-Fidelity Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (quadrant == 'Q1')
                          Text(
                            '!',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: iconColor.withValues(alpha: 0.8),
                            ),
                          )
                        else
                          Icon(
                            quadrantIcon,
                            size: 16,
                            color: iconColor.withValues(alpha: 0.8),
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: apiItems.isEmpty && !isHovering
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 32,
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Drop items here to plan your day",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                        buildDefaultDragHandles: false,
                        onReorder: (oldIndex, newIndex) async {
                          if (newIndex > oldIndex) newIndex -= 1;
                          
                          // Update local state IMMEDIATELY for optimistic feel
                          final items = List<Map<String, dynamic>>.from(localItems.value);
                          final item = items.removeAt(oldIndex);
                          items.insert(newIndex, item);
                          localItems.value = items;

                          try {
                            final sortedIds =
                                items.map((e) => e['id'].toString()).toList();
                            await ref
                                .read(todayRepositoryProvider)
                                .updateItemsOrder(sortedIds);
                            ref.invalidate(apiTodayPlanProvider);
                          } catch (e) {
                            debugPrint('Error reordering: $e');
                          }
                        },
                        children: localItems.value.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final i = entry.value;
                          return Draggable<Map<String, dynamic>>(
                            key: ValueKey(i['id']),
                            data: {
                              'source': 'today_plan',
                              'type': 'plan_item',
                              'id': i['id'],
                              'today_plan_id': i['id'],
                              'name': i['custom_title'] ??
                                  i['catalog_name'] ??
                                  i['name'] ??
                                  'Task',
                              'duration': i['planned_duration_minutes'] ?? 60,
                              'status': i['status'] ?? 'PLANNED',
                              'planned_start': i['planned_start'],
                              'quadrant': quadrant, // Current quadrant
                            },
                            maxSimultaneousDrags: 1, // Always allow dragging for reordering
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF1F2937)
                                          .withValues(alpha: 0.9)
                                      : Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 10)
                                  ],
                                ),
                                child: Text(
                                    (i['custom_title'] ??
                                            i['catalog_name'] ??
                                            i['name'] ??
                                            'Task')
                                        .toUpperCase(),
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: _QuadrantPlannedItem(
                                  apiItem: i,
                                  isFinalized: isFinalized,
                                  index: idx),
                            ),
                            child: _QuadrantPlannedItem(
                                apiItem: i,
                                isFinalized: isFinalized,
                                index: idx),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PendingBox extends ConsumerWidget {
  final AsyncValue<List<Map<String, dynamic>>> pendingAsync;
  final Function(Object?) onDrop;
  final String selectedDateStr;
  final bool isFinalized;

  const _PendingBox({
    required this.pendingAsync,
    required this.onDrop,
    required this.selectedDateStr,
    required this.isFinalized,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final pendingItems = pendingAsync.when(
      data: (items) => items,
      loading: () => <Map<String, dynamic>>[],
      error: (_, __) => <Map<String, dynamic>>[],
    );
    final count = pendingItems.length;

    return DragTarget<Object>(
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidate, rejected) {
        final isHovering = candidate.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            color: isHovering
                ? Colors.orange.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovering
                  ? Colors.orange
                  : (isDark
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.orange.withValues(alpha: 0.1)),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.terminal,
                                size: 18, color: Colors.orange.shade700)
                            .animate(onPlay: (c) => c.repeat())
                            .shimmer(duration: 2.seconds, color: Colors.white),
                        const SizedBox(width: 8),
                        Text("INBOX / PENDING",
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 1.5,
                                color: isDark
                                    ? Colors.orange.shade300
                                    : Colors.orange.shade800)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            count > 0 ? Colors.orange.withValues(alpha: 0.1) : null,
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                      ),
                      child: Text("$count",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.orange)),
                    ),
                  ],
                ),
              ),
              if (pendingItems.isNotEmpty)
                ...pendingItems.map((item) {
                  final isTodayInbox = item['is_today_inbox'] == true;
                  final taskName = isTodayInbox
                      ? (item['catalog_name'] ??
                          item['custom_title'] ??
                          'In-Progress Task')
                      : (item['catalog_name'] as String? ??
                          (item['today_plan_details'] as Map?)?['catalog_name']
                              as String? ??
                          (item['today_plan_details'] as Map?)?['custom_title']
                              as String? ??
                          'Pending Task');
                  final minutesLeft = isTodayInbox
                      ? (item['planned_duration_minutes'] as int? ?? 0)
                      : (item['minutes_left'] as int? ?? 0);
                  final reason = isTodayInbox
                      ? (item['notes'] as String? ?? '')
                      : (item['reason'] as String? ?? '');

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                    child: Draggable<Map<String, dynamic>>(
                      data: item,
                      maxSimultaneousDrags: isReadOnly ? 0 : 1,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1F2937).withValues(alpha: 0.9)
                                : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Text(taskName.toUpperCase(),
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange)),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: _buildItem(
                            context, isDark, taskName, reason, minutesLeft),
                      ),
                      child: _buildItem(
                          context, isDark, taskName, reason, minutesLeft),
                    ),
                  );
                }),
              if (pendingItems.isNotEmpty) const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, bool isDark, String taskName,
      String reason, int minutesLeft) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isFinalized
            ? null
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Drag this task to a quadrant to schedule it!'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark
                  ? Colors.orange.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.hourglass_bottom,
                  size: 14, color: Colors.orange.shade600),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskName.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (reason.isNotEmpty)
                      Text(
                        reason,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${minutesLeft}M',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApiPlannedItem extends ConsumerWidget {
  final Map<String, dynamic> apiItem;
  final bool isFinalized;
  final int index;

  const _ApiPlannedItem({
    required this.apiItem,
    required this.isFinalized,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemId = apiItem['id'];
    final itemName = apiItem['custom_title'] ??
        apiItem['catalog_name'] ??
        apiItem['name'] ??
        'Task';

    final duration = apiItem['planned_duration_minutes'] ?? 0;
    final status = (apiItem['status'] ?? 'PLANNED').toString().toUpperCase();

    final isReadOnly = ref.watch(isReadOnlyProvider);

    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.blue.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            // No animation, just simple card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(children: [
                Expanded(
                    child: InkWell(
                      onTap: isFinalized ? null : () {
                        showDialog(
                          context: context,
                          builder: (ctx) => TaskConfigModal(
                            initialTitle: itemName,
                            initialDescription: apiItem['notes'],
                            initialDuration: ((apiItem['planned_duration_minutes'] as num?)?.toInt() ?? 60).clamp(15, 120),
                            showQuadrantSelector: false,
                            onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                              try {
                                final apiService = ref.read(taskApiServiceProvider);
                                await apiService.updateTodayPlanItem(itemId, {
                                  'custom_title': name,
                                  'planned_duration_minutes': duration,
                                  'notes': description ?? '',
                                });
                                ref.invalidate(apiTodayPlanProvider);
                              } catch (e) {
                                debugPrint('Error editing plan item: $e');
                              }
                            },
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(itemName,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  letterSpacing: 0.2,
                                  color:
                                      Theme.of(context).textTheme.bodyLarge?.color)),
                          if (status == 'IN_ACTIVITY' || status == 'STARTED')
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.green.withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  'EXECUTING',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          if (apiItem['notes'] != null &&
                              apiItem['notes'].toString().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                apiItem['notes'],
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("${duration}m",
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ),
                const SizedBox(width: 8),
                // Conditional Arrow Button
                Builder(
                  builder: (context) {
                    final today = DateTime.now();
                    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
                    
                    return IconButton(
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: isDark
                            ? Colors.blue.shade300.withValues(alpha: 0.4)
                            : Colors.blue.shade600.withValues(alpha: 0.4),
                      ),
                      onPressed: null, // Tapping a plan item does nothing
                    );
                  }
                ),
                // Custom Drag Handle - always available for inner shuffle
                ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.reorder_rounded,
                    size: 20,
                    color: isDark
                        ? Colors.blue.withValues(alpha: 0.5)
                        : Colors.blue.withValues(alpha: 0.3),
                  ),
                ),
                if (!isFinalized) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                      width: 24,
                      height: 24,
                      child: PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.more_horiz,
                              size: 18,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade400),
                          onSelected: (value) async {
                            if (value == 'edit' && itemId != null) {
                              showDialog(
                                context: context,
                                builder: (ctx) => TaskConfigModal(
                                  initialTitle: itemName,
                                  initialDescription: apiItem['notes'],
                                  initialDuration: ((apiItem['planned_duration_minutes'] as num?)?.toInt() ?? 60).clamp(15, 120),
                                  showQuadrantSelector: false,
                                  onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                                    try {
                                      // ✅ Update existing item — do NOT create new
                                      final apiService = ref.read(taskApiServiceProvider);
                                      await apiService.updateTodayPlanItem(itemId, {
                                        'custom_title': name,
                                        'planned_duration_minutes': duration,
                                        'notes': description ?? '',
                                      });
                                      ref.invalidate(apiTodayPlanProvider);
                                    } catch (e) {
                                      debugPrint('Error editing plan item: $e');
                                    }
                                  },
                                ),
                              );
                            } else if (value == 'delete' && itemId != null) {
                              try {
                                final apiService =
                                    ref.read(taskApiServiceProvider);
                                await apiService.deleteTodayPlanItem(itemId);
                                ref.invalidate(apiTodayPlanProvider);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Failed to delete: $e')),
                                  );
                                }
                              }
                            }
                          },
                          itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: 'edit', child: Text("Edit")),
                                const PopupMenuItem(
                                    value: 'delete', child: Text("Delete"))
                              ]))
                ],

              ]),
            ),
          ],
        ));
  }
}

class _QuadrantPlannedItem extends ConsumerWidget {
  final Map<String, dynamic> apiItem;
  final bool isFinalized;
  final int index;

  const _QuadrantPlannedItem({
    required this.apiItem,
    required this.isFinalized,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemId = apiItem['id'];
    final itemName = (apiItem['custom_title'] ??
            apiItem['catalog_name'] ??
            apiItem['name'] ??
            'Task')
        .toString();

    final duration = apiItem['planned_duration_minutes'] ?? 0;
    final isReadOnly = ref.watch(isReadOnlyProvider);

    // Card Styling
    final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Task Name and Planned Remark — tappable to edit
            Expanded(
              child: InkWell(
                onTap: isReadOnly ? null : () {
                  showDialog(
                    context: context,
                    builder: (ctx) => TaskConfigModal(
                      initialTitle: itemName,
                      initialDescription: apiItem['notes'],
                      initialDuration: ((apiItem['planned_duration_minutes'] as num?)?.toInt() ?? 60).clamp(15, 120),
                      showQuadrantSelector: false,
                      onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                        try {
                          final apiService = ref.read(taskApiServiceProvider);
                          await apiService.updateTodayPlanItem(itemId, {
                            'custom_title': name,
                            'planned_duration_minutes': duration,
                            'notes': description ?? '',
                          });
                          ref.invalidate(apiTodayPlanProvider);
                        } catch (e) {
                          debugPrint('Error editing plan item: $e');
                        }
                      },
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      itemName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (apiItem['notes'] != null && apiItem['notes'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          apiItem['notes'].toString(),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Duration
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "${duration}M",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Execute Arrow
            Builder(
              builder: (context) {
                final today = DateTime.now();
                final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
                
                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: isReadOnly ? Colors.grey.withValues(alpha: 0.3) : (isDark ? Colors.blue.shade300 : Colors.blue.shade600),
                  ),
                  onPressed: isReadOnly ? null : () {
                    // Allow unplanned tasks even if day isn't locked
                    final bool itemIsUnplanned = apiItem['is_unplanned'] == true;

                    if (!isFinalized && !itemIsUnplanned) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Lock/Start the day plan to begin recording activities.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    
                    showDialog(
                      context: context,
                      builder: (ctx) => TaskConfigModal(
                        initialTitle: itemName,
                        initialDescription: apiItem['notes'],
                        initialDuration: ((apiItem['planned_duration_minutes'] as num?)?.toInt() ?? 60).clamp(15, 120),
                        showQuadrantSelector: false,
                        onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                          try {
                            // ✅ Update existing plan item — do NOT create a new one
                            final apiService = ref.read(taskApiServiceProvider);
                            await apiService.updateTodayPlanItem(itemId, {
                              'planned_duration_minutes': duration,
                              'notes': description ?? '',
                            });
                            ref.invalidate(apiTodayPlanProvider);
                          } catch (e) {
                            debugPrint('Error updating plan item: $e');
                          }
                          final shellItem = {
                            'id': 0,
                            'today_plan': {
                              'id': itemId,
                              'catalog_name': itemName,
                              'planned_duration_minutes': duration,
                              'notes': description ?? apiItem['notes'] ?? '',
                            },
                            'actual_start_time': null,
                            'actual_end_time': null,
                            'minutes_worked': 0,
                          };
                          if (ctx.mounted) {
                            showReviewTaskDialog(ctx, ref, shellItem, isEditMode: false);
                          }
                        },
                      ),
                    );
                  },
                );
              }
            ),

            // Drag Handle
            ReorderableDragStartListener(
              index: index,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.reorder_rounded,
                  size: 18,
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                ),
              ),
            ),

            // Menu
            if (!isFinalized)
              SizedBox(
                width: 24,
                height: 24,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.more_vert_rounded,
                      size: 18,
                      color: isDark
                          ? Colors.grey.shade500
                          : Colors.grey.shade400),
                  onSelected: (value) async {
                    if (value == 'delete' && itemId != null) {
                      try {
                        final apiService = ref.read(taskApiServiceProvider);
                        await apiService.deleteTodayPlanItem(itemId);
                        ref.invalidate(apiTodayPlanProvider);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to delete: $e')),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: 'delete', child: Text("Delete"))
                  ]
                )
              )
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.dashWidth = 5,
    this.dashSpace = 5,
    this.strokeWidth = 1,
    this.borderRadius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius)));

    final dashedPath = Path();
    for (final pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
