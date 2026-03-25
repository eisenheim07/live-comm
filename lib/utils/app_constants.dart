import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'size_utils.dart';

class AppConstants {
  // App Information
  static const String appName = 'Bazaar Live';
  static const String appVersion = '1.0.0';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Common Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: SizeUtils.getWidth(8),
      offset: Offset(0, SizeUtils.getHeight(2)),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: SizeUtils.getWidth(4),
      offset: Offset(0, SizeUtils.getHeight(2)),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: SizeUtils.getWidth(12),
      offset: Offset(0, SizeUtils.getHeight(4)),
    ),
  ];

  // Common Border Radius
  static BorderRadius get smallRadius => BorderRadius.circular(SizeUtils.radius8);
  static BorderRadius get mediumRadius => BorderRadius.circular(SizeUtils.radius12);
  static BorderRadius get largeRadius => BorderRadius.circular(SizeUtils.radius16);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(SizeUtils.radius24);

  // Common Gradients
  static LinearGradient get primaryGradient => AppColors.primaryGradient;

  static LinearGradient get backgroundGradient => AppColors.backgroundGradient;

  static LinearGradient get cardGradient => AppColors.surfaceGradient;

  // Common Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppColors.surface,
    borderRadius: mediumRadius,
    boxShadow: cardShadow,
  );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: AppColors.surface,
    borderRadius: largeRadius,
    boxShadow: elevatedShadow,
  );

  static BoxDecoration get buttonDecoration => BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: mediumRadius,
    boxShadow: buttonShadow,
  );

  // Common Borders
  static Border get defaultBorder => Border.all(
    color: AppColors.border,
    width: 1,
  );

  static Border get primaryBorder => Border.all(
    color: AppColors.primary,
    width: 2,
  );

  static Border get errorBorder => Border.all(
    color: AppColors.error,
    width: 1,
  );

  // Common Dividers
  static Widget get horizontalDivider => Container(
    height: 1,
    color: AppColors.border,
  );

  static Widget get verticalDivider => Container(
    width: 1,
    color: AppColors.border,
  );

  // Common Spacing Widgets
  static Widget get smallVerticalSpace => SizedBox(height: SizeUtils.spacing8);
  static Widget get mediumVerticalSpace => SizedBox(height: SizeUtils.spacing16);
  static Widget get largeVerticalSpace => SizedBox(height: SizeUtils.spacing24);
  static Widget get extraLargeVerticalSpace => SizedBox(height: SizeUtils.spacing32);

  static Widget get smallHorizontalSpace => SizedBox(width: SizeUtils.spacing8);
  static Widget get mediumHorizontalSpace => SizedBox(width: SizeUtils.spacing16);
  static Widget get largeHorizontalSpace => SizedBox(width: SizeUtils.spacing24);
  static Widget get extraLargeHorizontalSpace => SizedBox(width: SizeUtils.spacing32);

  // Loading Indicators
  static Widget get primaryLoader => CircularProgressIndicator(
    color: AppColors.primary,
    strokeWidth: SizeUtils.getWidth(2),
  );

  static Widget get secondaryLoader => CircularProgressIndicator(
    color: AppColors.secondary,
    strokeWidth: SizeUtils.getWidth(2),
  );

  // Common Text Styles
  static TextStyle get headingStyle => TextStyle(
    fontSize: SizeUtils.font24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );

  static TextStyle get subHeadingStyle => TextStyle(
    fontSize: SizeUtils.font18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );

  static TextStyle get bodyStyle => TextStyle(
    fontSize: SizeUtils.font14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Inter',
  );

  static TextStyle get captionStyle => TextStyle(
    fontSize: SizeUtils.font12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Inter',
  );

  static TextStyle get buttonTextStyle => TextStyle(
    fontSize: SizeUtils.font16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    fontFamily: 'Inter',
  );

  // Status Colors Map
  static const Map<String, Color> statusColors = {
    'online': AppColors.online,
    'offline': AppColors.offline,
    'busy': AppColors.busy,
    'away': AppColors.away,
  };

  // Common Transitions
  static Widget slideTransition(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget fadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Widget scaleTransition(Widget child, Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  // Validation Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\+?[\d\s\-\(\)]{10,}$';
  static const String urlPattern = r'^https?:\/\/[\w\-]+(\.[\w\-]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$';

  // Common Durations for API calls
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(minutes: 2);

  // Common Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Something went wrong. Please try again.';
  static const String validationError = 'Please check your input and try again.';
}