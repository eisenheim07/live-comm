import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (8 main colors as requested)
  static const Color primary = Color(0xFFE07020); // Orange primary
  static const Color secondary = Color(0xFF00C851); // Green accent
  static const Color background = Color(0xFF0E0700); // Dark scaffold background
  static const Color surface = Color(0xFF2D2D2D); // Card/surface color
  static const Color accent = Color(0xFF4A90E2); // Blue accent
  static const Color error = Color(0xFFFF4444); // Red for errors/alerts
  static const Color warning = Color(0xFFFFA726); // Amber warning
  static const Color success = Color(0xFF4CAF50); // Green success
  static const Color brown = Color(0xFF8A6050); // Brown accent color
  static const Color brownDark = Color(0xFF251400); // Dark brown background

  // Primary Variants
  static const Color primaryLight = Color(0xFFE89660); // Lighter version of E07020
  static const Color primaryDark = Color(0xFFB85A1A); // Darker version of E07020
  static const Color primarySoft = Color(0x33E07020); // 20% opacity

  // Secondary Variants
  static const Color secondaryLight = Color(0xFF69F0AE);
  static const Color secondaryDark = Color(0xFF00A041);
  static const Color secondarySoft = Color(0x3300C851); // 20% opacity

  // Background Variants
  static const Color backgroundLight = Color(0xFF1A1200); // Lighter version of background
  static const Color backgroundDark = Color(0xFF070300); // Darker version of background
  static const Color backgroundOverlay = Color(0x80000000); // 50% black overlay

  // Surface Variants
  static const Color surfaceLight = Color(0xFF3A3A3A);
  static const Color surfaceDark = Color(0xFF1F1F1F);
  static const Color surfaceElevated = Color(0xFF404040);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFB3B3B3); // Light gray
  static const Color textTertiary = Color(0xFF808080); // Medium gray
  static const Color textDisabled = Color(0xFF4D4D4D); // Dark gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White on primary
  static const Color textOnSecondary = Color(0xFF000000); // Black on secondary

  // Border Colors
  static const Color border = Color(0xFF404040);
  static const Color borderLight = Color(0xFF606060);
  static const Color borderDark = Color(0xFF2A2A2A);

  // Status Colors
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color busy = Color(0xFFFF9800);
  static const Color away = Color(0xFFFFC107);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFE07020), Color(0xFFB85A1A)], // Updated to use new primary colors
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [AppColors.background, AppColors.backgroundDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [AppColors.surface, AppColors.surfaceDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000); // 10% black
  static const Color shadowMedium = Color(0x33000000); // 20% black
  static const Color shadowDark = Color(0x4D000000); // 30% black

  // Method to get contrasting text color
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textOnPrimary;
  }
}
