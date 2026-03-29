import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import 'button_widget.dart';

class ErrorBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String? dangerButtonText;
  final VoidCallback? onDangerPressed;
  final bool showBothButtons;

  const ErrorBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonText = 'OK',
    this.onPrimaryPressed,
    this.dangerButtonText,
    this.onDangerPressed,
    this.showBothButtons = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeUtils.radius20),
          topRight: Radius.circular(SizeUtils.radius20),
        ),
      ),
      child: Padding(
        padding: SizeUtils.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top handle indicator
            Center(
              child: Container(
                width: SizeUtils.getWidth(40),
                height: SizeUtils.getHeight(4),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                ),
              ),
            ),
            AppConstants.mediumVerticalSpace,

            // Header/Title
            Center(
              child: Text(
                title,
                style: AppTextStyles.headlineMedium(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AppConstants.smallVerticalSpace,

            // Message/Content/Body
            Center(
              child: Text(
                message,
                style: AppTextStyles.bodySmall(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            AppConstants.largeVerticalSpace,

            // Buttons Section
            if (showBothButtons) ...[
              // Two buttons layout
              Row(
                children: [
                  // Danger button on left
                  Expanded(
                    child: DangerButton(
                      text: dangerButtonText ?? 'Cancel',
                      onPressed: onDangerPressed ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(width: SizeUtils.spacing12),
                  // Primary button on right
                  Expanded(
                    child: PrimaryButton(
                      text: primaryButtonText,
                      onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Single button layout (primary button only)
              PrimaryButton(
                text: primaryButtonText,
                onPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
              ),
            ],

            // Bottom safe area padding
            SizedBox(height: SizeUtils.safeAreaBottom),
          ],
        ),
      ),
    );
  }

  /// Static method to show error bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    String primaryButtonText = 'OK',
    VoidCallback? onPrimaryPressed,
    String? dangerButtonText,
    VoidCallback? onDangerPressed,
    bool showBothButtons = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ErrorBottomSheet(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        dangerButtonText: dangerButtonText,
        onDangerPressed: onDangerPressed,
        showBothButtons: showBothButtons,
      ),
    );
  }

  /// Convenience method for simple error display
  static Future<T?> showError<T>({
    required BuildContext context,
    required String message,
    String title = 'Error!',
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show<T>(
      context: context,
      title: title,
      message: message,
      primaryButtonText: buttonText,
      onPrimaryPressed: onPressed,
    );
  }

  /// Convenience method for confirmation dialog
  static Future<T?> showConfirmation<T>({
    required BuildContext context,
    required String message,
    String title = 'Confirm',
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return show<T>(
      context: context,
      title: title,
      message: message,
      primaryButtonText: confirmButtonText,
      onPrimaryPressed: onConfirm,
      dangerButtonText: cancelButtonText,
      onDangerPressed: onCancel,
      showBothButtons: true,
    );
  }

  /// Convenience method for warning display
  static Future<T?> showWarning<T>({
    required BuildContext context,
    required String message,
    String title = 'Warning!',
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show<T>(
      context: context,
      title: title,
      message: message,
      primaryButtonText: buttonText,
      onPrimaryPressed: onPressed,
    );
  }

  /// Convenience method for success display
  static Future<T?> showSuccess<T>({
    required BuildContext context,
    required String message,
    String title = 'Success!',
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return show<T>(
      context: context,
      title: title,
      message: message,
      primaryButtonText: buttonText,
      onPrimaryPressed: onPressed,
    );
  }
}