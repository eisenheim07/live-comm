import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livecomm/screens/product_details.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/app_text_styles.dart';
import '../utils/size_utils.dart';
import '../utils/configs.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/error_bottom_sheet.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProductsScreenView();
  }
}

class ProductsScreenView extends StatelessWidget {
  const ProductsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductsError) {
          final exception = state.exception;
          if (exception is ApiException) {
            ErrorBottomSheet.showError(context: context, title: exception.errorTitle, message: exception.displayMessage, buttonText: 'Got it');
          } else {
            ErrorBottomSheet.showError(context: context, title: 'Error!', message: state.message, buttonText: 'Got it');
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBarFactory.create(title: 'My Products', showBackButton: true),
          body: Padding(padding: SizeUtils.scaffoldPaddingSmall, child: _buildBody(context, state)),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductsState state) {
    if (state is ProductsLoading) {
      return _buildLoadingState();
    } else if (state is ProductsLoaded || state is ProductsRefreshing || state is ProductsDeleting) {
      final products = state is ProductsLoaded 
          ? state.products 
          : state is ProductsRefreshing 
              ? state.products 
              : (state as ProductsDeleting).products;

      final isShowingShimmer = state is ProductsRefreshing || state is ProductsDeleting;

      return _buildProductsList(context, products, isShowingShimmer);
    } else if (state is ProductsError) {
      return _buildErrorState(context);
    } else {
      return _buildEmptyState();
    }
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: SizeUtils.scaffoldPadding,
      child: ListView.builder(itemCount: 5, itemBuilder: (context, index) => _buildProductShimmer()),
    );
  }

  Widget _buildProductShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeUtils.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(SizeUtils.radius12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          _ShimmerBox(
            width: double.infinity,
            height: SizeUtils.getHeight(200),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(SizeUtils.radius12), topRight: Radius.circular(SizeUtils.radius12)),
          ),

          // Content shimmer
          Padding(
            padding: SizeUtils.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _ShimmerBox(width: SizeUtils.getWidth(100), height: SizeUtils.getHeight(14)),
                    const Spacer(),
                    _ShimmerBox(width: SizeUtils.getWidth(40), height: SizeUtils.getHeight(20)),
                  ],
                ),
                AppConstants.smallVerticalSpace,
                _ShimmerBox(width: SizeUtils.getWidth(200), height: SizeUtils.getHeight(18)),
                AppConstants.smallVerticalSpace,
                _ShimmerBox(width: double.infinity, height: SizeUtils.getHeight(14)),
                AppConstants.mediumVerticalSpace,
                Row(
                  children: [
                    _ShimmerBox(width: SizeUtils.getWidth(80), height: SizeUtils.getHeight(16)),
                    const Spacer(),
                    _ShimmerBox(width: SizeUtils.getWidth(60), height: SizeUtils.getHeight(24)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, List products, bool isRefreshing) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => context.read<ProductsCubit>().refreshProducts(),
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: Stack(
        children: [
          ListView.builder(
            padding: SizeUtils.scaffoldPaddingSmall,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(product: product, productId: product.id),
                    ),
                  );
                  
                  if (result == true) {
                    context.read<ProductsCubit>().fetchProducts();
                  }
                },
                onDelete: () {
                  _showDeleteConfirmation(context, product);
                },
              );
            },
          ),

          // Show shimmer overlay during refresh or delete
          if (isRefreshing)
            Container(
              color: AppColors.background,
              child: ListView.builder(padding: SizeUtils.scaffoldPaddingSmall, itemCount: 3, itemBuilder: (context, index) => _buildProductShimmer()),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: SizeUtils.scaffoldPaddingSmall,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: SizeUtils.getWidth(64), color: AppColors.error),
            AppConstants.mediumVerticalSpace,
            Text(
              'Failed to load products',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            AppConstants.smallVerticalSpace,
            Text('Please try again', style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
            AppConstants.largeVerticalSpace,
            ElevatedButton(
              onPressed: () => context.read<ProductsCubit>().fetchProducts(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing24, vertical: SizeUtils.spacing12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius8)),
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.bodyMedium(color: AppColors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: SizeUtils.scaffoldPaddingSmall,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: SizeUtils.getWidth(64), color: AppColors.textSecondary),
            AppConstants.mediumVerticalSpace,
            Text(
              'No Products Found',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            AppConstants.smallVerticalSpace,
            Text('You haven\'t added any products yet', style: AppTextStyles.bodyMedium(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius12)),
          title: Text(
            'Delete Product',
            style: AppTextStyles.titleMedium(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to delete "${product.title ?? 'this product'}"? This action cannot be undone.',
            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (product.id != null) {
                  context.read<ProductsCubit>().deleteProduct(product.id!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: SizeUtils.spacing16, vertical: SizeUtils.spacing8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeUtils.radius8)),
              ),
              child: Text(
                'Delete',
                style: AppTextStyles.bodyMedium(color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Shimmer Widget for Loading State
class _ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const _ShimmerBox({this.width, required this.height, this.borderRadius});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(SizeUtils.radius8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [AppColors.border.withOpacity(0.3), AppColors.border.withOpacity(0.5), AppColors.border.withOpacity(0.3)],
              stops: [_animation.value - 0.3, _animation.value, _animation.value + 0.3].map((stop) => stop.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}
