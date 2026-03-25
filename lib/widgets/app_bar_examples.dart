import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import 'custom_app_bar.dart';

class AppBarExamplesScreen extends StatelessWidget {
  const AppBarExamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SizeUtils.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom AppBar Examples',
                style: AppTextStyles.headlineLarge(color: AppColors.textPrimary),
              ),
              AppConstants.largeVerticalSpace,
              
              // Logo AppBar Example
              Text(
                '1. Logo AppBar (without back button)',
                style: AppTextStyles.titleMedium(color: AppColors.textPrimary),
              ),
              AppConstants.smallVerticalSpace,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                ),
                child: CustomAppBarFactory.logo(
                  showBackButton: false,
                ),
              ),
              AppConstants.mediumVerticalSpace,
              
              // Logo AppBar with Back Button Example
              Text(
                '2. Logo AppBar (with back button)',
                style: AppTextStyles.titleMedium(color: AppColors.textPrimary),
              ),
              AppConstants.smallVerticalSpace,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                ),
                child: CustomAppBarFactory.logo(
                  showBackButton: true,
                  onBackPressed: () {
                    // Custom back action
                    print('Custom back pressed');
                  },
                ),
              ),
              AppConstants.mediumVerticalSpace,
              
              // Text AppBar Example
              Text(
                '3. Text AppBar (without back button)',
                style: AppTextStyles.titleMedium(color: AppColors.textPrimary),
              ),
              AppConstants.smallVerticalSpace,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                ),
                child: CustomAppBarFactory.text(
                  title: 'Bazaars',
                  showBackButton: false,
                ),
              ),
              AppConstants.mediumVerticalSpace,
              
              // Text AppBar with Back Button Example
              Text(
                '4. Text AppBar (with back button)',
                style: AppTextStyles.titleMedium(color: AppColors.textPrimary),
              ),
              AppConstants.smallVerticalSpace,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(SizeUtils.radius8),
                ),
                child: CustomAppBarFactory.text(
                  title: 'Johari Bazaar',
                  showBackButton: true,
                  onBackPressed: () {
                    // Custom back action
                    print('Custom back pressed');
                  },
                ),
              ),
              AppConstants.largeVerticalSpace,
              
              // Usage Instructions
              Text(
                'Usage Instructions:',
                style: AppTextStyles.titleMedium(color: AppColors.textPrimary),
              ),
              AppConstants.smallVerticalSpace,
              Text(
                '• Use CustomAppBarFactory.logo() for logo-based app bars\n'
                '• Use CustomAppBarFactory.text() for text-based app bars\n'
                '• Set showBackButton: true to display back button\n'
                '• Provide onBackPressed callback for custom back actions\n'
                '• AppBar automatically handles SafeArea and responsive sizing',
                style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}