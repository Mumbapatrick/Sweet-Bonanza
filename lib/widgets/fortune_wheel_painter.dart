// lib/widgets/fortune_wheel_painter.dart

import 'dart:math';
import 'package:flutter/material.dart';

class FortuneWheelPainter extends CustomPainter {
  final List<Map<String, dynamic>> segments;

  FortuneWheelPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double angle = 2 * pi / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      paint.color = segment['color'] as Color;

      final double startAngle = i * angle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        angle,
        true,
        paint,
      );

      final double labelAngle = startAngle + angle / 2;
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${segment['value']}x',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      final double dx = center.dx + radius / 1.5 * cos(labelAngle);
      final double dy = center.dy + radius / 1.5 * sin(labelAngle);
      final Offset labelOffset = Offset(
        dx - textPainter.width / 2,
        dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class WheelPointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}