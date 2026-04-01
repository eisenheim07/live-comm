import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';
import '../services/storage_service.dart';
import '../widgets/custom_app_bar.dart';
import 'profile_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBarFactory.create(title: 'Accounts', showBackButton: true),
      body: SingleChildScrollView(
        padding: SizeUtils.scaffoldPaddingSmall,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Header
            AppConstants.extraLargeVerticalSpace,
            _buildUserProfileHeader(),
            AppConstants.extraLargeVerticalSpace,

            // Menu Items
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader() {
    final user = StorageService.user;

    return Container(
      padding: SizeUtils.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: SizeUtils.getWidth(60),
            height: SizeUtils.getWidth(60),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Icon(Icons.person, size: SizeUtils.getWidth(30), color: AppColors.primary),
          ),
          AppConstants.mediumHorizontalSpace,

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'User Name',
                  style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                ),
                // AppConstants.smallVerticalSpace,
                Text(user?.email ?? 'user@example.com', style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
                AppConstants.smallVerticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing8, vertical: SizeUtils.spacing4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius4)),
                  child: Text(
                    user?.role?.toUpperCase() ?? 'USER',
                    style: AppTextStyles.bodySmall(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu',
          style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
        AppConstants.mediumVerticalSpace,

        // Menu Items Container
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(SizeUtils.radius12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                context: context,
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle: 'Manage your profile information',
                onTap: () => _navigateToProfile(context),
                showDivider: true,
              ),
              _buildMenuItem(
                context: context,
                icon: Icons.receipt_long_outlined,
                title: 'Transactions',
                subtitle: 'View your transaction history',
                onTap: () => _navigateToTransactions(context),
                showDivider: true,
              ),
              _buildMenuItem(
                context: context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'App preferences and configurations',
                onTap: () => _navigateToSettings(context),
                showDivider: true,
              ),
              _buildMenuItem(
                context: context,
                icon: Icons.inventory_2_outlined,
                title: 'Products',
                subtitle: 'Manage your products and inventory',
                onTap: () => _navigateToProducts(context),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(SizeUtils.radius12),
            child: Padding(
              padding: SizeUtils.cardPadding,
              child: Row(
                children: [
                  // Icon Container
                  Container(
                    width: SizeUtils.getWidth(40),
                    height: SizeUtils.getWidth(40),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius8)),
                    child: Icon(icon, size: SizeUtils.getWidth(20), color: AppColors.primary),
                  ),
                  AppConstants.mediumHorizontalSpace,

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.titleSmall(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                        ),
                        Text(subtitle, style: AppTextStyles.bodySmall(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),

                  // Arrow Icon
                  Icon(Icons.arrow_forward_ios, size: SizeUtils.getWidth(16), color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),

        // Divider
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.getWidth(24)),
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),
      ],
    );
  }

  // Navigation methods
  void _navigateToProfile(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
  }

  void _navigateToTransactions(BuildContext context) {
    // TODO: Navigate to Transactions screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Transactions screen will be implemented'), backgroundColor: AppColors.primary));
  }

  void _navigateToSettings(BuildContext context) {
    // TODO: Navigate to Settings screen
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Settings screen will be implemented'), backgroundColor: AppColors.primary));
  }

  void _navigateToProducts(BuildContext context) {
    // TODO: Navigate to Products screen
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Products screen will be implemented'), backgroundColor: AppColors.primary));
  }
}
