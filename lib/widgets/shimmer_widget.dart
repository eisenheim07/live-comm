import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border.withOpacity(0.3),
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border.withOpacity(0.3),
          borderRadius: borderRadius ?? BorderRadius.circular(SizeUtils.radius4),
        ),
      ),
    );
  }
}

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Header Shimmer
        _buildProfileHeaderShimmer(),
        SizedBox(height: SizeUtils.spacing32),
        
        // Profile Form Shimmer
        _buildProfileFormShimmer(),
      ],
    );
  }

  Widget _buildProfileHeaderShimmer() {
    return Center(
      child: Container(
        padding: SizeUtils.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            // Profile Avatar Shimmer
            ShimmerWidget(
              width: SizeUtils.getWidth(80),
              height: SizeUtils.getWidth(80),
              borderRadius: BorderRadius.circular(SizeUtils.getWidth(40)),
            ),
            SizedBox(height: SizeUtils.spacing16),

            // Name Shimmer
            ShimmerWidget(
              width: SizeUtils.getWidth(150),
              height: SizeUtils.getHeight(20),
              borderRadius: BorderRadius.circular(SizeUtils.radius4),
            ),
            SizedBox(height: SizeUtils.spacing8),

            // Email Shimmer
            ShimmerWidget(
              width: SizeUtils.getWidth(200),
              height: SizeUtils.getHeight(16),
              borderRadius: BorderRadius.circular(SizeUtils.radius4),
            ),
            SizedBox(height: SizeUtils.spacing8),

            // Role Badge Shimmer
            ShimmerWidget(
              width: SizeUtils.getWidth(80),
              height: SizeUtils.getHeight(24),
              borderRadius: BorderRadius.circular(SizeUtils.radius6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileFormShimmer() {
    return Container(
      padding: SizeUtils.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Shimmer
          Row(
            children: [
              ShimmerWidget(
                width: SizeUtils.getWidth(140),
                height: SizeUtils.getHeight(18),
                borderRadius: BorderRadius.circular(SizeUtils.radius4),
              ),
              const Spacer(),
              ShimmerWidget(
                width: SizeUtils.getWidth(20),
                height: SizeUtils.getWidth(20),
                borderRadius: BorderRadius.circular(SizeUtils.radius4),
              ),
            ],
          ),
          SizedBox(height: SizeUtils.spacing24),
          
          // Form Fields Shimmer
          _buildFormFieldShimmer(),
          SizedBox(height: SizeUtils.spacing16),
          _buildFormFieldShimmer(),
          SizedBox(height: SizeUtils.spacing16),
          _buildFormFieldShimmer(),
        ],
      ),
    );
  }

  Widget _buildFormFieldShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label Shimmer
        ShimmerWidget(
          width: SizeUtils.getWidth(100),
          height: SizeUtils.getHeight(14),
          borderRadius: BorderRadius.circular(SizeUtils.radius4),
        ),
        SizedBox(height: SizeUtils.spacing8),
        
        // Field Input Shimmer
        ShimmerWidget(
          width: double.infinity,
          height: SizeUtils.getHeight(48),
          borderRadius: BorderRadius.circular(SizeUtils.radius8),
        ),
      ],
    );
  }
}