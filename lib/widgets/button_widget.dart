import 'package:flutter/material.dart';
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
  final bool enabled;

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
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !enabled || onPressed == null;

    return SizedBox(width: width ?? double.infinity, height: height ?? SizeUtils.buttonHeightMedium, child: _buildButton(isDisabled));
  }

  Widget _buildButton(bool isDisabled) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(isDisabled);
      case ButtonType.secondary:
        return _buildSecondaryButton(isDisabled);
      case ButtonType.danger:
        return _buildDangerButton(isDisabled);
    }
  }

  // Primary Button - Orange/Amber color
  Widget _buildPrimaryButton(bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.textTertiary : AppColors.primary,
        foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.textOnPrimary,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16, vertical: SizeUtils.spacing12),
        alignment: Alignment.center, // Ensure center alignment
      ),
      child: _buildButtonContent(textColor: isDisabled ? AppColors.textDisabled : AppColors.textOnPrimary),
    );
  }

  // Secondary Button - Faded/Disabled style
  Widget _buildSecondaryButton(bool isDisabled) {
    return OutlinedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.surfaceDark : AppColors.surface,
        foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.textSecondary,
        side: BorderSide(color: isDisabled ? AppColors.borderDark : AppColors.border, width: 1),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16, vertical: SizeUtils.spacing12),
        alignment: Alignment.center, // Ensure center alignment
      ),
      child: _buildButtonContent(textColor: isDisabled ? AppColors.textDisabled : AppColors.textSecondary),
    );
  }

  // Danger Button - Red border for extreme cases
  Widget _buildDangerButton(bool isDisabled) {
    return OutlinedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.error,
        side: BorderSide(color: isDisabled ? AppColors.textDisabled : AppColors.error, width: 1.5),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
        padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16, vertical: SizeUtils.spacing12),
        alignment: Alignment.center, // Ensure center alignment
      ),
      child: _buildButtonContent(textColor: isDisabled ? AppColors.textDisabled : AppColors.error),
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
              textColor ??
                  (type == ButtonType.primary ? AppColors.textOnPrimary : (type == ButtonType.danger ? AppColors.error : AppColors.textSecondary)),
            ),
          ),
        ),
      );
    }

    if (icon != null) {
      final iconWidget = Icon(
        icon, 
        size: iconSize ?? SizeUtils.iconMedium, 
        color: textColor,
      );

      final textWidget = Flexible(
        child: Text(
          text, 
          style: _getTextStyle(textColor),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
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
      child: Text(
        text, 
        style: _getTextStyle(textColor),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  TextStyle _getTextStyle(Color? textColor) {
    return TextStyle(
      fontSize: SizeUtils.font10,
      fontWeight: FontWeight.w400,
      fontFamily: 'Inter', 
      color: textColor ?? _getDefaultTextColor(),
    );
  }

  Color _getDefaultTextColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.textOnPrimary;
      case ButtonType.secondary:
        return AppColors.textSecondary;
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
  final bool enabled;

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
    this.enabled = true,
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
      enabled: enabled,
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
  final bool enabled;

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
    this.enabled = true,
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
      enabled: enabled,
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
  final bool enabled;

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
    this.enabled = true,
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
      enabled: enabled,
    );
  }
}
