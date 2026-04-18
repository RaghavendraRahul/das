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

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.15)
                : Colors.black.withOpacity(0.02),
            blurRadius: 2,
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
                      letterSpacing: 0.2,
                      color: isDark ? Colors.white : const Color(0xFF05263E),
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
                                showQuadrantSelector: isQuadrantView,
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
          const SizedBox(height: 20),

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
                              // Case 2: Catalog Item or Project Task (add to inbox)
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
                                            quadrant: 'inbox',
                                            userId: userId,
                                          );
                                        } else {
                                          await apiService.addItemToTodayPlan(
                                            itemType: 'custom',
                                            title: name,
                                            planDate: planDate,
                                            description: description,
                                            plannedDurationMinutes: duration,
                                            quadrant: 'inbox',
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
                                        debugPrint('Error adding to inbox: $e');
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
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.green.withOpacity(0.15)
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
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
                      width: double.infinity,
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _QuadrantBox(
            quadrant: 'Q1',
            title: 'Q1 Do First (Urgent & Important)',
            color: const Color(0xFFEF4444), // Red
            apiItems: apiItems
                .where((i) => i['quadrant']?.toString().toUpperCase() == 'Q1')
                .toList(),
            isFinalized: isFinalized,
            pulse: pulse,
          ),
          const SizedBox(height: 12),
          _QuadrantBox(
            quadrant: 'Q2',
            title: 'Q2 Schedule (Important, Not Urgent)',
            color: const Color(0xFFF97316), // Orange
            apiItems: apiItems
                .where((i) => i['quadrant']?.toString().toUpperCase() == 'Q2')
                .toList(),
            isFinalized: isFinalized,
            pulse: pulse,
          ),
          const SizedBox(height: 12),
          _QuadrantBox(
            quadrant: 'Q3',
            title: 'Q3 Delegate (Urgent, Not Important)',
            color: const Color(0xFFA855F7), // Purple
            apiItems: apiItems
                .where((i) => i['quadrant']?.toString().toUpperCase() == 'Q3')
                .toList(),
            isFinalized: isFinalized,
            pulse: pulse,
          ),
          const SizedBox(height: 12),
          _QuadrantBox(
            quadrant: 'Q4',
            title: 'Q4 Eliminate (Neither)',
            color: Colors.teal,
            apiItems: apiItems
                .where((i) => i['quadrant']?.toString().toUpperCase() == 'Q4')
                .toList(),
            isFinalized: isFinalized,
            pulse: pulse,
          ),
        ],
      ),
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

    // Sync local state when apiItems from provider changes
    useEffect(() {
      localItems.value = apiItems;
      return null;
    }, [apiItems]);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        if (isReadOnly || isFinalized) return false;
        return details.data is Map<String, dynamic>;
      },
      onAcceptWithDetails: (details) async {
        if (details.data is! Map<String, dynamic>) return;
        final data = details.data as Map<String, dynamic>;

        if (data.containsKey('type')) {
          showDialog(
            context: context,
            builder: (ctx) => TaskConfigModal(
              initialTitle: data['name'] ?? 'New Task',
              initialDescription: data['description'],
              initialDuration:
                  ((data['duration'] as num?)?.toInt() ?? 60).clamp(15, 120),
              showQuadrantSelector: false,
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

                  int? plannedItemId;
                  if (data['type'] == 'catalog_item' ||
                      data['type'] == 'catalog_task' ||
                      data['type'] == 'template' ||
                      data['type'] == 'custom_template') {
                    final planItem = await apiService.addItemToTodayPlan(
                      itemType: 'catalog',
                      catalogId: data['catalog_id'] ?? data['id'] ?? data['template_id'],
                      planDate: planDate,
                      plannedDurationMinutes: duration,
                      description: description,
                      quadrant: 'inbox',
                      userId: userId,
                    );
                    plannedItemId = planItem['id'] as int?;
                  } else {
                    final planItem = await apiService.addItemToTodayPlan(
                      itemType: 'custom',
                      title: name,
                      planDate: planDate,
                      description: description,
                      plannedDurationMinutes: duration,
                      quadrant: 'inbox',
                      relatedTaskId: data['task_id'] != null
                          ? parseTaskId(data['task_id'])
                          : null,
                      userId: userId,
                    );
                    plannedItemId = planItem['id'] as int?;
                  }
                  
                  ref.invalidate(apiTodayPlanProvider);

                  // Open Review Dialog (Step 2)
                  if (context.mounted && plannedItemId != null) {
                    final Map<String, dynamic> shellItem = {
                      'id': 0,
                      'today_plan': {
                        'id': plannedItemId,
                        'catalog_name': name,
                        'planned_duration_minutes': duration,
                        'notes': description ?? '',
                      },
                      'actual_start_time': null,
                      'actual_end_time': null,
                      'minutes_worked': 0,
                    };
                    showReviewTaskDialog(context, ref, shellItem, isEditMode: false);
                  }
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
              ? (isDark ? Colors.blue.withOpacity(0.05) : Colors.blue.shade50.withOpacity(0.3))
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
                    return Padding(
                      key: ValueKey(item['id']),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _ApiPlannedItem(
                        apiItem: item,
                        isFinalized: isFinalized,
                        index: index,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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

        // Handle moving an existing API item (Drag from another quadrant)
        if (data.containsKey('id') && !data.containsKey('type')) {
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

                    int? plannedItemId;
                    if ((data['type'] == 'catalog_item' ||
                            data['type'] == 'custom_template' ||
                            data['type'] == 'template' ||
                            data['type'] == 'catalog_task') &&
                        (data['catalog_id'] != null ||
                            data['template_id'] != null ||
                            data['id'] != null)) {
                      final planItem = await apiService.addItemToTodayPlan(
                        itemType: 'catalog',
                        catalogId: data['catalog_id'] ?? 
                                  data['template_id'] ?? 
                                  data['id'],
                        planDate: planDate,
                        plannedDurationMinutes: duration,
                        description: description,
                        quadrant: quadrant,
                        userId: userId,
                      );
                      plannedItemId = planItem['id'] as int?;
                    } else {
                      final planItem = await apiService.addItemToTodayPlan(
                        itemType: 'custom',
                        title: name,
                        planDate: planDate,
                        description: description,
                        plannedDurationMinutes: duration,
                        quadrant: quadrant,
                        relatedTaskId: data['task_id'] != null
                            ? parseTaskId(data['task_id'])
                            : (data['id'] != null &&
                                    data['type'] == 'catalog_task'
                                ? parseTaskId(data['id'])
                                : null),
                        userId: userId,
                      );
                      plannedItemId = planItem['id'] as int?;
                    }

                    if (data['is_pending'] == true &&
                        data['pending_id'] != null) {
                      await apiService.deletePendingTask(data['pending_id']);
                      ref.invalidate(apiPendingItemsProvider(planDate));
                      ref.invalidate(apiAllPendingItemsProvider);
                    }

                    ref.invalidate(apiTodayPlanProvider);

                    // Open Review Dialog (Step 2)
                    if (context.mounted && plannedItemId != null) {
                      final Map<String, dynamic> shellItem = {
                        'id': 0,
                        'today_plan': {
                          'id': plannedItemId,
                          'catalog_name': name,
                          'planned_duration_minutes': duration,
                          'notes': description ?? '',
                        },
                        'actual_start_time': null,
                        'actual_end_time': null,
                        'minutes_worked': 0,
                      };
                      showReviewTaskDialog(context, ref, shellItem, isEditMode: false);
                    }
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
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? color.withOpacity(0.5)
                  : (isDark ? const Color(0xFF374151) : Colors.grey.shade200),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with Sidebar Theme
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF05263E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 14,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          size: 16, color: color),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    if (apiItems.isEmpty && !isHovering)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
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
                    else
                      ReorderableListView(
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
                                        color: Colors.black.withOpacity(0.2),
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
                              child: _ApiPlannedItem(
                                  apiItem: i,
                                  isFinalized: isFinalized,
                                  index: idx),
                            ),
                            child: _ApiPlannedItem(
                                apiItem: i,
                                isFinalized: isFinalized,
                                index: idx),
                          );
                        }).toList(),
                      ),
                  ],
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
                ? Colors.orange.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovering
                  ? Colors.orange
                  : (isDark
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.1)),
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
                            count > 0 ? Colors.orange.withOpacity(0.1) : null,
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: Colors.orange.withOpacity(0.3)),
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
                                ? const Color(0xFF1F2937).withOpacity(0.9)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
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
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.05),
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
                  color: Colors.orange.withOpacity(0.1),
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
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(itemName,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 0.5,
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
                    final logsAsync = ref.watch(apiActivityLogsProvider(todayStr));
                    
                    bool isAlreadyInLog = logsAsync.maybeWhen(
                      data: (logs) => logs.any((l) => l['today_plan']?['id'] == itemId),
                      orElse: () => false,
                    );

                    return IconButton(
                      icon: Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: isAlreadyInLog 
                          ? Colors.grey.withValues(alpha: 0.3) 
                          : (isDark ? Colors.blue.shade300 : Colors.blue.shade600),
                      ),
                      onPressed: isAlreadyInLog || isReadOnly ? null : () {
                        // Restore logic: Trigger the manual review flow
                        showDialog(
                          context: context,
                          builder: (ctx) => TaskConfigModal(
                            initialTitle: itemName,
                            initialDescription: apiItem['notes'],
                            initialDuration: ((apiItem['planned_duration_minutes'] as num?)?.toInt() ?? 60).clamp(15, 120),
                            showQuadrantSelector: false,
                            onConfirm: ({required String name, required int duration, String? description, List<String>? selectedMilestoneIds, String? quadrant}) async {
                              // Direct shell item construction
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
                              if (context.mounted) {
                                showReviewTaskDialog(context, ref, shellItem, isEditMode: false);
                              }
                            },
                          ),
                        );
                      },
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
                            if (value == 'delete' && itemId != null) {
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
                                    value: 'delete', child: Text("Delete"))
                              ]))
                ],

              ]),
            ),
          ],
        ));
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
