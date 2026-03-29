import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_app_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarFactory.create(title: 'Orders', showBackButton: true),
      body: Padding(
        padding: SizeUtils.scaffoldPaddingSmall,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: SizeUtils.getWidth(80),
                color: AppColors.primary,
              ),
              AppConstants.largeVerticalSpace,
              Text(
                'Orders',
                style: AppTextStyles.headlineLarge(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppConstants.mediumVerticalSpace,
              Text(
                'Your orders will appear here',
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}