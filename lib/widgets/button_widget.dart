import 'package:flutter/material.dart';
import 'package:livecomm/utils/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';

enum ButtonType { primary, secondary, danger }

enum IconPosition { left, right }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? iconSize;
  final bool? isEnabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSize,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width ?? double.infinity, height: height ?? SizeUtils.buttonHeightMedium, child: _buildButton(isEnabled));
  }

  Widget _buildButton(bool? isEnabled) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(isEnabled);
      case ButtonType.secondary:
        return _buildSecondaryButton();
      case ButtonType.danger:
        return _buildDangerButton();
    }
  }

  // Primary Button - Orange color
  Widget _buildPrimaryButton(bool? isEnabled) {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ?? false ? AppColors.primary : AppColors.primary.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16, vertical: SizeUtils.spacing12),
        alignment: Alignment.center, // Ensure center alignment
      ),
      child: _buildButtonContent(textColor: isEnabled ?? false ? AppColors.textOnPrimary : AppColors.textOnPrimary.withOpacity(0.3)),
    );
  }

  // Secondary Button - Brown background with white text
  Widget _buildSecondaryButton() {
    return ElevatedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brownDark,
        foregroundColor: AppColors.brown,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16, vertical: SizeUtils.spacing12),
        alignment: Alignment.center, // Ensure center alignment
      ),
      child: _buildButtonContent(textColor: AppColors.brown),
    );
  }

  // Danger Button - Red border for extreme cases
  Widget _buildDangerButton() {
    return OutlinedButton(
      onPressed: isLoading ? () {} : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.error,
        side: BorderSide(color: AppColors.error, width: 1.5),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16, vertical: SizeUtils.spacing12),
        alignment: Alignment.center, // Ensure center alignment
      ),
      child: _buildButtonContent(textColor: AppColors.error),
    );
  }

  Widget _buildButtonContent({Color? textColor}) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: SizeUtils.getWidth(20),
          height: SizeUtils.getWidth(20),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ?? (type == ButtonType.primary ? AppColors.textOnPrimary : (type == ButtonType.danger ? AppColors.error : AppColors.brown)),
            ),
          ),
        ),
      );
    }

    if (icon != null) {
      final iconWidget = Icon(icon, size: iconSize ?? SizeUtils.iconMedium, color: textColor);

      final textWidget = Flexible(
        child: Text(text, style: _getTextStyle(textColor), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1),
      );

      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: iconPosition == IconPosition.left
              ? [iconWidget, SizedBox(width: SizeUtils.spacing8), textWidget]
              : [textWidget, SizedBox(width: SizeUtils.spacing8), iconWidget],
        ),
      );
    }

    return Center(
      child: Text(text, style: _getTextStyle(textColor), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, maxLines: 1),
    );
  }

  TextStyle _getTextStyle(Color? textColor) {
    return AppTextStyles.button(fontSize: SizeUtils.font10, fontWeight: FontWeight.w400, color: textColor ?? _getDefaultTextColor());
  }

  Color _getDefaultTextColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.textOnPrimary;
      case ButtonType.secondary:
        return AppColors.brown; // Brown text on dark brown background
      case ButtonType.danger:
        return AppColors.error;
    }
  }
}

// Convenience constructors for each button type
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? iconSize;
  final bool? isEnabled;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSize,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      isLoading: isLoading,
      width: width,
      height: height,
      icon: icon,
      iconPosition: iconPosition,
      iconSize: iconSize,
      isEnabled: isEnabled,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? iconSize;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      isLoading: isLoading,
      width: width,
      height: height,
      icon: icon,
      iconPosition: iconPosition,
      iconSize: iconSize,
    );
  }
}

class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? iconSize;

  const DangerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.danger,
      isLoading: isLoading,
      width: width,
      height: height,
      icon: icon,
      iconPosition: iconPosition,
      iconSize: iconSize,
    );
  }
}
