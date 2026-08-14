import 'package:flutter/material.dart';

abstract class AppColors {
  // Minimalist Zen Theme Tokens
  static const Color seedColor = Color(0xFFEC4899);

  // Cherry Blossom Pink & Matte Slate Primary
  static const Color primary = Color(0xFFDB2777);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFCE7F3);
  static const Color onPrimaryContainer = Color(0xFF831843);

  // Slate & Charcoal Secondary
  static const Color secondary = Color(0xFF475569);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFF1F5F9);
  static const Color onSecondaryContainer = Color(0xFF0F172A);

  // Bamboo Green & Tea Gold Tertiary
  static const Color tertiary = Color(0xFF10B981);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD1FAE5);
  static const Color onTertiaryContainer = Color(0xFF065F46);

  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  // Zen Cream Surface (Light Mode)
  static const Color surface = Color(0xFFFAFAF9);
  static const Color onSurface = Color(0xFF1C1917);
  static const Color surfaceContainer = Color(0xFFF5F5F4);
  static const Color onSurfaceVariant = Color(0xFF57534E);

  static const Color outline = Color(0xFFA8A29E);
  static const Color outlineVariant = Color(0xFFE7E5E4);

  static const Color starColor = Color(0xFFF59E0B);
  static const Color scaffoldBackground = Color(0xFFFAFAF9);

  static const Color confettiPink = Color(0xFFEC4899);

  // Minimalist Zen Gradients
  static const Color gradientDarkStart = Color(0xFF0C0A09);
  static const Color gradientDarkMid = Color(0xFF1C1917);
  static const Color gradientDarkEnd = Color(0xFF292524);

  static const Color gradientLightStart = Color(0xFFFAFAF9);
  static const Color gradientLightMid = Color(0xFFF5F5F4);
  static const Color gradientLightEnd = Color(0xFFFCE7F3);

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
        primary: Color(0xFFF472B6),
        onPrimary: Color(0xFF500724),
        primaryContainer: Color(0xFF831843),
        onPrimaryContainer: Color(0xFFFCE7F3),
        secondary: Color(0xFF94A3B8),
        onSecondary: Color(0xFF0F172A),
        secondaryContainer: Color(0xFF334155),
        onSecondaryContainer: Color(0xFFF8FAFC),
        tertiary: Color(0xFF34D399),
        onTertiary: Color(0xFF022C22),
        tertiaryContainer: Color(0xFF065F46),
        onTertiaryContainer: Color(0xFFD1FAE5),
        error: Color(0xFFF87171),
        onError: Color(0xFF690005),
        errorContainer: Color(0xFF93000A),
        onErrorContainer: Color(0xFFFEE2E2),
        surface: Color(0xFF0C0A09),
        onSurface: Color(0xFFF5F5F4),
        surfaceContainerHighest: Color(0xFF1C1917),
        onSurfaceVariant: Color(0xFFA8A29E),
        outline: Color(0xFF78716C),
        outlineVariant: Color(0xFF44403C),
      );
}
