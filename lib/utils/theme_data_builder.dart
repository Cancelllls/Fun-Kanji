import 'package:flutter/cupertino.dart';
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
    isLight ? ThemeData.light().textTheme : ThemeData.dark().textTheme,
  );

  final displayTextTheme = GoogleFonts.sawarabiMinchoTextTheme(
    isLight ? ThemeData.light().textTheme : ThemeData.dark().textTheme,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: isLight ? Brightness.light : Brightness.dark,
    colorScheme: effectiveScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: effectiveScheme.surface,

    // Google M3 Signature Ink Sparkle Splash Effect
    splashFactory: InkSparkle.splashFactory,

    // Google M3 & Figma Spring Motion Page Transitions
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),

    // M3 App Bar Theme
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
        statusBarBrightness: !isLight ? Brightness.dark : Brightness.light,
      ),
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: displayTextTheme.titleLarge?.copyWith(
        color: effectiveScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),

    // M3 Card Theme (20px extra-large shape with subtle outline)
    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: effectiveScheme.outlineVariant.withValues(
            alpha: isLight ? 0.6 : 0.4,
          ),
          width: 1.0,
        ),
      ),
      color: effectiveScheme.surfaceContainerHighest.withValues(
        alpha: isLight ? 0.75 : 0.85,
      ),
    ),

    // M3 Navigation Bar Theme
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: 72,
      backgroundColor: effectiveScheme.surface.withValues(
        alpha: isLight ? 0.95 : 0.98,
      ),
      indicatorColor: effectiveScheme.primaryContainer,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: effectiveScheme.onSurface,
          );
        }
        return textTheme.labelMedium?.copyWith(
          color: effectiveScheme.onSurfaceVariant,
        );
      }),
    ),

    // M3 Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 2,
      focusElevation: 4,
      hoverElevation: 4,
      highlightElevation: 6,
      backgroundColor: effectiveScheme.primaryContainer,
      foregroundColor: effectiveScheme.onPrimaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // M3 Buttons (Elevated, Filled, Outlined, Text)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: effectiveScheme.primaryContainer,
        foregroundColor: effectiveScheme.onPrimaryContainer,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveScheme.primary,
        side: BorderSide(
          color: effectiveScheme.outline,
          width: isLight ? 1.0 : 1.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: textTheme.labelLarge?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // M3 Input Decorations
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

    // M3 Dialog Theme
    dialogTheme: DialogThemeData(
      elevation: 3,
      backgroundColor: effectiveScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
    ),

    // M3 Segmented Button Theme
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return effectiveScheme.primaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return effectiveScheme.onPrimaryContainer;
          }
          return effectiveScheme.onSurface;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ),
  );
}

