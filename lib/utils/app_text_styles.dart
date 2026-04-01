import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'size_utils.dart';

class AppTextStyles {
  // Default font family and weight
  static const String _defaultFontFamily = 'Inter';
  static const FontWeight _defaultFontWeight = FontWeight.w400;

  // Display text styles (largest)
  static TextStyle displayLarge({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font32,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle displayMedium({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font28,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle displaySmall({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font24,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  // Headline text styles
  static TextStyle headlineLarge({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font22,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle headlineMedium({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font20,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle headlineSmall({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font10,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  // Title text styles
  static TextStyle titleLarge({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font16,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle titleMedium({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font14,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle titleSmall({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font12,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textSecondary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  // Body text styles (most common)
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font16,
      fontWeight: fontWeight ?? _defaultFontWeight,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font12,
      fontWeight: fontWeight ?? _defaultFontWeight,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize, bool lineThrough = false}) {
    return (lineThrough)
        ? TextStyle(
            fontSize: fontSize ?? SizeUtils.font10,
            fontWeight: fontWeight ?? _defaultFontWeight,
            color: color ?? AppColors.textSecondary,
            fontFamily: fontFamily ?? _defaultFontFamily,
          ).copyWith(decoration: TextDecoration.lineThrough, decorationColor: AppColors.textSecondary.withOpacity(0.9))
        : TextStyle(
            fontSize: fontSize ?? SizeUtils.font10,
            fontWeight: fontWeight ?? _defaultFontWeight,
            color: color ?? AppColors.textSecondary,
            fontFamily: fontFamily ?? _defaultFontFamily,
          );
  }

  // Label text styles (smallest)
  static TextStyle labelLarge({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font14,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle labelMedium({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font12,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textSecondary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle labelSmall({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font10,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textTertiary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  // Custom text styles for specific use cases
  static TextStyle button({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font16,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? AppColors.textOnPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle caption({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font12,
      fontWeight: fontWeight ?? _defaultFontWeight,
      color: color ?? AppColors.textSecondary,
      fontFamily: fontFamily ?? _defaultFontFamily,
    );
  }

  static TextStyle overline({Color? color, FontWeight? fontWeight, String? fontFamily, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font10,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textTertiary,
      fontFamily: fontFamily ?? _defaultFontFamily,
      letterSpacing: 1.5,
    );
  }

  // Utility method to create custom text style with all defaults
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    String? fontFamily,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontSize: fontSize ?? SizeUtils.font14,
      fontWeight: fontWeight ?? _defaultFontWeight,
      color: color ?? AppColors.textPrimary,
      fontFamily: fontFamily ?? _defaultFontFamily,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  // Quick access to common styles
  static TextStyle get heading => displaySmall();

  static TextStyle get subHeading => headlineMedium();

  static TextStyle get body => bodyMedium();

  static TextStyle get small => bodySmall();

  static TextStyle get tiny => labelSmall();

  // Colored variants
  static TextStyle get primaryText => bodyMedium(color: AppColors.primary);

  static TextStyle get secondaryText => bodyMedium(color: AppColors.textSecondary);

  static TextStyle get errorText => bodyMedium(color: AppColors.error);

  static TextStyle get successText => bodyMedium(color: AppColors.success);

  static TextStyle get warningText => bodyMedium(color: AppColors.warning);

  // Weight variants
  static TextStyle get lightText => bodyMedium(fontWeight: FontWeight.w300);

  static TextStyle get regularText => bodyMedium(fontWeight: FontWeight.w400);

  static TextStyle get mediumText => bodyMedium(fontWeight: FontWeight.w500);

  static TextStyle get semiBoldText => bodyMedium(fontWeight: FontWeight.w600);

  static TextStyle get boldText => bodyMedium(fontWeight: FontWeight.w700);
}
