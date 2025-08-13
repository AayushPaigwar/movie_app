import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFB800);
  static const Color primaryVariant = Color(0xFFFFA000);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  
  static const Color background = Color(0xFF0B0D14);
  static const Color surface = Color(0xFF111318);
  static const Color surfaceVariant = Color(0xFF1A1D24);
  static const Color surfaceContainer = Color(0xFF1E2229);
  static const Color surfaceContainerHigh = Color(0xFF22252E);
  
  static const Color onPrimary = Color(0xFF000000);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onSurface = Color(0xFFE1E2E9);
  static const Color onSurfaceVariant = Color(0xFFB0B3BA);
  static const Color onBackground = Color(0xFFE1E2E9);
  
  static const Color error = Color(0xFFCF6679);
  static const Color onError = Color(0xFF000000);
  
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3BA);
  static const Color textTertiary = Color(0xFF7A7D84);
  static const Color textDisabled = Color(0xFF4A4D54);
  
  static const Color divider = Color(0xFF2A2D34);
  static const Color outline = Color(0xFF3A3D44);
  static const Color outlineVariant = Color(0xFF2A2D34);
  
  static const List<Color> gradientPrimary = [
    Color(0xFF0B0D14),
    Color(0xFF111318),
  ];
  
  static const List<Color> gradientSecondary = [
    Color(0xFF1A1D24),
    Color(0xFF22252E),
  ];
  
  static const List<Color> gradientAccent = [
    Color(0xFFFFB800),
    Color(0xFFFFA000),
  ];
  
  static const List<Color> shimmerColors = [
    Color(0xFF1A1D24),
    Color(0xFF22252E),
    Color(0xFF1A1D24),
  ];
  
  static const BoxShadow shadowSmall = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  );
  
  static const BoxShadow shadowMedium = BoxShadow(
    color: Color(0x1F000000),
    offset: Offset(0, 4),
    blurRadius: 8,
    spreadRadius: 0,
  );
  
  static const BoxShadow shadowLarge = BoxShadow(
    color: Color(0x26000000),
    offset: Offset(0, 8),
    blurRadius: 16,
    spreadRadius: 0,
  );
  
  static const BoxShadow glowPrimary = BoxShadow(
    color: Color(0x33FFB800),
    offset: Offset(0, 0),
    blurRadius: 12,
    spreadRadius: 2,
  );
}