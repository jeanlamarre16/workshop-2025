// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'tokens.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: Tokens.deepRed,
        secondary: Tokens.gold,
        background: Tokens.parchment,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Tokens.almostBlack,
      ),
      scaffoldBackgroundColor: Tokens.parchment,
      appBarTheme: AppBarTheme(
        backgroundColor: Tokens.deepRed,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      textTheme: base.textTheme.apply(
        fontFamily: null, // use system fonts (Roboto / SF) by default
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Tokens.radiusMd)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Tokens.deepRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Tokens.radiusSm),
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: Tokens.gold,
        secondary: Tokens.deepRed,
        background: Colors.black,
        surface: Colors.grey[900],
        onPrimary: Colors.black,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      textTheme: base.textTheme.apply(fontFamily: null),
      appBarTheme: AppBarTheme(
        backgroundColor: Tokens.almostBlack,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
    );
  }
}
