import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../repositories/app_repository.dart';
import '../utils/app_logger.dart';
import '../utils/configs.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final AppRepository _repository = AppRepository();
  ProductModel? _currentProduct;

  ProductDetailsCubit() : super(ProductDetailsInitial());

  // Fetch product details by ID from API
  Future<void> fetchProductDetails(String productId) async {
    try {
      emit(ProductDetailsLoading());
      AppLogger.info('Fetching product details for ID: $productId');

      final response = await _repository.getProductDetails(productId);

      if (response['success'] == true && response['data'] != null) {
        final product = ProductModel.fromJson(response['data']);
        _currentProduct = product;
        AppLogger.info('Product details fetched successfully: ${product.title}');
        emit(ProductDetailsLoaded(product));
      } else {
        final errorMessage = response['message'] ?? 'Failed to load product details';
        AppLogger.error('Product details fetch failed: $errorMessage');
        emit(ProductDetailsError(errorMessage));
      }
    } on ApiException catch (e) {
      AppLogger.error('Product details API Error: ${e.displayMessage}');
      emit(ProductDetailsError(e.displayMessage, exception: e));
    } catch (e) {
      AppLogger.error('Product details Error: $e');
      emit(ProductDetailsError('An unexpected error occurred', exception: e));
    }
  }

  // Load product from existing data (if already available)
  void loadProduct(ProductModel product) {
    _currentProduct = product;
    AppLogger.info('Loading product from existing data: ${product.title}');
    emit(ProductDetailsLoaded(product));
  }

  // Update product
  Future<void> updateProduct({
    required String productId,
    required String title,
    required String description,
    required double price,
    required double discountPrice,
    required int stock,
    required String categoryId,
    required bool isLiveProduct,
  }) async {
    try {
      emit(ProductDetailsUpdating());
      AppLogger.info('Updating product: $productId', 'ProductDetails');

      final product = await AppRepository.updateProduct(
        productId: productId,
        title: title,
        description: description,
        price: price,
        discountPrice: discountPrice,
        stock: stock,
        categoryId: categoryId,
        isLiveProduct: isLiveProduct,
      );

      _currentProduct = product;
      AppLogger.info('Product updated successfully: ${product.title}', 'ProductDetails');
      emit(ProductDetailsUpdateSuccess(product));
    } on ApiException catch (e) {
      AppLogger.error('Update product API Error: ${e.message}', 'ProductDetails', e);
      // Return to loaded state with current product data and error info
      if (_currentProduct != null) {
        emit(ProductDetailsUpdateError(_currentProduct!, e.message, exception: e));
      } else {
        emit(ProductDetailsError(e.message, exception: e));
      }
    } catch (e) {
      AppLogger.error('Update product Unexpected Error', 'ProductDetails', e);
      // Return to loaded state with current product data and error info
      if (_currentProduct != null) {
        emit(ProductDetailsUpdateError(_currentProduct!, 'Failed to update product. Please try again.'));
      } else {
        emit(ProductDetailsError('Failed to update product. Please try again.'));
      }
    }
  }
}
