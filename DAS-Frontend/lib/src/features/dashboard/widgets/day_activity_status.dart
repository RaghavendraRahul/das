import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:project_pm/src/features/dashboard/dashboard_providers.dart';

class DayActivityStatus extends ConsumerWidget {
  const DayActivityStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(dashboardMetricsProvider);

    return metricsAsync.when(
      data: (metrics) {
        final stats = metrics.teamStats;
        if (stats == null || stats.totalUsers == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Team Activity Status",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Daily Capacity Target: 9 Hours",
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        "No team data available",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Add users and daily logs to see activity",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final total = stats.totalUsers;
        final filledCount = stats.filledCount;
        final notFilledCount = stats.notFilledCount;
        final filledPercent = total > 0 ? (filledCount / total * 100) : 0.0;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Team Activity Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Daily Capacity Target: 9 Hours",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Use vertical layout if width is too narrow
                    final useVerticalLayout = constraints.maxWidth < 300;

                    if (useVerticalLayout) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Activity Chart
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections: [
                                        PieChartSectionData(
                                            color: Colors.green,
                                            value: filledCount.toDouble(),
                                            radius: 12,
                                            showTitle: false),
                                        PieChartSectionData(
                                            color: Colors.orange,
                                            value: notFilledCount.toDouble(),
                                            radius: 12,
                                            showTitle: false),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("$total",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        const Text("Users",
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Legend
                            _LegendItem(
                                color: Colors.green,
                                label: "Filled",
                                count: filledCount,
                                percent: "${filledPercent.toInt()}%"),
                            const SizedBox(height: 6),
                            _LegendItem(
                                color: Colors.orange,
                                label: "Not Filled",
                                count: notFilledCount,
                                percent: "${(100 - filledPercent).toInt()}%"),
                          ],
                        ),
                      );
                    }

                    return Row(
                      children: [
                        // Activity Chart
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            children: [
                              PieChart(
                                PieChartData(
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 50,
                                  sections: [
                                    PieChartSectionData(
                                        color: Colors.green,
                                        value: filledCount.toDouble(),
                                        radius: 15,
                                        showTitle: false),
                                    PieChartSectionData(
                                        color: Colors.orange,
                                        value: notFilledCount.toDouble(),
                                        radius: 15,
                                        showTitle: false),
                                  ],
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("$total",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    const Text("Users",
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Legend
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LegendItem(
                                  color: Colors.green,
                                  label: "Filled (≥ 9h)",
                                  count: filledCount,
                                  percent: "${filledPercent.toInt()}%"),
                              const SizedBox(height: 8),
                              _LegendItem(
                                  color: Colors.orange,
                                  label: "Not Filled (< 9h)",
                                  count: notFilledCount,
                                  percent: "${(100 - filledPercent).toInt()}%"),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final String percent;

  const _LegendItem(
      {required this.color,
      required this.label,
      required this.count,
      required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(backgroundColor: color, radius: 4),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text("$count",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12, color: color)),
          const SizedBox(width: 2),
          Text(percent,
              style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }
}
