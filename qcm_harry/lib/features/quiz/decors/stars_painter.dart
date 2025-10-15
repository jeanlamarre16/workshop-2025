// lib/features/quiz/decors/stars_painter.dart
import 'package:flutter/material.dart';
import 'dart:math';

class StarsPainter extends CustomPainter {
  final int count;
  final Color color;
  StarsPainter({this.count = 40, required this.color});
  final Random _rnd = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (int i = 0; i < count; i++) {
      final x = _rnd.nextDouble() * size.width;
      final y = _rnd.nextDouble() * size.height;
      final r = _rnd.nextDouble() * 1.8 + 0.3;
      paint.color = color.withOpacity(0.2 + _rnd.nextDouble() * 0.8);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
