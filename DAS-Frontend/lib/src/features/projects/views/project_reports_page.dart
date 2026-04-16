import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';
import 'package:project_pm/src/features/projects/project_providers.dart';

@RoutePage()
class ProjectReportsPage extends HookConsumerWidget {
  const ProjectReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectAsync = ref.watch(currentProjectProvider);

    return Scaffold(
      body: projectAsync.when(
        data: (project) {
          if (project == null) {
            return const Center(child: Text("Project not found"));
          }
          return _ReportsView(project: project);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _ReportsView extends StatelessWidget {
  final ProjectWithTasks project;
  const _ReportsView({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Status metrics
    final totalTasks = project.tasks.length;
    final completed = project.tasks.where((t) => t.progress >= 100).length;
    final inProgress =
        project.tasks.where((t) => t.progress > 0 && t.progress < 100).length;
    final todo = totalTasks - completed - inProgress;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined,
                  size: 28, color: Colors.blue),
              const SizedBox(width: 12),
              Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    final allProjectsAsync =
                        ref.watch(projectsWithTasksProvider);
                    final allProjects = allProjectsAsync.valueOrNull ?? [];

                    if (allProjects.length <= 1) {
                      return Text(
                        project.project.name.toUpperCase(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    }

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: project.project.id,
                        isDense: true,
                        isExpanded: false,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 24),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.headlineMedium?.color,
                        ),
                        items: allProjects.map((p) {
                          return DropdownMenuItem<String>(
                            value: p.project.id,
                            child: Text(p.project.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (newId) {
                          if (newId != null) {
                            ref.read(selectedProjectIdProvider.notifier).state =
                                newId;
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 1: Status Distribution & Velocity (Mock)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ChartCard(
                  title: "Task Status Distribution",
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: completed.toDouble(),
                            title: '$completed',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.blue,
                            value: inProgress.toDouble(),
                            title: '$inProgress',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.grey,
                            value: todo.toDouble(),
                            title: '$todo',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ChartCard(
                  title: "Team Velocity (Last 4 Weeks)",
                  child: AspectRatio(
                    aspectRatio: 1.6,
                    child: BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 30)),
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (val, meta) {
                                    switch (val.toInt()) {
                                      case 0:
                                        return const Text('W1');
                                      case 1:
                                        return const Text('W2');
                                      case 2:
                                        return const Text('W3');
                                      case 3:
                                        return const Text('W4');
                                    }
                                    return const Text('');
                                  })),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          // Mock data for velocity
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(
                                toY: 5, color: Colors.purple.shade300)
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(
                                toY: 8, color: Colors.purple.shade300)
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(
                                toY: 6, color: Colors.purple.shade300)
                          ]),
                          BarChartGroupData(x: 3, barRods: [
                            BarChartRodData(
                                toY: 10, color: Colors.purple.shade300)
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Row 2: Burndown (Mock linear for MVP)
          _ChartCard(
            title: "Burnup Chart (Projected vs Actual)",
            child: AspectRatio(
              aspectRatio: 2.5,
              child: LineChart(
                LineChartData(
                  gridData:
                      const FlGridData(show: true, drawVerticalLine: true),
                  titlesData: const FlTitlesData(
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.shade200)),
                  lineBarsData: [
                    // Ideal Line
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 0),
                        FlSpot(10, totalTasks.toDouble()),
                      ],
                      isCurved: false,
                      color: Colors.grey.withOpacity(0.5),
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      dashArray: [5, 5],
                    ),
                    // Actual Line (Mock progress)
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 0),
                        const FlSpot(2, 2),
                        const FlSpot(4, 5),
                        FlSpot(6, completed.toDouble()),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                          show: true, color: Colors.green.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Project Analytics Hours Breakdown
          const _ProjectAnalyticsSection(),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// Project Analytics Hours breakdown with cascading project/employee filters
class _ProjectAnalyticsSection extends HookConsumerWidget {
  const _ProjectAnalyticsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsDataProvider);
    final selectedProjectId = ref.watch(selectedAnalyticsProjectIdProvider);
    final selectedEmployeeId = ref.watch(selectedAnalyticsEmployeeIdProvider);
    final theme = Theme.of(context);

    return analyticsAsync.when(
      data: (analyticsData) {
        debugPrint('═' * 60);
        debugPrint('📊 ANALYTICS DATA RECEIVED FROM API');
        debugPrint('═' * 60);
        debugPrint('Raw data keys: ${analyticsData.keys.toList()}');

        // Extract dropdowns - it's a dict with 'projects' and 'employees' keys
        final dropdowns =
            (analyticsData['dropdowns'] as Map<String, dynamic>?) ?? {};

        debugPrint('Dropdowns type: ${dropdowns.runtimeType}');
        debugPrint('Dropdowns keys: ${dropdowns.keys.toList()}');

        final projects = (dropdowns['projects'] as List<dynamic>?) ?? [];
        debugPrint('✅ Projects from API: ${projects.length}');
        for (var p in projects) {
          final name = (p as Map)['name'] ?? 'Unknown';
          debugPrint('   - Project: $name (id: ${p['id']})');
        }

        // All employees from the API response
        final allEmployeesFromApi =
            (dropdowns['employees'] as List<dynamic>?) ?? [];
        debugPrint('✅ All employees from API: ${allEmployeesFromApi.length}');
        for (var e in allEmployeesFromApi) {
          final name = (e as Map)['name'] ?? 'Unknown';
          debugPrint('   - Employee: $name (id: ${e['id']})');
        }

        // Only show employees if a project has been selected
        // Otherwise, pass empty list to show placeholder message
        final filteredEmployees =
            selectedProjectId != null ? allEmployeesFromApi : [];

        debugPrint('Filtered employees shown: ${filteredEmployees.length}');
        debugPrint('Selected projectId: $selectedProjectId');
        debugPrint('Selected employeeId: $selectedEmployeeId');

        final tasks = (analyticsData['tasks'] as List<dynamic>?) ?? [];
        final totals = (analyticsData['totals'] as Map<String, dynamic>?) ??
            {
              'planned_hours': 0,
              'achieved_hours': 0,
            };
        final isEmployeeLocked =
            analyticsData['is_employee_locked'] as bool? ?? false;

        final plannedHours = (totals['planned_hours'] as num?)?.toDouble() ?? 0;
        final achievedHours =
            (totals['achieved_hours'] as num?)?.toDouble() ?? 0;

        debugPrint('═' * 60);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Project Hours Analytics',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ChartCard(
              title: "Hours Breakdown by Task",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters
                  Row(
                    children: [
                      Expanded(
                        child: _ProjectDropdown(
                          projects: projects,
                          selectedId: selectedProjectId,
                          onChanged: (projectId) {
                            debugPrint(
                                '📌 Project selected: $projectId (previously was $selectedProjectId)');
                            // Reset employee FIRST when project changes
                            ref
                                .read(selectedAnalyticsEmployeeIdProvider
                                    .notifier)
                                .state = null;
                            // Set new project state
                            ref
                                .read(
                                    selectedAnalyticsProjectIdProvider.notifier)
                                .state = projectId;
                            // Invalidate AFTER setting state so the new values are read
                            Future.microtask(() {
                              ref.invalidate(analyticsDataProvider);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _EmployeeDropdown(
                          employees: filteredEmployees,
                          selectedId: selectedEmployeeId,
                          isLocked: isEmployeeLocked,
                          projectSelected: selectedProjectId != null,
                          onChanged: (employeeId) {
                            debugPrint(
                                '👤 Employee selected: $employeeId (project filter: $selectedProjectId)');
                            // Set state FIRST, then invalidate
                            ref
                                .read(selectedAnalyticsEmployeeIdProvider
                                    .notifier)
                                .state = employeeId;
                            // Invalidate AFTER setting state so the new values are read
                            Future.microtask(() {
                              ref.invalidate(analyticsDataProvider);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Doughnut Chart
                  if (tasks.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: _buildTaskSections(tasks),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: Text(
                        'No tasks available for selected filters',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Totals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _TotalCard(
                        label: 'Planned Hours',
                        value: plannedHours.toStringAsFixed(1),
                        color: Colors.blue,
                      ),
                      _TotalCard(
                        label: 'Achieved Hours',
                        value: achievedHours.toStringAsFixed(1),
                        color: Colors.green,
                      ),
                      _TotalCard(
                        label: 'Remaining',
                        value:
                            (plannedHours - achievedHours).toStringAsFixed(1),
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const _ChartCard(
        title: "Hours Breakdown by Task",
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => _ChartCard(
        title: "Hours Breakdown by Task",
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Error loading analytics: $err'),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildTaskSections(List<dynamic> tasks) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return List.generate(
      tasks.length,
      (index) {
        final task = tasks[index] as Map<String, dynamic>;
        final title = task['title']?.toString() ?? 'Task ${index + 1}';
        final plannedHours = (task['planned_hours'] as num?)?.toDouble() ?? 0;

        return PieChartSectionData(
          color: colors[index % colors.length],
          value: plannedHours > 0 ? plannedHours : 1,
          title: title.length > 10 ? '${title.substring(0, 10)}...' : title,
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

/// Project dropdown for analytics filter
class _ProjectDropdown extends StatelessWidget {
  final List<dynamic> projects;
  final int? selectedId;
  final Function(int?) onChanged;

  const _ProjectDropdown({
    required this.projects,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int?>(
          initialValue: selectedId,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          hint: const Text('Select project...'),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('All Projects'),
            ),
            ...projects.map<DropdownMenuItem<int?>>((p) {
              final project = p as Map<String, dynamic>;
              final id = project['id'] as int?;
              final name = project['name']?.toString() ?? 'Unknown';
              return DropdownMenuItem<int?>(
                value: id,
                child: Text(name),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Employee dropdown for analytics filter (cascading based on project)
class _EmployeeDropdown extends StatelessWidget {
  final List<dynamic> employees;
  final int? selectedId;
  final bool isLocked;
  final bool projectSelected;
  final Function(int?) onChanged;

  const _EmployeeDropdown({
    required this.employees,
    required this.selectedId,
    required this.isLocked,
    required this.projectSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Member',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final isEnabled =
                !isLocked && projectSelected && employees.isNotEmpty;

            return DropdownButtonFormField<int?>(
              initialValue: selectedId,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: !projectSelected || isLocked || employees.isEmpty
                        ? Colors.grey.shade200
                        : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              hint: Text(isLocked
                  ? 'You can only view your own hours'
                  : !projectSelected
                      ? 'Select a project first'
                      : employees.isEmpty
                          ? 'No team members in this project'
                          : 'Select team member...'),
              items: [
                if (projectSelected && !isLocked)
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('All Team Members'),
                  ),
                ...employees.map<DropdownMenuItem<int?>>((emp) {
                  final employee = emp as Map<String, dynamic>;
                  final id = employee['id'] as int?;
                  final name = employee['name']?.toString() ?? 'Unknown';
                  return DropdownMenuItem<int?>(
                    value: id,
                    child: Text(name),
                  );
                }),
              ],
              onChanged: isEnabled ? onChanged : null,
            );
          },
        ),
      ],
    );
  }
}

/// Total hours display card
class _TotalCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TotalCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
