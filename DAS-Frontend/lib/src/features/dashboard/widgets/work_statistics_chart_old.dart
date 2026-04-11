import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_pm/src/core/database/database.dart';
import 'package:project_pm/src/core/models/project_with_tasks.dart';

class WorkStatisticsChart extends StatefulWidget {
  final List<ProjectWithTasks> projects;
  final String? selectedStatus;
  final Function(String?)? onStatusSelected;

  const WorkStatisticsChart({
    super.key,
    required this.projects,
    this.selectedStatus,
    this.onStatusSelected,
  });

  @override
  State<WorkStatisticsChart> createState() => _WorkStatisticsChartState();
}

class _WorkStatisticsChartState extends State<WorkStatisticsChart> {
  int touchedIndex = -1;
  User? selectedUser;

  @override
  void didUpdateWidget(WorkStatisticsChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projects != widget.projects) {
      // Reset or re-validate selected user if projects change
    }
  }

  List<User> _getUsers() {
    final users = <String, User>{};
    for (var project in widget.projects) {
      for (var task in project.tasks) {
        for (var assignee in task.assignees) {
          users[assignee.id] = assignee;
        }
      }
    }
    return users.values.toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Widget build(BuildContext context) {
    final users = _getUsers();

    // Default to first user if none selected, or keep selected if valid
    if (users.isNotEmpty &&
        (selectedUser == null || !users.contains(selectedUser))) {
      // Try to find a user that matches current selectedUser id if possible, otherwise first
      try {
        if (selectedUser != null) {
          selectedUser = users.firstWhere((u) => u.id == selectedUser!.id);
        } else {
          selectedUser = users.first;
        }
      } catch (_) {
        selectedUser = users.first;
      }
    }

    // Calculate stats for selected user by PROJECT
    final Map<String, int> projectCounts = {};
    final Map<String, Color> projectColors = {};
    int totalTasks = 0;

    // Define a palette for projects
    final List<Color> palette = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
    ];

    if (selectedUser != null) {
      int colorIndex = 0;
      for (var p in widget.projects) {
        final userTasks = p.tasks
            .where((t) => t.assignees.any((u) => u.id == selectedUser!.id));

        if (userTasks.isNotEmpty) {
          projectCounts[p.project.name] = userTasks.length;
          // Assign stable color based on project hash or simple index
          projectColors[p.project.name] = palette[colorIndex % palette.length];
          colorIndex++;
          totalTasks += userTasks.length;
        }
      }
    }

    final isAdmin = selectedUser?.role.toLowerCase() == 'admin';

    // Admin View Logic: Show 100% Total (Only if no tasks, otherwise treat as normal user)
    // The user previously requested specific Admin view, but now wants project breakdown.
    // If Admin has NO tasks, show the placeholder. If they have tasks, show the breakdown.
    if (isAdmin && totalTasks == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(users),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        color: Colors.grey.shade100,
                        value: 100,
                        title: '',
                        radius: 50,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "100%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "TOTAL",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
              child: Text("No tasks assigned to this user.",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12))),
        ],
      );
    }

    // Normal User View (or Admin with tasks)
    if (totalTasks == 0) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildHeader(users),
        const Spacer(),
        const Center(child: Text("No tasks found")),
        const Spacer(),
      ]);
    }

    // Convert map to list for iteration (ensure consistent order)
    final projectStats = projectCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort by count desc

    return Column(
      children: [
        _buildHeader(users),
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        setState(() {
                          touchedIndex = -1;
                        });
                        return;
                      }
                      setState(() {
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: _buildChartSections(
                      projectStats, projectColors, totalTasks),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      touchedIndex == -1 || touchedIndex >= projectStats.length
                          ? "100%"
                          : "${((projectStats[touchedIndex].value / totalTasks) * 100).toInt()}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        touchedIndex == -1 ||
                                touchedIndex >= projectStats.length
                            ? "Total"
                            : projectStats[touchedIndex].key,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Legend Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("PROJECT",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              Row(
                children: [
                  Text("TASKS", // Changed from HOURS as we are counting tasks
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  SizedBox(width: 24),
                  Text("%",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: projectStats.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final entry = projectStats[index];
              return _LegendRow(
                color: projectColors[entry.key]!,
                label: entry.key,
                count: entry.value,
                total: totalTasks,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(List<User> users) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Project Work Stats",
                style: TextStyle(fontWeight: FontWeight.bold)),
            if (selectedUser != null)
              Text("Member: ${selectedUser!.name}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        if (users.isNotEmpty)
          DropdownButtonHideUnderline(
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton<User>(
                value: selectedUser,
                icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                onChanged: (User? newValue) {
                  setState(() {
                    selectedUser = newValue;
                  });
                },
                items: users.map<DropdownMenuItem<User>>((User user) {
                  return DropdownMenuItem<User>(
                    value: user,
                    child: Text(user.name),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  List<PieChartSectionData> _buildChartSections(
      List<MapEntry<String, int>> stats, Map<String, Color> colors, int total) {
    return List.generate(stats.length, (i) {
      final isTouched = i == touchedIndex;
      final entry = stats[i];
      final radius = isTouched ? 50.0 : 40.0;

      return PieChartSectionData(
        color: colors[entry.key],
        value: entry.value.toDouble(),
        title: '',
        showTitle: false,
        radius: radius,
      );
    });
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int total;

  const _LegendRow(
      {required this.color,
      required this.label,
      required this.count,
      required this.total});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    final percent = (count / total * 100).toInt();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, color: color),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
            label,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          )),
          const SizedBox(width: 8),
          Text("$count",
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 24),
          SizedBox(
            width: 32,
            child: Text("$percent%",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
