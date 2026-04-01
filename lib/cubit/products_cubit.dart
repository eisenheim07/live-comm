import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/app_repository.dart';
import '../utils/configs.dart';
import '../utils/app_logger.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsInitial());

  /// Fetch products from API
  Future<void> fetchProducts({String? category, String? isLive}) async {
    emit(const ProductsLoading());

    try {
      AppLogger.info('Fetching products data', 'Products');
      
      final products = await AppRepository.getProducts(
        category: category,
        isLive: isLive,
      );
      
      AppLogger.info('Products data received: ${products.length} products', 'Products');
      
      emit(ProductsLoaded(products));
    } on ApiException catch (e) {
      AppLogger.error('Products fetch API Error: ${e.message}', 'Products', e);
      emit(ProductsError(e.message, exception: e));
    } catch (e) {
      AppLogger.error('Products fetch Unexpected Error', 'Products', e);
      emit(const ProductsError('Failed to load products. Please try again.'));
    }
  }

  /// Refresh products (for pull-to-refresh)
  Future<void> refreshProducts({String? category, String? isLive}) async {
    final currentState = state;
    if (currentState is ProductsLoaded) {
      emit(ProductsRefreshing(currentState.products));
    }

    try {
      AppLogger.info('Refreshing products data', 'Products');
      
      final products = await AppRepository.getProducts(
        category: category,
        isLive: isLive,
      );
      
      AppLogger.info('Products refreshed: ${products.length} products', 'Products');
      
      emit(ProductsLoaded(products));
    } on ApiException catch (e) {
      AppLogger.error('Products refresh API Error: ${e.message}', 'Products', e);
      emit(ProductsError(e.message, exception: e));
    } catch (e) {
      AppLogger.error('Products refresh Unexpected Error', 'Products', e);
      emit(const ProductsError('Failed to refresh products. Please try again.'));
    }
  }

  /// Clear error state
  void clearError() {
    if (state is ProductsError) {
      emit(const ProductsInitial());
    }
  }
}