// lib/features/quiz/decors/parchment_painter.dart
import 'package:flutter/material.dart';

class ParchmentPainter extends CustomPainter {
  final Color base;
  ParchmentPainter({required this.base});
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [base.withOpacity(1.0), base.withOpacity(0.9), base.withOpacity(0.95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(0)), paint);

    // subtle burn edges
    final burn = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black12],
      ).createShader(Rect.fromCircle(center: Offset(size.width * 0.95, size.height * 0.05), radius: size.width * 0.6));
    canvas.drawRect(rect, burn..blendMode = BlendMode.darken);

    // texture dots
    final tex = Paint()..color = Colors.black12.withOpacity(0.02);
    for (int i = 0; i < 80; i++) {
      final dx = (i * 37.3) % size.width;
      final dy = (i * 23.7) % size.height;
      canvas.drawCircle(Offset(dx, dy), 0.6, tex);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
