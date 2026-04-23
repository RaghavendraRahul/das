import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:project_pm/src/features/dashboard/daily_performance_providers.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DailyExecutionRingsCard extends HookConsumerWidget {
  const DailyExecutionRingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // State for the selected date
    final selectedDate = useState<DateTime>(DateTime.now());
    final isToday = DateFormat('yyyy-MM-dd').format(selectedDate.value) == 
                    DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    // Watch performance data for the selected date
    // Note: If today, we pass null to use the default live endpoint
    final performanceAsync = ref.watch(dailyPerformanceProvider(
      date: isToday ? null : DateFormat('yyyy-MM-dd').format(selectedDate.value)
    ));

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, // Background managed by _SectionCard wrapper
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF05263E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF05263E).withValues(alpha: 0.1)),
                    ),
                    child: Icon(
                      Icons.analytics_outlined,
                      size: 18,
                      color: isDark ? const Color(0xFF7EC8F4) : const Color(0xFF05263E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Daily Execution Analytics',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: isDark ? const Color(0xFFB0DFFF) : const Color(0xFF05263E),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Date Picker Icon
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: isDark 
                            ? const ColorScheme.dark(primary: Colors.blue)
                            : const ColorScheme.light(primary: Colors.blue),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    selectedDate.value = picked;
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isToday 
                        ? Colors.transparent 
                        : const Color(0xFF05263E).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isToday 
                          ? (isDark ? Colors.white12 : Colors.grey.shade200)
                          : const Color(0xFF05263E).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: isToday 
                            ? (isDark ? Colors.white54 : const Color(0xFF05263E))
                            : (isDark ? Colors.white70 : const Color(0xFF05263E)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isToday ? 'Today' : DateFormat('dd MMM').format(selectedDate.value),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isToday 
                            ? (isDark ? Colors.white70 : const Color(0xFF05263E))
                            : (isDark ? Colors.white : const Color(0xFF05263E)),
                        ),
                      ),
                      if (!isToday) ...[
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => selectedDate.value = DateTime.now(),
                          child: const Icon(Icons.close, size: 14, color: Colors.blue),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          performanceAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: Text('Error: ${e.toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red.shade300, fontSize: 13)),
              ),
            ),
            data: (data) => _ActivityRingsBody(data: data),
          ),
        ],
      ),
    );
  }
}

class _ActivityRingsBody extends StatefulWidget {
  final DailyPerformanceData data;

  const _ActivityRingsBody({required this.data});

  @override
  State<_ActivityRingsBody> createState() => _ActivityRingsBodyState();
}

class _ActivityRingsBodyState extends State<_ActivityRingsBody> {
  String? selectedCategory; // 'COMPLETED', 'PLANNED', 'UNPLANNED'

  List<PerformanceTaskData> _getFilteredTasks() {
    if (selectedCategory == null) return [];
    if (selectedCategory == 'COMPLETED') {
      return widget.data.tasks.where((t) => t.status == 'COMPLETED' || t.status == 'DONE').toList();
    } else if (selectedCategory == 'UNPLANNED') {
      return widget.data.tasks.where((t) => t.isUnplanned).toList();
    } else if (selectedCategory == 'PLANNED') {
      return widget.data.tasks.where((t) => !t.isUnplanned).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = widget.data;

    int plannedTasks = data.plannedSummary.plannedTasksCount;
    int completedTasks = data.actualSummary.completedPlannedCount;
    int unplannedTasks = data.actualSummary.completedUnplannedCount;

    int totalVolume = plannedTasks + unplannedTasks;
    if (totalVolume == 0) totalVolume = 1;

    double unplannedRatio = (unplannedTasks / totalVolume).clamp(0.0, 1.0);
    double plannedRatio = (plannedTasks / totalVolume).clamp(0.0, 1.0);
    double completionRatio = data.metrics.taskCompletionRate / 100.0;

    final filteredTasks = _getFilteredTasks();

    return SizedBox(
      height: 240,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. The Rings Graphic
          SizedBox(
            width: 180,
            child: Center(
              child: SizedBox(
                width: 170,
                height: 170,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Tooltip(
                      message: 'Completed',
                      child: _AnimatedRing(
                        radius: 170,
                        color: const Color(0xFF4FD1C5), // Achieved - Teal
                        value: completionRatio,
                        strokeWidth: 15,
                      ),
                    ),
                    Tooltip(
                      message: 'Planned Work',
                      child: _AnimatedRing(
                        radius: 130,
                        color: const Color(0xFF4299E1), // Planned - Blue
                        value: plannedRatio,
                        strokeWidth: 15,
                      ),
                    ),
                    Tooltip(
                      message: 'Unplanned',
                      child: _AnimatedRing(
                        radius: 90,
                        color: const Color(0xFF9F7AEA), // Remaining - Purple
                        value: unplannedRatio,
                        strokeWidth: 15,
                      ),
                    ),
                  ],
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
              ),
            ),
          ),
          
          // 2. The Legend & KPIs
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendRow(
                      color: const Color(0xFF4FD1C5),
                      title: 'Completed',
                      subtitle: 'vs Planned Daily Goal',
                      value: '$completedTasks / $plannedTasks',
                      isDark: isDark,
                      isSelected: selectedCategory == 'COMPLETED',
                      onTap: () => setState(() => selectedCategory = selectedCategory == 'COMPLETED' ? null : 'COMPLETED'),
                    ),
                    const SizedBox(height: 12),
                    _LegendRow(
                      color: const Color(0xFF4299E1),
                      title: 'Planned Work',
                      subtitle: "Added to Today's Plan",
                      value: '$plannedTasks tasks',
                      isDark: isDark,
                      isSelected: selectedCategory == 'PLANNED',
                      onTap: () => setState(() => selectedCategory = selectedCategory == 'PLANNED' ? null : 'PLANNED'),
                    ),
                    const SizedBox(height: 12),
                    _LegendRow(
                      color: const Color(0xFF9F7AEA),
                      title: 'Unplanned',
                      subtitle: 'Dragged into Activity',
                      value: '$unplannedTasks tasks',
                      isDark: isDark,
                      isSelected: selectedCategory == 'UNPLANNED',
                      onTap: () => setState(() => selectedCategory = selectedCategory == 'UNPLANNED' ? null : 'UNPLANNED'),
                    ),
                    const SizedBox(height: 16),
                    // Micro Status Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F1E35) : const Color(0xFFF0F5FB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.grey.shade200,
                        )
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            data.metrics.taskCompletionRate > 80 
                                ? Icons.trending_up 
                                : Icons.trending_down,
                            size: 16,
                            color: data.metrics.taskCompletionRate > 80 
                                ? Colors.green 
                                : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Efficiency: ${data.metrics.timeEfficiencyPercentage.toStringAsFixed(0)}%',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // 3. Drill-down Items section
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.black.withValues(alpha: 0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                )
              ),
              child: selectedCategory == null
                  ? Center(
                      child: Text(
                        'Tap a legend to view related tasks',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    )
                  : filteredTasks.isEmpty
                      ? Center(
                          child: Text(
                            'No tasks in this category',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF374151) : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isDark ? Colors.white10 : Colors.black12,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      task.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    task.status == 'COMPLETED' || task.status == 'DONE' ? 'Done' : 'Pending',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: task.status == 'COMPLETED' || task.status == 'DONE' 
                                        ? Colors.teal
                                        : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).animate().fadeIn(duration: 300.ms),
            ),
          ),
      ],
      ),
    );
  }
}

class _AnimatedRing extends StatelessWidget {
  final double radius;
  final Color color;
  final double value;
  final double strokeWidth;

  const _AnimatedRing({
    required this.radius,
    required this.color,
    required this.value,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: radius,
      height: radius,
      child: Transform.rotate(
        angle: 0, // Starts at 12 o'clock due to CircularProgressIndicator mechanics? Actually it starts at 12 anyway
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background track
            CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              color: isDark ? color.withValues(alpha: 0.15) : color.withValues(alpha: 0.1),
            ),
            // Foreground animated fill
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: value),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCirc,
              builder: (context, val, _) {
                return CircularProgressIndicator(
                  value: val,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round, // Apple style round ends
                  color: color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String value;
  final bool isDark;
  final bool isSelected;
  final VoidCallback? onTap;

  const _LegendRow({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isDark,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withValues(alpha: isDark ? 0.2 : 0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.5) : Colors.transparent,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0D1B2A),
                        ),
                      ),
                      Text(
                        value,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFB0C8E0) : const Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFB0C8E0) : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
