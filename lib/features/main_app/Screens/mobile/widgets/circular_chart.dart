import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularChartWidget extends StatelessWidget {
  final double progress;
  final Color color;
  final String label;
  final double radius;
  final Color? text_color;

  const CircularChartWidget({
    Key? key,
    required this.progress,
    required this.color,
    required this.label,
    required this.radius,
    this.text_color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius,
      height: radius,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: CirclePainter(progress: progress, color: color),
            ),
          ),
          Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16.0.w,
                fontWeight: FontWeight.bold,
                color: text_color ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  CirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0; // Adjust the strokeWidth as desired

    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0.w; // Adjust the strokeWidth as desired

    final startAngle = -pi / 2;
    final sweepAngle = progress * 2 * pi; // Adjust the sweep angle to fill the circle

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
