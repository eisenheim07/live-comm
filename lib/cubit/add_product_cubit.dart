import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/app_repository.dart';
import '../utils/configs.dart';
import '../utils/app_logger.dart';
import 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  /// Add new product
  Future<void> addProduct({
    required String title,
    required String description,
    required double price,
    required double discountPrice,
    required int stock,
    required String imageUrl,
    required String categoryId,
    required bool isLiveProduct,
  }) async {
    emit(AddProductLoading());

    try {
      AppLogger.info('Adding new product: $title', 'AddProduct');

      final product = await AppRepository.addProduct(
        title: title,
        description: description,
        price: price,
        discountPrice: discountPrice,
        stock: stock,
        imageUrl: imageUrl,
        categoryId: categoryId,
        isLiveProduct: isLiveProduct,
      );

      AppLogger.info('Product added successfully: ${product.title}', 'AddProduct');

      emit(AddProductSuccess(product));
    } on ApiException catch (e) {
      AppLogger.error('Add product API Error: ${e.message}', 'AddProduct', e);
      emit(AddProductError(e.message, exception: e));
    } catch (e) {
      AppLogger.error('Add product Unexpected Error', 'AddProduct', e);
      emit(AddProductError('Failed to add product. Please try again.'));
    }
  }

  /// Reset state
  void reset() {
    emit(AddProductInitial());
  }
}
