import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'size_utils.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: SizeUtils.font18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: SizeUtils.font32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        displayMedium: TextStyle(
          fontSize: SizeUtils.font28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        displaySmall: TextStyle(
          fontSize: SizeUtils.font24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        headlineLarge: TextStyle(
          fontSize: SizeUtils.font22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: SizeUtils.font20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: SizeUtils.font18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        titleLarge: TextStyle(
          fontSize: SizeUtils.font16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        titleMedium: TextStyle(
          fontSize: SizeUtils.font14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        titleSmall: TextStyle(
          fontSize: SizeUtils.font12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          fontSize: SizeUtils.font16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: SizeUtils.font14,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          fontSize: SizeUtils.font12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
          fontFamily: 'Inter',
        ),
        labelLarge: TextStyle(
          fontSize: SizeUtils.font14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        labelMedium: TextStyle(
          fontSize: SizeUtils.font12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
          fontFamily: 'Inter',
        ),
        labelSmall: TextStyle(
          fontSize: SizeUtils.font10,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
          fontFamily: 'Inter',
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: SizeUtils.buttonPadding,
          minimumSize: Size(double.infinity, SizeUtils.buttonHeightMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeUtils.radius12),
          ),
          textStyle: TextStyle(
            fontSize: SizeUtils.font16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          padding: SizeUtils.buttonPadding,
          minimumSize: Size(double.infinity, SizeUtils.buttonHeightMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeUtils.radius12),
          ),
          textStyle: TextStyle(
            fontSize: SizeUtils.font16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: SizeUtils.buttonPaddingSmall,
          textStyle: TextStyle(
            fontSize: SizeUtils.font14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: SizeUtils.getPadding(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(
          color: AppColors.textTertiary,
          fontSize: SizeUtils.font14,
          fontFamily: 'Inter',
        ),
        labelStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: SizeUtils.font14,
          fontFamily: 'Inter',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius16),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: SizeUtils.font12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: SizeUtils.font12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Inter',
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColors.textSecondary,
        size: SizeUtils.iconMedium,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        side: const BorderSide(color: AppColors.border, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius4),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius16),
        ),
        titleTextStyle: TextStyle(
          fontSize: SizeUtils.font18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
        contentTextStyle: TextStyle(
          fontSize: SizeUtils.font14,
          color: AppColors.textSecondary,
          fontFamily: 'Inter',
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: SizeUtils.font14,
          fontFamily: 'Inter',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnSecondary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        titleTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: SizeUtils.font18, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: SizeUtils.font32, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Inter'),
        displayMedium: TextStyle(fontSize: SizeUtils.font28, fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontFamily: 'Inter'),
        displaySmall: TextStyle(fontSize: SizeUtils.font24, fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontFamily: 'Inter'),
        headlineLarge: TextStyle(fontSize: SizeUtils.font22, fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontFamily: 'Inter'),
        headlineMedium: TextStyle(fontSize: SizeUtils.font20, fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontFamily: 'Inter'),
        headlineSmall: TextStyle(fontSize: SizeUtils.font18, fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontFamily: 'Inter'),
        titleLarge: TextStyle(fontSize: SizeUtils.font16, fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontFamily: 'Inter'),
        titleMedium: TextStyle(fontSize: SizeUtils.font14, fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontFamily: 'Inter'),
        titleSmall: TextStyle(fontSize: SizeUtils.font12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, fontFamily: 'Inter'),
        bodyLarge: TextStyle(fontSize: SizeUtils.font16, fontWeight: FontWeight.normal, color: AppColors.textPrimary, fontFamily: 'Inter'),
        bodyMedium: TextStyle(fontSize: SizeUtils.font14, fontWeight: FontWeight.normal, color: AppColors.textPrimary, fontFamily: 'Inter'),
        bodySmall: TextStyle(fontSize: SizeUtils.font12, fontWeight: FontWeight.normal, color: AppColors.textSecondary, fontFamily: 'Inter'),
        labelLarge: TextStyle(fontSize: SizeUtils.font14, fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontFamily: 'Inter'),
        labelMedium: TextStyle(fontSize: SizeUtils.font12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, fontFamily: 'Inter'),
        labelSmall: TextStyle(fontSize: SizeUtils.font10, fontWeight: FontWeight.w500, color: AppColors.textTertiary, fontFamily: 'Inter'),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: SizeUtils.buttonPadding,
          minimumSize: Size(double.infinity, SizeUtils.buttonHeightMedium),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
          textStyle: TextStyle(fontSize: SizeUtils.font16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1),
          padding: SizeUtils.buttonPadding,
          minimumSize: Size(double.infinity, SizeUtils.buttonHeightMedium),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
          textStyle: TextStyle(fontSize: SizeUtils.font16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: SizeUtils.buttonPaddingSmall,
          textStyle: TextStyle(fontSize: SizeUtils.font14, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: SizeUtils.getPadding(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: SizeUtils.font14, fontFamily: 'Inter'),
        labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: SizeUtils.font14, fontFamily: 'Inter'),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius16)),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: SizeUtils.font12, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
        unselectedLabelStyle: TextStyle(fontSize: SizeUtils.font12, fontWeight: FontWeight.normal, fontFamily: 'Inter'),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),

      // Icon Theme
      iconTheme: IconThemeData(color: AppColors.textSecondary, size: SizeUtils.iconMedium),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        side: const BorderSide(color: AppColors.border, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius4)),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.border;
        }),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius16)),
        titleTextStyle: TextStyle(fontSize: SizeUtils.font18, fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontFamily: 'Inter'),
        contentTextStyle: TextStyle(fontSize: SizeUtils.font14, color: AppColors.textSecondary, fontFamily: 'Inter'),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: TextStyle(color: AppColors.textPrimary, fontSize: SizeUtils.font14, fontFamily: 'Inter'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Method to initialize theme with context
  static void init(BuildContext context) {
    SizeUtils.init(context);
  }
}
