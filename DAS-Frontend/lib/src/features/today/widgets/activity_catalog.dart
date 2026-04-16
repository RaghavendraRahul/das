import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart'; // Added for custom fonts
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/today/widgets/task_config_modal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_pm/src/core/database/database.dart';

import 'package:project_pm/src/features/today/widgets/add_activity_template_modal.dart';
import 'package:project_pm/src/features/today/today_providers.dart';

import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/shared/widgets/circular_progress.dart';
import 'package:project_pm/src/core/database/database_provider.dart';
import 'package:project_pm/src/features/projects/providers/api_providers.dart';
import 'package:project_pm/src/features/projects/models/catalog_model.dart';
import 'package:project_pm/src/features/projects/models/task_model.dart';
import 'package:project_pm/src/core/providers/user_providers.dart';

class ActivityCatalog extends HookConsumerWidget {
  const ActivityCatalog({super.key});

  static const Map<String, List<Map<String, dynamic>>> systemTemplates = {
    'Routine': [
      {
        'name': 'Coffee Break',
        'icon': FontAwesomeIcons.mugHot,
        'desc': 'Take a short break'
      },
      {
        'name': 'Lunch',
        'icon': FontAwesomeIcons.utensils,
        'desc': 'Lunch break'
      },
      {
        'name': 'Walk',
        'icon': FontAwesomeIcons.personWalking,
        'desc': 'Go for a walk'
      },
    ],
    'Education': [
      {
        'name': 'Learning',
        'icon': FontAwesomeIcons.graduationCap,
        'desc': 'Study new topic'
      },
      {'name': 'Reading', 'icon': FontAwesomeIcons.book, 'desc': 'Read a book'},
      {
        'name': 'Course',
        'icon': FontAwesomeIcons.chalkboardUser,
        'desc': 'Online course'
      },
    ],
    'Work': [
      {
        'name': 'Req. Gathering',
        'icon': FontAwesomeIcons.briefcase,
        'desc': 'Client requirements meeting'
      },
      {
        'name': 'Documentation',
        'icon': FontAwesomeIcons.fileLines,
        'desc': 'Update project docs'
      },
      {
        'name': 'Interview',
        'icon': FontAwesomeIcons.users,
        'desc': 'Candidate interview'
      },
    ],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final searchQuery = useState('');
    final selectedFilter = useState('All');
    final expandedCategory =
        useState<String?>('CatalogProjects'); // Default to first category

    // Watch catalog data from API - Work, Routine, Course items
    final catalogAsync = ref.watch(apiCatalogProvider);

    // Watch catalog tasks from API - Only user's assigned tasks
    final catalogTasksAsync = ref.watch(apiCatalogTasksProvider);

    // Watch pending tasks from API - show all pending tasks for catalog
    final pendingAsync = ref.watch(apiAllPendingItemsProvider);

    // Watch custom templates from database
    final db = ref.watch(databaseProvider);
    final customTemplatesStream = useMemoized(
      () => (db.select(db.activityTemplates)
            ..where((t) => t.status.equals('approved')))
          .watch(),
      [db],
    );
    final customTemplatesSnapshot = useStream(customTemplatesStream);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.15) : Colors.black.withOpacity(0.02),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ACTIVITY CATALOG",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: isDark ? Colors.white : const Color(0xFF05263E),
                      ),
                    ),
                    // Add Template Button
                    if (!isReadOnly)
                      InkWell(
                        onTap: () {
                          // Extract unique categories from current catalog items
                          final catalogItems = catalogAsync.valueOrNull ?? [];
                          final backendCatalogTypes = {
                            'COURSE',
                            'ROUTINE',
                            'WORK',
                            ...catalogItems
                                .map((item) => item.catalogType)
                                .where((type) =>
                                    type.isNotEmpty && type != 'PROJECT'),
                          }.toList();
                          backendCatalogTypes.sort();

                          showDialog(
                            context: context,
                            builder: (context) => AddActivityTemplateModal(
                              existingCategories: backendCatalogTypes,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF374151)
                                : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: 12,
                                color: isDark ? Colors.white : const Color(0xFF05263E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "New Catalog",
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : const Color(0xFF05263E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search
                SizedBox(
                  height: 36,
                  child: TextField(
                    onChanged: (v) => searchQuery.value = v,
                    decoration: InputDecoration(
                      hintText: 'Search templates...',
                      hintStyle: GoogleFonts.inter(
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                        fontSize: 11,
                      ),
                      prefixIcon: Icon(Icons.search_rounded,
                          size: 16,
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade400),
                      filled: true,
                      fillColor:
                          isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Content - Scrollable with Expandable Categories
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              child: Builder(
                builder: (context) {
                  final customTemplates = customTemplatesSnapshot.data ?? [];

                  // Get catalog data from API
                  final catalogItems = catalogAsync.when(
                    data: (data) => data,
                    loading: () => <CatalogModel>[],
                    error: (e, _) {
                      print('Error loading catalog: $e');
                      return <CatalogModel>[];
                    },
                  );

                  // Group custom templates by category (case-insensitive)
                  final templatesByCategory =
                      <String, List<ActivityTemplate>>{};
                  for (final t in customTemplates) {
                    final cat = t.category;
                    templatesByCategory.putIfAbsent(cat, () => []).add(t);
                  }

                  // Group catalog items by type
                  final catalogByType = <String, List<CatalogModel>>{};
                  for (final item in catalogItems) {
                    // Skip PROJECT types as requested
                    if (item.catalogType == 'PROJECT') continue;

                    // Map CUSTOM to WORK
                    final type = item.catalogType == 'CUSTOM'
                        ? 'WORK'
                        : item.catalogType;
                    catalogByType.putIfAbsent(type, () => []).add(item);
                  }

                  // Get all unique categories (system + custom + catalog)
                  final predefinedCategories = {
                    'COURSE',
                    'ROUTINE',
                    'WORK',
                    'CUSTOM',
                    'PROJECT'
                  };

                  final allCategories = <String>{
                    if (catalogByType.containsKey('COURSE')) 'Education',
                    if (catalogByType.containsKey('ROUTINE')) 'Routine',
                    if (catalogByType.containsKey('WORK')) 'Work',
                    // Add dynamic categories from catalog (converted to Title Case)
                    ...catalogByType.keys
                        .where((k) => !predefinedCategories.contains(k))
                        .map((k) {
                      if (k.isEmpty) return k;
                      return k[0] + k.substring(1).toLowerCase();
                    }),
                    ...templatesByCategory.keys,
                  };

                  // Category icon/color mapping
                  IconData getCategoryIcon(String category) {
                    final cat = category.toLowerCase();
                    if (cat.contains('education') || cat.contains('course')) {
                      return Icons.school_rounded;
                    } else if (cat.contains('routine')) {
                      return Icons.event_repeat_rounded;
                    } else if (cat.contains('work') && !cat.contains('client')) {
                      return Icons.work_rounded;
                    } else if (cat.contains('health')) {
                      return Icons.favorite_rounded;
                    } else if (cat.contains('client')) {
                      return Icons.business_center_rounded;
                    } else if (cat.contains('require')) {
                      return Icons.assignment_rounded;
                    } else if (cat.contains('pending')) {
                      return Icons.assignment_late_rounded;
                    } else if (cat.contains('task')) {
                      return Icons.assignment_rounded;
                    }
                    return Icons.folder_rounded;
                  }

                  Color getCategoryColor(String category) {
                    final cat = category.toLowerCase();
                    if (cat.contains('education') || cat.contains('course')) {
                      return const Color(0xFFA25AFF); // Purple
                    } else if (cat.contains('routine')) {
                      return const Color(0xFF34C759); // Green
                    } else if (cat.contains('work') && !cat.contains('client')) {
                      return const Color(0xFF007AFF); // Blue
                    } else if (cat.contains('client')) {
                      return const Color(0xFF5856D6); // Indigo / Deep Blue
                    } else if (cat.contains('health')) {
                      return const Color(0xFFFF2D55); // Pink/Red
                    } else if (cat.contains('pending')) {
                      return const Color(0xFFFF9500); // Orange
                    } else if (cat.contains('require')) {
                      return const Color(0xFF30B0C7); // Teal/Cyan
                    }

                    // For any new catalog, pick a consistent color based on its name
                    final colors = [
                      const Color(0xFF30B0C7), // Teal
                      const Color(0xFFFF2D55), // Pink
                      const Color(0xFF5856D6), // Indigo
                      const Color(0xFF00C7BE), // Mint
                      const Color(0xFFFFCC00), // Yellow
                      const Color(0xFFAF52DE), // Violet
                    ];
                    final index = category.length % colors.length;
                    return colors[index];
                  }

                  return Column(
                    children: [
                      // Pending Tasks Category (above Project)
                      () {
                        final pendingItems = pendingAsync.when(
                          data: (data) => data,
                          loading: () => <Map<String, dynamic>>[],
                          error: (_, __) => <Map<String, dynamic>>[],
                        );
                        final filteredPending = pendingItems.where((item) {
                          if (searchQuery.value.isEmpty) return true;
                          final name = (item['catalog_name'] ??
                              item['today_plan_details']?['catalog_name'] ??
                              '') as String;
                          return name
                              .toLowerCase()
                              .contains(searchQuery.value.toLowerCase());
                        }).toList();
                        if (filteredPending.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return _ExpandableCategory(
                          title: 'Pending',
                          icon: Icons.assignment_late_rounded,
                          iconColor: const Color(0xFFFF9500), // Orange
                          count: filteredPending.length,
                          isExpanded: expandedCategory.value == 'Pending',
                          onTap: () {
                            expandedCategory.value =
                                expandedCategory.value == 'Pending'
                                    ? null
                                    : 'Pending';
                          },
                          isDark: isDark,
                          children: filteredPending
                              .map<Widget>((item) => _PendingTaskCard(
                                    pendingItem: item,
                                  ))
                              .toList(),
                        );
                      }(),

                      // Catalog Tasks Category (Only user's assigned tasks)
                      () {
                        final catalogTasks = catalogTasksAsync.when(
                          data: (data) => data,
                          loading: () => [],
                          error: (_, __) => [],
                        );

                        final filteredCatalogTasks = catalogTasks.where((task) {
                          if (searchQuery.value.isEmpty) return true;
                          return task.title
                              .toLowerCase()
                              .contains(searchQuery.value.toLowerCase());
                        }).toList();

                        if (filteredCatalogTasks.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return _ExpandableCategory(
                          title: 'My Tasks',
                          icon: Icons.assignment_rounded,
                          iconColor: const Color(0xFF007AFF), // Blue
                          count: filteredCatalogTasks.length,
                          isExpanded: expandedCategory.value == 'CatalogTasks',
                          onTap: () {
                            expandedCategory.value =
                                expandedCategory.value == 'CatalogTasks'
                                    ? null
                                    : 'CatalogTasks';
                          },
                          isDark: isDark,
                          children: filteredCatalogTasks
                              .map((task) => _CatalogTaskCard(
                                    task: task,
                                  ))
                              .toList(),
                        );
                      }(),

                      // Dynamic categories (Education, Routine, Work, etc.)
                      ...allCategories.map((category) {
                        // Filter logic
                        if (selectedFilter.value != 'All' &&
                            selectedFilter.value != category) {
                          return const SizedBox.shrink();
                        }

                        // 1. Get raw items
                        // final rawSystemItems = systemTemplates[category] ?? []; // Disabled - only show database items
                        final rawCustomItems =
                            templatesByCategory[category] ?? [];

                        List<CatalogModel> rawCatalogItems = [];
                        if (category == 'Education') {
                          rawCatalogItems = catalogByType['COURSE'] ?? [];
                        } else if (category == 'Routine') {
                          rawCatalogItems = catalogByType['ROUTINE'] ?? [];
                        } else if (category == 'Work') {
                          rawCatalogItems = catalogByType['WORK'] ?? [];
                        } else {
                          rawCatalogItems =
                              catalogByType[category.toUpperCase()] ?? [];
                        }

                        // 2. Filter items based on search query
                        final query = searchQuery.value.toLowerCase();

                        // final filteredSystemItems = rawSystemItems // Disabled - only show database items
                        //     .where((item) =>
                        //         query.isEmpty ||
                        //         (item['name'] as String)
                        //             .toLowerCase()
                        //             .contains(query))
                        //     .toList();

                        final filteredCustomItems = rawCustomItems
                            .where((t) =>
                                query.isEmpty ||
                                t.name.toLowerCase().contains(query))
                            .toList();

                        final filteredCatalogItems = rawCatalogItems
                            .where((item) =>
                                query.isEmpty ||
                                item.name.toLowerCase().contains(query))
                            .toList();

                        final totalCount = // filteredSystemItems.length + // Disabled - only show database items
                            filteredCustomItems.length +
                                filteredCatalogItems.length;

                        // 3. Skip if no items match
                        if (totalCount == 0) return const SizedBox.shrink();

                        // 4. Auto-expand if searching
                        final shouldExpand = query.isNotEmpty ||
                            expandedCategory.value == category;

                        return _ExpandableCategory(
                          title: category,
                          icon: getCategoryIcon(category),
                          iconColor: getCategoryColor(category),
                          count: totalCount,
                          isExpanded: shouldExpand,
                          onTap: () {
                            // Toggle only if not searching (or allow collapsing explicitly)
                            if (query.isNotEmpty) return;

                            expandedCategory.value =
                                expandedCategory.value == category
                                    ? null
                                    : category;
                          },
                          isDark: isDark,
                          children: [
                            // Catalog items from API
                            ...filteredCatalogItems
                                .map((catalogItem) => _CatalogItemCard(
                                      catalogItem: catalogItem,
                                    )),
                            // System templates - Disabled to show only database items
                            // ...filteredSystemItems
                            //     .map((item) => _SystemTemplateCard(
                            //           name: item['name'] as String,
                            //           icon: item['icon'] as IconData,
                            //           description:
                            //               item['desc'] as String? ?? '',
                            //           category: category,
                            //         )),
                            // Custom templates
                            ...filteredCustomItems
                                .map((template) => _CustomTemplateCard(
                                      template: template,
                                    )),
                          ],
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Expandable category section
class _ExpandableCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final int count;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool isDark;
  final List<Widget> children;

  const _ExpandableCategory({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.isExpanded,
    required this.onTap,
    required this.isDark,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isExpanded
                    ? (isDark ? const Color(0xFF374151) : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isExpanded && !isDark
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  if (count > 0)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: iconColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$count',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
        // Children
        if (isExpanded && children.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 4, bottom: 8),
            child: Column(children: children),
          ),
        const SizedBox(height: 4),
      ],
    );
  }
}

/// Card for project tasks with progress circle and dates
class _ProjectTaskCard extends ConsumerWidget {
  final ProjectWithTasks project;
  final TaskWithAssignees task;

  const _ProjectTaskCard({
    required this.project,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final activeSessionAsync =
        ref.watch(apiActiveSessionProvider(selectedDateStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskEnd =
        DateTime(task.endDate.year, task.endDate.month, task.endDate.day);

    // Date color logic
    Color taskDateColor;
    String taskDateText;
    if (taskEnd.isBefore(today)) {
      taskDateColor = Colors.red;
      taskDateText = _formatDate(task.endDate);
    } else if (taskEnd.isAtSameMomentAs(today)) {
      taskDateColor = Colors.orange;
      taskDateText = 'Today';
    } else {
      taskDateColor = isDark ? Colors.grey.shade300 : Colors.grey.shade700;
      taskDateText = _formatDate(task.endDate);
    }

    final projectEnd = project.tasks
        .map((t) => t.endDate)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    final dragData = {
      'source': 'catalog',
      'type': 'project_task',
      'name': task.task.name,
      'duration': 30, // Default duration since task duration is not available
      'task_id': parseTaskId(task.task.id),
      'taskObject': task.task,
      'projectObject': project.project,
    };

    return Draggable<Map<String, dynamic>>(
      data: dragData,
      maxSimultaneousDrags: isReadOnly ? 0 : 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue.shade500.withOpacity(0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.task.name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 12, color: Colors.blue.shade400),
                  const SizedBox(width: 4),
                  Text(
                    "30 min • Drag to planner",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.blue.shade400,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildCardContent(
              context, isDark, projectEnd, taskDateColor, taskDateText),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () async {
            if (isFinalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Day is locked. Drag to ACTIVITY LOG to work on this as unplanned."),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            showDialog(
              context: context,
              builder: (context) => TaskConfigModal(
                initialTitle: task.task.name,
                initialDescription: null,
                initialDuration: 30,
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

                    await apiService.addItemToTodayPlan(
                      itemType: 'custom',
                      title: name,
                      planDate: planDate,
                      description: description,
                      plannedDurationMinutes: duration,
                      quadrant: quadrant ?? 'Q1',
                      relatedTaskId: parseTaskId(task.task.id),
                      userId: userId,
                    );
                    ref.invalidate(apiTodayPlanProvider);
                  } catch (e) {
                    debugPrint('Error adding project task: $e');
                  }
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: _buildCardContent(
              context, isDark, projectEnd, taskDateColor, taskDateText),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, bool isDark,
      DateTime projectEnd, Color taskDateColor, String taskDateText) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : Colors.grey.shade200,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04), // Lighter shadow
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 4,
            child: ColoredBox(color: Colors.blue.shade500),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 12, right: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        project.project.name,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.drag_indicator_rounded,
                      size: 16,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Task name
                Text(
                  task.task.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Dates and progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dates
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Task: ',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              taskDateText,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: taskDateColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'Prj: ',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              _formatDate(projectEnd),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Progress circle
                    CircularProgressWidget(
                      progress: task.progress,
                      size: 36,
                      strokeWidth: 3.5,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfigModal(BuildContext context, WidgetRef ref) {
    debugPrint(
        'Opening TaskConfigModal for task: ${task.task.name}, project: ${project.project.name}');
    try {
      showDialog(
        context: context,
        builder: (ctx) => TaskConfigModal(
          projectWithTasks: project,
          taskWithAssignees: task,
          onConfirm: ({
            required String name,
            required int duration,
            String? description,
            List<String>? selectedMilestoneIds,
            String? quadrant,
          }) async {
            try {
              final apiService = ref.read(taskApiServiceProvider);
              final now = DateTime.now();
              final planDate =
                  '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

              await apiService.addItemToTodayPlan(
                itemType: 'custom',
                title: task.task.name,
                planDate: planDate,
                description: description,
                plannedDurationMinutes: duration,
                quadrant: 'inbox',
                relatedTaskId: parseTaskId(task.task.id),
              );
              // Invalidate provider to refresh logic
              ref.invalidate(apiTodayPlanProvider);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to add task: $e')),
                );
              }
            }
          },
        ),
      );
    } catch (e, st) {
      debugPrint('Error showing generic modal: $e\n$st');
    }
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
    return '${months[date.month - 1]} ${date.day}';
  }
}

/// Card for system templates (Routine, Education)
class _SystemTemplateCard extends ConsumerWidget {
  final String name;
  final IconData icon;
  final String description;
  final String category;

  const _SystemTemplateCard({
    required this.name,
    required this.icon,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final activeSessionAsync =
        ref.watch(apiActiveSessionProvider(selectedDateStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);

    final dragData = {
      'source': 'catalog',
      'type': 'template',
      'name': name,
      'description': description,
      'duration': 30,
    };

    return Draggable<Map<String, dynamic>>(
      data: dragData,
      maxSimultaneousDrags: isReadOnly ? 0 : 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: category == 'Routine' ? Colors.orange : Colors.purple,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: category == 'Routine'
                    ? const Color.fromARGB(255, 255, 153, 0)
                    : Colors.purple,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildContent(isDark),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () async {
            if (isFinalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Day is locked. Drag to ACTIVITY LOG to work on this as unplanned."),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            final selectedQuadrant = ref.read(selectedQuadrantProvider);
            // If quadrant selected, add directly
            if (selectedQuadrant != null) {
              try {
                final apiService = ref.read(taskApiServiceProvider);
                final userId = ref.read(currentUserIdProvider);
                final now = DateTime.now();
                final planDate =
                    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                await apiService.addItemToTodayPlan(
                  itemType: 'custom',
                  title: name,
                  planDate: planDate,
                  description: description,
                  plannedDurationMinutes: 30,
                  quadrant: selectedQuadrant,
                  userId: userId,
                );

                ref.invalidate(apiTodayPlanProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added "$name" to $selectedQuadrant'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add template: $e')),
                  );
                }
              }
            } else {
              // Show config modal if no quadrant selected -> Actually just add to inbox for now or TODO: Show modal
              // For now, mimicking previous behavior but with API
              try {
                final apiService = ref.read(taskApiServiceProvider);
                final now = DateTime.now();
                final planDate =
                    '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                await apiService.addItemToTodayPlan(
                  itemType: 'custom',
                  title: name,
                  planDate: planDate,
                  description: description,
                  plannedDurationMinutes: 30,
                  quadrant: 'inbox',
                );
                ref.invalidate(apiTodayPlanProvider);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add template: $e')),
                  );
                }
              }
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: _buildContent(isDark),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.drag_indicator,
            size: 18,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            size: 14,
            color: category == 'Routine' ? Colors.orange : Colors.purple,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ),
          Icon(
            Icons.add_circle_outline_rounded,
            size: 18,
            color: Colors.blue.shade500,
          ),
        ],
      ),
    );
  }
}

/// Card for catalog items from API (Course, Routine, Work)
class _CatalogItemCard extends ConsumerWidget {
  final CatalogModel catalogItem;

  const _CatalogItemCard({
    required this.catalogItem,
  });

  IconData _getIcon() {
    switch (catalogItem.catalogType) {
      case 'COURSE':
        return FontAwesomeIcons.graduationCap;
      case 'ROUTINE':
        return FontAwesomeIcons.mugHot;
      case 'CUSTOM':
      case 'PROJECT':
        return FontAwesomeIcons.briefcase;
      default:
        return FontAwesomeIcons.folder;
    }
  }

  Color _getColor() {
    switch (catalogItem.catalogType) {
      case 'COURSE':
        return Colors.purple;
      case 'ROUTINE':
        return Colors.orange;
      case 'CUSTOM':
      case 'PROJECT':
        return Colors.blue;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final activeSessionAsync =
        ref.watch(apiActiveSessionProvider(selectedDateStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final color = _getColor();

    final estimatedMinutes =
        (double.tryParse(catalogItem.estimatedHours) ?? 1.0) * 60;
    final dragData = {
      'source': 'catalog',
      'type': 'catalog_item',
      'catalog_id': parseTaskId(catalogItem.id),
      'name': catalogItem.name,
      'description': catalogItem.description,
      'duration': estimatedMinutes.clamp(15.0, 120.0),
    };

    return Draggable<Map<String, dynamic>>(
      data: dragData,
      maxSimultaneousDrags: isReadOnly ? 0 : 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getIcon(), size: 16, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  catalogItem.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildContent(isDark, color),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () async {
            if (isFinalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Day is locked. Drag to ACTIVITY LOG to work on this as unplanned."),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            final rawDuration =
                (double.tryParse(catalogItem.estimatedHours) ?? 1.0) * 60;
            final durationMinutes =
                (rawDuration > 0 ? rawDuration.toInt() : 60).clamp(15, 120);

            showDialog(
              context: context,
              builder: (context) => TaskConfigModal(
                initialTitle: catalogItem.name,
                initialDescription: catalogItem.description,
                initialDuration: durationMinutes,
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
                    final now = DateTime.now();
                    final planDate =
                        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                    await apiService.addItemToTodayPlan(
                      itemType: 'catalog',
                      catalogId: catalogItem.id,
                      planDate: planDate,
                      plannedDurationMinutes: duration,
                      description: description,
                      quadrant: quadrant ?? 'Q1',
                      userId: userId,
                    );
                    ref.invalidate(apiTodayPlanProvider);
                  } catch (e) {
                    debugPrint('Error adding catalog item: $e');
                  }
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: _buildContent(isDark, color),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Icon(_getIcon(), size: 14, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catalogItem.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (catalogItem.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      catalogItem.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.add_circle_outline, size: 18, color: Colors.blue.shade500),
        ],
      ),
    );
  }
}

/// Card for pending tasks from the Pending table
class _PendingTaskCard extends ConsumerWidget {
  final Map<String, dynamic> pendingItem;

  const _PendingTaskCard({
    required this.pendingItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final activeSessionAsync =
        ref.watch(apiActiveSessionProvider(selectedDateStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final isTodayInbox = pendingItem['is_today_inbox'] == true;

    final todayPlanDetails = isTodayInbox
        ? pendingItem
        : pendingItem['today_plan_details'] as Map<String, dynamic>?;

    final taskName = isTodayInbox
        ? (pendingItem['catalog_name'] ??
            pendingItem['custom_title'] ??
            'In-Progress Task')
        : (pendingItem['catalog_name'] as String? ??
            todayPlanDetails?['catalog_name'] as String? ??
            todayPlanDetails?['custom_title'] as String? ??
            'Pending Task');

    final minutesLeft = isTodayInbox
        ? (pendingItem['planned_duration_minutes'] as int? ?? 0)
        : (pendingItem['minutes_left'] as int? ?? 0);

    final reason = isTodayInbox
        ? (pendingItem['notes'] as String? ?? '')
        : (pendingItem['reason'] as String? ?? '');

    final originalDate = isTodayInbox
        ? (pendingItem['plan_date'] as String? ?? '')
        : (pendingItem['original_plan_date'] as String? ?? '');

    final catalogId = todayPlanDetails?['catalog_item'] as int?;
    final plannedDuration =
        todayPlanDetails?['planned_duration_minutes'] as int? ?? minutesLeft;

    final dragData = isTodayInbox
        ? {
            'type': 'pending_item',
            'is_today_inbox': true,
            'id': pendingItem['id'],
            'name': taskName,
            'description': reason,
            'duration': plannedDuration.clamp(15, 120),
            if (catalogId != null) 'catalog_id': parseTaskId(catalogId),
          }
        : {
            'source': 'catalog',
            'type': 'pending_item',
            'is_pending': true,
            'pending_id': pendingItem['id'],
            'id': pendingItem['id'],
            'name': taskName,
            'description': reason,
            'duration': minutesLeft.clamp(15, 120),
            if (catalogId != null) 'catalog_id': parseTaskId(catalogId),
          };

    return Draggable<Map<String, dynamic>>(
      data: dragData,
      maxSimultaneousDrags: isReadOnly ? 0 : 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.pending_actions, size: 16, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black87,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '${minutesLeft}m remaining',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildContent(
              isDark, taskName, minutesLeft, originalDate, reason),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () async {
            if (isFinalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Day is locked. Drag to ACTIVITY LOG to work on this as unplanned."),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }

            showDialog(
              context: context,
              builder: (context) => TaskConfigModal(
                initialTitle: taskName,
                initialDescription: reason.isNotEmpty ? reason : 'Replanned from $originalDate',
                initialDuration: (minutesLeft > 0 ? minutesLeft : plannedDuration).clamp(15, 120),
                onConfirm: ({
                  required String name,
                  required int duration,
                  String? description,
                  List<String>? selectedMilestoneIds,
                  String? quadrant,
                }) async {
                  try {
                    final apiService = ref.read(taskApiServiceProvider);

                    if (isTodayInbox) {
                      await apiService.updateTodayPlanItem(pendingItem['id'], {
                        'quadrant': quadrant ?? 'Q1',
                        'status': 'PLANNED',
                      });
                    } else {
                      final userId = ref.read(currentUserIdProvider);
                      final selectedDate = ref.read(selectedDateProvider);
                      final planDate =
                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

                      if (catalogId != null) {
                        await apiService.addItemToTodayPlan(
                          itemType: 'catalog',
                          catalogId: catalogId,
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
                      await apiService.deletePendingTask(pendingItem['id']);
                    }

                    ref.invalidate(apiTodayPlanProvider);
                    ref.invalidate(apiAllPendingItemsProvider);
                  } catch (e) {
                    debugPrint('Error adding pending task: $e');
                  }
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: _buildContent(
              isDark, taskName, minutesLeft, originalDate, reason),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, String taskName, int minutesLeft,
      String originalDate, String reason) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          const Icon(Icons.pending_actions, size: 14, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${minutesLeft}m left',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                    if (originalDate.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'from $originalDate',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                if (reason.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      reason,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.add_circle_outline,
              size: 18, color: Colors.orange.shade500),
        ],
      ),
    );
  }
}

/// Card for custom templates from database - matches system template style
class _CustomTemplateCard extends HookConsumerWidget {
  final ActivityTemplate template;

  const _CustomTemplateCard({
    required this.template,
  });

  // Get icon based on category
  IconData _getCategoryIcon() {
    switch (template.category.toLowerCase()) {
      case 'education':
        return FontAwesomeIcons.graduationCap;
      case 'routine':
        return FontAwesomeIcons.mugHot;
      case 'work':
        return FontAwesomeIcons.briefcase;
      case 'health':
        return FontAwesomeIcons.heartPulse;
      default:
        return FontAwesomeIcons.star;
    }
  }

  // Get color based on category
  Color _getCategoryColor() {
    switch (template.category.toLowerCase()) {
      case 'education':
        return Colors.purple;
      case 'routine':
        return Colors.orange;
      case 'work':
        return Colors.blue;
      case 'health':
        return Colors.green;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final activeSessionAsync =
        ref.watch(apiActiveSessionProvider(selectedDateStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);
    final categoryIcon = _getCategoryIcon();
    final categoryColor = _getCategoryColor();

    final dragData = {
      'source': 'catalog',
      'type': 'custom_template',
      'template_id': template.id,
      'name': template.name,
      'description': template.description ?? '',
      'duration': template.defaultDuration.clamp(15, 120),
    };

    return Draggable<Map<String, dynamic>>(
      data: dragData,
      maxSimultaneousDrags: isReadOnly ? 0 : 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: categoryColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                categoryIcon,
                size: 16,
                color: categoryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  template.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _buildContent(isDark, categoryIcon, categoryColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () async {
            if (isFinalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Day is locked. Drag to ACTIVITY LOG to work on this as unplanned."),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            showDialog(
              context: context,
              builder: (context) => TaskConfigModal(
                initialTitle: template.name,
                initialDescription: template.description,
                initialDuration: template.defaultDuration.clamp(15, 120),
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

                    await apiService.addItemToTodayPlan(
                      itemType: 'custom',
                      title: name,
                      planDate: planDate,
                      description: description,
                      plannedDurationMinutes: duration,
                      quadrant: quadrant ?? 'Q1',
                      userId: userId,
                    );
                    ref.invalidate(apiTodayPlanProvider);
                  } catch (e) {
                    debugPrint('Error adding custom template: $e');
                  }
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: _buildContent(isDark, categoryIcon, categoryColor),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.drag_indicator,
            size: 18,
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade300,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              template.name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ),
          Icon(
            Icons.add_circle_outline_rounded,
            size: 18,
            color: Colors.blue.shade500,
          ),
        ],
      ),
    );
  }
}

/// Card for catalog tasks (from /catalog-tasks/ endpoint)
class _CatalogTaskCard extends ConsumerWidget {
  final TaskModel task;

  const _CatalogTaskCard({
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedDateStr =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final activeSessionAsync =
        ref.watch(apiActiveSessionProvider(selectedDateStr));
    final isFinalized = activeSessionAsync.valueOrNull != null;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReadOnly = ref.watch(isReadOnlyProvider);

    final dragData = {
      'source': 'catalog',
      'type': 'catalog_task',
      'name': task.title,
      'description': '', // TaskModel doesn't have description field
      'duration': 30, // Default 30 minutes for tasks
      'task_id': task.id,
    };

    return Draggable<Map<String, dynamic>>(
      data: dragData,
      maxSimultaneousDrags: isReadOnly ? 0 : 1,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue.shade400,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.task_alt, size: 16, color: Colors.blue.shade400),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildContent(isDark),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            if (isFinalized) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Can't add - day has been started."),
                  backgroundColor: Colors.orange,
                ),
              );
              return;
            }
            showDialog(
              context: context,
              builder: (context) => TaskConfigModal(
                initialTitle: task.title,
                initialDuration: 30,
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

                    await apiService.addItemToTodayPlan(
                      itemType: 'custom',
                      title: name,
                      planDate: planDate,
                      description: description,
                      plannedDurationMinutes: duration,
                      quadrant: quadrant ?? 'Q1',
                      relatedTaskId: task.id,
                      userId: userId,
                    );
                    ref.invalidate(apiTodayPlanProvider);
                  } catch (e) {
                    debugPrint('Error adding catalog task: $e');
                  }
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: _buildContent(isDark),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    String deadlineStr = '';
    try {
      final date = task.dueDate;
      deadlineStr =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.drag_indicator, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Icon(Icons.task_alt, size: 14, color: Colors.blue.shade400),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.projectName != null || deadlineStr.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        if (task.projectName != null)
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Project: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: task.projectName),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        if (deadlineStr.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined,
                                    size: 10,
                                    color: isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  deadlineStr,
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: isDark
                                        ? Colors.grey.shade500
                                        : Colors.grey.shade400,
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
