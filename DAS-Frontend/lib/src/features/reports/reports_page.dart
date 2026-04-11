import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';

@RoutePage()
class ReportsPage extends HookConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(dashboardProjectsProvider);

    return Scaffold(
      body: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
            return const Center(child: Text("No projects data available"));
          }

          // Portfolio Health: Status counts
          final active = projects.where((p) => p.isActive).length;
          final completed = projects.where((p) => p.isCompleted).length;
          final other = projects.length - active - completed;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Global Reports",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 32),

                // Portfolio Health
                _ChartCard(
                  title: "Portfolio Health (Projects by Status)",
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                              color: Colors.blue,
                              value: active.toDouble(),
                              title: "Active ($active)",
                              radius: 60,
                              titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          PieChartSectionData(
                              color: Colors.green,
                              value: completed.toDouble(),
                              title: "Done ($completed)",
                              radius: 60,
                              titleStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          if (other > 0)
                            PieChartSectionData(
                                color: Colors.grey,
                                value: other.toDouble(),
                                title: "Other ($other)",
                                radius: 60,
                                titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                        ],
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Resource Allocation (Mock)
                _ChartCard(
                  title: "Resource Allocation (Tasks per User)",
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [
                            BarChartRodData(toY: 5, color: Colors.orange)
                          ]),
                          BarChartGroupData(x: 1, barRods: [
                            BarChartRodData(toY: 8, color: Colors.orange)
                          ]),
                          BarChartGroupData(x: 2, barRods: [
                            BarChartRodData(toY: 3, color: Colors.orange)
                          ]),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (val, meta) {
                                    switch (val.toInt()) {
                                      case 0:
                                        return const Text("Alice");
                                      case 1:
                                        return const Text("Bob");
                                      case 2:
                                        return const Text("Charlie");
                                    }
                                    return const Text("");
                                  })),
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 30)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
