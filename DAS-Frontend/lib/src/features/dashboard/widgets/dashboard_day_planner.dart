import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/features/today/today_providers.dart';
import 'package:project_pm/src/routes/app_router.dart';

class DashboardDayPlanner extends ConsumerWidget {
  const DashboardDayPlanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final todayLogAsync = ref.watch(todayLogProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0B1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () {
          context.router.navigate(const TodayRoute());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Planner',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color:
                              isDark ? Colors.white : const Color(0xFF05263E),
                        ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              todayLogAsync.when(
                data: (data) {
                  if (data == null) {
                    return const Center(
                        child: Text("No plan for today. Tap to start."));
                  }
                  final items = data.plannedItems;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // 2x2 Grid
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _DashboardQuadrantBox(
                                  title: 'Start First',
                                  color: Colors.red,
                                  items: items
                                      .where((i) => i.quadrant == 'q1')
                                      .toList(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _DashboardQuadrantBox(
                                  title: 'Schedule',
                                  color: isDark
                                      ? Colors.blue.shade400
                                      : const Color(0xFF05263E),
                                  items: items
                                      .where((i) => i.quadrant == 'q2')
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _DashboardQuadrantBox(
                                  title: 'Delegate',
                                  color: Colors.orange,
                                  items: items
                                      .where((i) => i.quadrant == 'q3')
                                      .toList(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _DashboardQuadrantBox(
                                  title: 'Routine',
                                  color: Colors.green,
                                  items: items
                                      .where((i) => i.quadrant == 'q4')
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error: $err'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardQuadrantBox extends StatelessWidget {
  final String title;
  final Color color;
  final List<PlannedItem> items;

  const _DashboardQuadrantBox({
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 140, // Fixed height for square-ish look
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "Empty",
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.take(3).length, // Show max 3 items
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isDark ? Colors.grey.shade300 : Colors.black87,
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          if (items.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "+ ${items.length - 3} more",
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
