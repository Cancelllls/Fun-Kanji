import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:fun_with_kanji/config/app_colors.dart';

ThemeData buildTheme(ColorScheme? scheme, Color? primaryColor, bool isLight) {
  final effectiveScheme = primaryColor != null
      ? ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: isLight ? Brightness.light : Brightness.dark,
        )
      : (scheme ??
          (isLight ? AppColors.lightScheme : AppColors.darkScheme));

  final textTheme = GoogleFonts.notoSansJpTextTheme(
    isLight
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme,
  );

  final displayTextTheme = GoogleFonts.notoSerifJpTextTheme(
    isLight
        ? ThemeData.light().textTheme
        : ThemeData.dark().textTheme,
  );

  return ThemeData(
    brightness: isLight ? Brightness.light : Brightness.dark,
    useMaterial3: true,
    colorScheme: effectiveScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: effectiveScheme.surface,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        statusBarBrightness: !isLight ? Brightness.dark : Brightness.light,
      ),
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: displayTextTheme.titleLarge?.copyWith(
        color: effectiveScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: effectiveScheme.outlineVariant.withValues(
            alpha: isLight ? 0.5 : 0.7,
          ),
        ),
      ),
      color: effectiveScheme.surfaceContainerHighest.withValues(
        alpha: isLight ? 0.8 : 0.92,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      backgroundColor: effectiveScheme.surface.withValues(
        alpha: isLight ? 0.9 : 0.95,
      ),
      indicatorColor: effectiveScheme.primaryContainer,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveScheme.primaryContainer,
        foregroundColor: effectiveScheme.onPrimaryContainer,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveScheme.primary,
        side: BorderSide(color: effectiveScheme.outline, width: isLight ? 1.0 : 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: effectiveScheme.surfaceContainerHighest.withValues(
        alpha: isLight ? 0.5 : 0.7,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: effectiveScheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: effectiveScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: effectiveScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    colorSchemeSeed: primaryColor ??
        (scheme == null ? AppColors.seedColor : null),
  );
}
