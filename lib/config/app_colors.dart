import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color seedColor = Color(0xFF4F46E5);

  static const Color primary = Color(0xFF4F46E5);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE0E0FF);
  static const Color onPrimaryContainer = Color(0xFF1A0A8F);

  static const Color secondary = Color(0xFF818CF8);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE0E0FF);
  static const Color onSecondaryContainer = Color(0xFF1A0A8F);

  static const Color tertiary = Color(0xFF22C55E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD1FAE5);
  static const Color onTertiaryContainer = Color(0xFF064E3B);

  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  static const Color surface = Color(0xFFFCF8FF);
  static const Color onSurface = Color(0xFF1C1B2D);
  static const Color surfaceContainer = Color(0xFFF0EFFF);
  static const Color onSurfaceVariant = Color(0xFF474660);

  static const Color outline = Color(0xFF777680);
  static const Color outlineVariant = Color(0xFFC8C5D8);

  static const Color starColor = Color(0xFFFBBF24);
  static const Color scaffoldBackground = Color(0xFFFCF8FF);

  static const Color confettiPink = Color(0xFFF472B6);

  static const Color gradientDarkStart = Color(0xFF1A1A3E);
  static const Color gradientDarkMid = Color(0xFF2D2B55);
  static const Color gradientDarkEnd = Color(0xFF1B1B3A);
  static const Color gradientLightStart = Color(0xFFEEF2FF);
  static const Color gradientLightMid = Color(0xFFE8ECFF);
  static const Color gradientLightEnd = Color(0xFFF0EBFF);

  static const ColorScheme lightScheme = ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceContainer,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      );

  static const ColorScheme darkScheme = ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFC1C3FF),
        onPrimary: Color(0xFF2100B0),
        primaryContainer: Color(0xFF3D39C8),
        onPrimaryContainer: Color(0xFFE0E0FF),
        secondary: Color(0xFFBEC0FF),
        onSecondary: Color(0xFF1A0880),
        secondaryContainer: Color(0xFF3D39C8),
        onSecondaryContainer: Color(0xFFE0E0FF),
        tertiary: Color(0xFF4ADE80),
        onTertiary: Color(0xFF003915),
        tertiaryContainer: Color(0xFF007B30),
        onTertiaryContainer: Color(0xFFD1FAE5),
        error: Color(0xFFF87171),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFEE2E2),
        surface: Color(0xFF1A1B2E),
        onSurface: Color(0xFFE3E1EC),
        surfaceContainerHighest: Color(0xFF2A2A3E),
        onSurfaceVariant: Color(0xFFC8C5D8),
        outline: Color(0xFF9E9CB5),
        outlineVariant: Color(0xFF5A5876),
      );
}
