import 'package:flutter/material.dart';

class AppColors {
  // Main Colors (12 core colors as requested)
  static const Color primary = Color(0xFFE07020); // Orange primary button
  static const Color secondary = Color(0xFF00C851); // Green accent (needed for theme)
  static const Color background = Color(0xFF0E0700); // Dark scaffold background
  static const Color surface = Color(0xFF2D2D2D); // Card/surface color
  static const Color brown = Color(0xFF8A6050); // Brown accent/text color
  static const Color brownDark = Color(0xFF251400); // Dark brown secondary button background
  static const Color cream = Color(0xFFF5E6D3); // Cream color for heading texts
  static const Color white = Color(0xFFFFFFFF); // White for texts and primary button text
  static const Color error = Color(0xFFFF4444); // Red for errors/alerts
  static const Color success = Color(0xFF4CAF50); // Green success
  static const Color warning = Color(0xFFFFA726); // Amber warning
  static const Color border = Color(0xFF404040); // Border color

  // Text Colors (using main colors)
  static const Color textPrimary = white; // White for primary text
  static const Color textSecondary = brown; // Brown for secondary text
  static const Color textTertiary = Color(0xFF666666); // Gray for tertiary text
  static const Color textHeading = cream; // Cream for heading text
  static const Color textOnPrimary = white; // White text on primary button
  static const Color textOnSecondary = brown; // Brown text on secondary button
  static const Color textDisabled = Color(0xFF444444); // Disabled text

  // Status Colors (needed for app constants)
  static const Color online = success; // Green for online status
  static const Color offline = Color(0xFF9E9E9E); // Gray for offline status
  static const Color busy = warning; // Amber for busy status
  static const Color away = Color(0xFFFFC107); // Yellow for away status

  // Background Variants (using main colors)
  static const Color backgroundLight = Color(0xFF1A1200); // Lighter background
  static const Color backgroundDark = Color(0xFF070300); // Darker background

  // Surface Variants (using main colors)
  static const Color surfaceLight = Color(0xFF3A3A3A); // Lighter surface
  static const Color surfaceDark = Color(0xFF1F1F1F); // Darker surface

  // Border Variants (using main colors)
  static const Color borderLight = Color(0xFF606060); // Lighter border
  static const Color borderDark = Color(0xFF2A2A2A); // Darker border

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFB85A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, backgroundDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient surfaceGradient = LinearGradient(colors: [surface, surfaceDark], begin: Alignment.topLeft, end: Alignment.bottomRight);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000); // 10% black
  static const Color shadowMedium = Color(0x33000000); // 20% black
  static const Color shadowDark = Color(0x4D000000); // 30% black

  // Method to get contrasting text color
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? background : white;
  }
}
