// lib/features/quiz/decors/crest_painter.dart
import 'package:flutter/material.dart';

class CrestPainter extends CustomPainter {
  final Color color;
  CrestPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final body = Path()
      ..moveTo(w * 0.2, h * 0.1)
      ..quadraticBezierTo(w * 0.5, -h * 0.05, w * 0.8, h * 0.1)
      ..lineTo(w * 0.8, h * 0.6)
      ..quadraticBezierTo(w * 0.5, h * 0.95, w * 0.2, h * 0.6)
      ..close();

    final paint = Paint()..color = color;
    canvas.drawShadow(body, Colors.black, 6, true);
    canvas.drawPath(body, paint);

    // inner emblem
    final inner = Path()
      ..addOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.35), width: w * 0.35, height: h * 0.25));
    final innerPaint = Paint()..color = Colors.white.withOpacity(0.85);
    canvas.drawPath(inner, innerPaint);

    // central rune
    final rune = Path()
      ..moveTo(w * 0.5, h * 0.28)
      ..lineTo(w * 0.52, h * 0.4)
      ..lineTo(w * 0.48, h * 0.4)
      ..close();
    canvas.drawPath(rune, paint..color = color.darken(0.1));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension ColorUtil on Color {
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);
    final f = 1 - amount;
    return Color.fromARGB(alpha, (red * f).round(), (green * f).round(), (blue * f).round());
  }
}
