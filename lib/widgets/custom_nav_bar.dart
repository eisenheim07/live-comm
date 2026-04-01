import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livecomm/utils/app_constants.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/navigation_state.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        int selectedIndex = 0;
        if (state is NavigationChanged) {
          selectedIndex = state.selectedIndex;
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(color: AppColors.border.withOpacity(0.3), blurRadius: SizeUtils.getHeight(8), offset: Offset(0, -SizeUtils.getHeight(2))),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: SizeUtils.getHeight(65), // Reduced height to prevent overflow
              padding: EdgeInsets.symmetric(
                horizontal: SizeUtils.spacing16,
                vertical: SizeUtils.spacing4, // Reduced vertical padding
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    index: 0,
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    label: 'Dashboard',
                    isSelected: selectedIndex == 0,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 1,
                    icon: Icons.shopping_cart_outlined,
                    activeIcon: Icons.shopping_cart,
                    label: 'Products',
                    isSelected: selectedIndex == 1,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 2,
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag,
                    label: 'Orders',
                    isSelected: selectedIndex == 2,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 3,
                    icon: Icons.account_circle_outlined,
                    activeIcon: Icons.account_circle,
                    label: 'Account',
                    isSelected: selectedIndex == 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<NavigationCubit>().changeTab(index);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeUtils.spacing4, // Reduced padding
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                isSelected ? activeIcon : icon,
                size: SizeUtils.getWidth(22), // Slightly smaller icon
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              // Label
              Text(
                label,
                style: AppTextStyles.bodySmall(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
