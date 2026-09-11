import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppColors {
  // Primary Blues
  static const Color primaryBlue = Color(0xFF1a73e8);
  static const Color primaryBlueDark = Color(0xFF1557b0);
  static const Color primaryBlueLight = Color(0xFF4285f4);
  static const Color primaryBlueLighter = Color(0xFF669df6);

  // Secondary Greens
  static const Color secondaryGreen = Color(0xFF34a853);
  static const Color secondaryGreenLight = Color(0xFF5bb974);

  // Status Colors
  static const Color successGreen = Color(0xFF34a853);
  static const Color warningYellow = Color(0xFFfbbc04);
  static const Color errorRed = Color(0xFFea4335);
  static const Color errorRedLight = Color(0xFFef6c61);

  // Neutral Colors
  static const Color background = Color(0xFFf8f9fa);
  static const Color surfaceWhite = Color(0xFFffffff);
  static const Color textPrimary = Color(0xFF202124);
  static const Color textSecondary = Color(0xFF5f6368);
  static const Color borderGrey = Color(0xFFe8eaed);
  static const Color dividerGrey = Color(0xFFf1f3f4);
}

class AppTheme {
  static ThemeData buildTheme() {
    final baseTheme = FlexThemeData.light(
      useMaterial3: true,
      colors: const FlexSchemeColor(
        primary: AppColors.primaryBlue,
        primaryContainer: AppColors.primaryBlueLight,
        secondary: AppColors.secondaryGreen,
        secondaryContainer: AppColors.secondaryGreenLight,
        tertiary: AppColors.warningYellow,
        tertiaryContainer: AppColors.primaryBlueLighter,
        appBarColor: AppColors.primaryBlue,
        error: AppColors.errorRed,
      ),
      scaffoldBackground: AppColors.background,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurfaces,
      blendLevel: 8,
      appBarStyle: FlexAppBarStyle.primary,
      appBarOpacity: 1,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 8,
        blendOnColors: false,
        defaultRadius: 12,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.surfaceWhite,
        elevation: 2,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppColors.surfaceWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.surfaceWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          side: const BorderSide(color: AppColors.primaryBlue, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.borderGrey),
      ),

      // Text Themes
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),

      // Other Components
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryBlueLighter.withOpacity(0.2),
        labelStyle: const TextStyle(color: AppColors.primaryBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
