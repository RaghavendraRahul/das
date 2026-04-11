import 'dart:math';
import 'package:flutter/material.dart';

/// Circular progress indicator matching React's CircularProgress component
class CircularProgressWidget extends StatelessWidget {
  final double progress; // 0-100
  final double size;
  final double strokeWidth;
  final bool showText;
  final Color? color;
  final Color? backgroundColor;

  const CircularProgressWidget({
    super.key,
    required this.progress,
    this.size = 48,
    this.strokeWidth = 4,
    this.showText = true,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Determine color based on progress
    final progressColor = color ?? _getProgressColor(progress);
    final bgColor = backgroundColor ??
        (isDark ? const Color(0xFF374151) : Colors.grey.shade200);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _CircleProgressPainter(
              progress: 100,
              strokeWidth: strokeWidth,
              color: bgColor,
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: _CircleProgressPainter(
              progress: progress.clamp(0, 100),
              strokeWidth: strokeWidth,
              color: progressColor,
            ),
          ),
          // Center text
          if (showText)
            Text(
              '${progress.round()}%',
              style: TextStyle(
                fontSize: size * 0.22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey.shade800,
              ),
            ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 100) return Colors.green;
    if (progress >= 75) return Colors.blue;
    if (progress >= 50) return Colors.orange;
    return Colors.red;
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _CircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (-90 degrees) clockwise
    final sweepAngle = (progress / 100) * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      strokeWidth != oldDelegate.strokeWidth ||
      color != oldDelegate.color;
}
