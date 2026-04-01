import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../models/product_model.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_constants.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final bool isShimmer;

  const ProductCard({super.key, required this.product, this.onTap, this.isShimmer = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: SizeUtils.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(SizeUtils.radius12),
          border: Border.all(color: AppColors.border),
          boxShadow: [BoxShadow(color: AppColors.textSecondary.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            _buildProductImage(),

            // Product Details
            Padding(
              padding: SizeUtils.cardPaddingSmall,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name & Live Status
                  _buildShopNameAndStatus(),
                  AppConstants.smallVerticalSpace,

                  // Product Title
                  _buildProductTitle(),
                  AppConstants.smallVerticalSpace,

                  // Product Description
                  _buildProductDescription(),
                  AppConstants.smallVerticalSpace,

                  // Price & Stock Row
                  _buildPriceAndStock(),
                  AppConstants.smallVerticalSpace,

                  // Category & Date Row
                  _buildCategoryAndDate(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: SizeUtils.getHeight(200),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.border.withOpacity(0.1),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(SizeUtils.radius4), topRight: Radius.circular(SizeUtils.radius4)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(SizeUtils.radius4), topRight: Radius.circular(SizeUtils.radius4)),
        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
            ? Image.network(
                product.imageUrl!,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.border.withOpacity(0.1),
      child: Center(
        child: Icon(Icons.image_outlined, size: SizeUtils.getWidth(48), color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildLoadingImage() {
    return Container(
      color: AppColors.border.withOpacity(0.1),
      child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
    );
  }

  Widget _buildShopNameAndStatus() {
    return Row(
      children: [
        Expanded(
          child: Text(
            product.shopName ?? 'Unknown Shop',
            style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (product.isLiveProduct == true) ...[
          AppConstants.smallHorizontalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing8, vertical: SizeUtils.spacing4),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius4)),
            child: Text(
              'LIVE',
              style: AppTextStyles.bodySmall(color: AppColors.success, fontWeight: FontWeight.w600),
            ),
          ),
        ] else ...[
          AppConstants.smallHorizontalSpace, // Keep this as it's smaller than available AppConstants
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing8, vertical: SizeUtils.spacing4),
            decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(SizeUtils.radius4)),
            child: Text(
              'CLOSED',
              style: AppTextStyles.bodySmall(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProductTitle() {
    return Text(
      product.title ?? 'Untitled Product',
      style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProductDescription() {
    if (product.description == null || product.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      product.description!,
      style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndStock() {
    return Row(
      children: [
        // Price Section
        Expanded(child: _buildPriceSection()),

        // Stock Section
        _buildStockSection(),
      ],
    );
  }

  Widget _buildPriceSection() {
    final hasDiscount = product.discountPrice != null && product.discountPrice! > 0 && product.discountPrice! < (product.price ?? 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDiscount) ...[
          // Discount Percentage Badge
          Container(
            margin: EdgeInsets.only(bottom: SizeUtils.spacing2),
            padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing4, vertical: SizeUtils.spacing2),
            decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(SizeUtils.radius4)),
            child: Text(
              '${_calculateDiscountPercentage(product.price!, product.discountPrice!)}% OFF',
              style: AppTextStyles.bodySmall(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: SizeUtils.getFontSize(8)),
            ),
          ),

          // Discounted Price
          Row(
            children: [
              Text(
                _formatIndianPrice(product.discountPrice!),
                style: AppTextStyles.titleMedium(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
              AppConstants.smallHorizontalSpace,
              // Original Price (strikethrough with better visibility)
              Text(
                _formatIndianPrice(product.price!),
                style: AppTextStyles.bodySmall(color: AppColors.textSecondary, fontWeight: FontWeight.w400, lineThrough: true),
              ),
            ],
          ),
        ] else ...[
          // Regular Price
          Text(
            _formatIndianPrice(product.price ?? 0),
            style: AppTextStyles.titleMedium(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ],
      ],
    );
  }

  Widget _buildStockSection() {
    final stock = product.stock ?? 0;
    final isOutOfStock = stock <= 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing8, vertical: SizeUtils.spacing4),
      decoration: BoxDecoration(
        color: isOutOfStock ? AppColors.error.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SizeUtils.radius4),
      ),
      child: Text(
        isOutOfStock ? 'Out of Stock' : 'Stock: $stock',
        style: AppTextStyles.bodySmall(color: isOutOfStock ? AppColors.error : AppColors.primary, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCategoryAndDate() {
    return Row(
      children: [
        // Category
        if (product.categoryId != null && product.categoryId!.isNotEmpty) ...[
          Icon(Icons.category_outlined, size: SizeUtils.getWidth(14), color: AppColors.textSecondary),
          AppConstants.smallHorizontalSpace,
          Text('Category: ${product.categoryId}', style: AppTextStyles.bodySmall(color: AppColors.textSecondary)),
        ],

        const Spacer(),

        // Date
        if (product.createdAt != null) ...[
          Icon(Icons.access_time, size: SizeUtils.getWidth(14), color: AppColors.textSecondary),
          AppConstants.smallHorizontalSpace,
          Text(_formatDate(product.createdAt!), style: AppTextStyles.bodySmall(color: AppColors.textSecondary)),
        ],
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  String _formatIndianPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return formatter.format(price);
  }

  int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice <= 0) return 0;
    final discount = ((originalPrice - discountPrice) / originalPrice) * 100;
    return discount.round();
  }
}
