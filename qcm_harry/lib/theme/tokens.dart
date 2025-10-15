// lib/theme/tokens.dart
import 'package:flutter/material.dart';

class Tokens {
  // Colors as requested: #7F0909, #D3A625, #0E1A40, #2A623D, #F8F4E9, #111827 and variants
  static const Color deepRed = Color(0xFF7F0909);
  static const Color gold = Color(0xFFD3A625);
  static const Color midnight = Color(0xFF0E1A40);
  static const Color forest = Color(0xFF2A623D);
  static const Color parchment = Color(0xFFF8F4E9);
  static const Color almostBlack = Color(0xFF111827);

  // Radii and shadows
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;

  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x22000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );
}
