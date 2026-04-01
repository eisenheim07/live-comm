import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product_model.dart';
import '../repositories/app_repository.dart';
import '../utils/app_logger.dart';
import '../utils/configs.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final AppRepository _repository = AppRepository();

  ProductDetailsCubit() : super(ProductDetailsInitial());

  // Fetch product details by ID from API
  Future<void> fetchProductDetails(String productId) async {
    try {
      emit(ProductDetailsLoading());
      AppLogger.info('Fetching product details for ID: $productId');

      final response = await _repository.getProductDetails(productId);

      if (response['success'] == true && response['data'] != null) {
        final product = ProductModel.fromJson(response['data']);
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
    AppLogger.info('Loading product from existing data: ${product.title}');
    emit(ProductDetailsLoaded(product));
  }
}
