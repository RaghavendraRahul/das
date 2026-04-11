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
                      color: Colors.grey.withValues(alpha: 0.5),
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
                          show: true,
                          color: Colors.green.withValues(alpha: 0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
