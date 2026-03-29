import 'package:flutter/material.dart';
import 'package:livecomm/utils/app_constants.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final double? fontSize;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      toolbarHeight: SizeUtils.getHeight(50),
      title: Row(
        children: [
          // Back Button
          if (showBackButton) ...[
            GestureDetector(
              onTap: onBackPressed ?? () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(SizeUtils.spacing8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.primary,
                  size: SizeUtils.getWidth(16),
                ),
              ),
            ),
            AppConstants.mediumHorizontalSpace
          ],
          
          // Title Text
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ).copyWith(
                  fontSize: fontSize ?? SizeUtils.font14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(SizeUtils.getHeight(50));
}

// Factory constructor for easier usage
class CustomAppBarFactory {
  static CustomAppBar create({
    required String title,
    bool showBackButton = false,
    VoidCallback? onBackPressed,
    Color? backgroundColor,
    double? fontSize,
  }) {
    return CustomAppBar(
      title: title,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
    );
  }
}