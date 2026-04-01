import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livecomm/utils/app_constants.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';

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
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Back Button
          if (showBackButton) ...[
            GestureDetector(
              onTap: onBackPressed ?? () => _handleBackPress(context),
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

  // Handle back press with same logic as main navigation
  void _handleBackPress(BuildContext context) {
    try {
      // Try to get the NavigationCubit from context
      final navigationCubit = context.read<NavigationCubit>();
      final currentState = navigationCubit.state;
      
      int selectedIndex = 0;
      if (currentState is NavigationChanged) {
        selectedIndex = currentState.selectedIndex;
      }
      
      if (selectedIndex != 0) {
        // If not on Dashboard, navigate to Dashboard first
        navigationCubit.goToDashboard();
      } else {
        // If on Dashboard, exit app
        Navigator.of(context).pop();
      }
    } catch (e) {
      // If NavigationCubit is not available, fall back to normal pop
      Navigator.of(context).pop();
    }
  }
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