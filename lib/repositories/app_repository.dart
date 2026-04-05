import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';
import '../services/api_service.dart';
import '../utils/configs.dart';

class AppRepository {
  // Authentication APIs
  static Future<UserModel> login(LoginRequest request) async {
    try {
      return await ApiService.login(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred during login', statusCode: 0);
    }
  }

  // Registration API
  static Future<Map<String, dynamic>> signup(SignupRequest request) async {
    try {
      return await ApiService.signup(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred during signup', statusCode: 0);
    }
  }

  // Profile APIs
  static Future<UserModel> getProfile() async {
    try {
      return await ApiService.getProfile();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while fetching profile', statusCode: 0);
    }
  }

  // Products APIs
  static Future<List<ProductModel>> getProducts({String? category, String? isLive}) async {
    try {
      return await ApiService.getProducts(category: category, isLive: isLive);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while fetching products', statusCode: 0);
    }
  }

  // Get single product details by ID
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      return await ApiService.getProductDetails(productId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while fetching product details', statusCode: 0);
    }
  }

  // Delete product by ID
  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      return await ApiService.deleteProduct(productId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while deleting product', statusCode: 0);
    }
  }

  // Add new product
  static Future<ProductModel> addProduct({
    required String title,
    required String description,
    required double price,
    required double discountPrice,
    required int stock,
    required String imageUrl,
    required String categoryId,
    required bool isLiveProduct,
  }) async {
    try {
      final response = await ApiService.addProduct(
        title: title,
        description: description,
        price: price,
        discountPrice: discountPrice,
        stock: stock,
        imageUrl: imageUrl,
        categoryId: categoryId,
        isLiveProduct: isLiveProduct,
      );
      
      final productData = response['data'] ?? response;
      return ProductModel.fromJson(productData);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while adding product', statusCode: 0);
    }
  }

  // Update existing product
  static Future<ProductModel> updateProduct({
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
      final response = await ApiService.updateProduct(
        productId: productId,
        title: title,
        description: description,
        price: price,
        discountPrice: discountPrice,
        stock: stock,
        categoryId: categoryId,
        isLiveProduct: isLiveProduct,
      );
      
      final productData = response['data'] ?? response;
      return ProductModel.fromJson(productData);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while updating product', statusCode: 0);
    }
  }

  // Live Session APIs
  
  // Create live session
  Future<Map<String, dynamic>> createLiveSession({
    required String title,
    required DateTime startTime,
    String? thumbnail,
  }) async {
    try {
      return await ApiService.createLiveSession(
        title: title,
        startTime: startTime,
        thumbnail: thumbnail,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while creating live session', statusCode: 0);
    }
  }

  // Start live session
  Future<Map<String, dynamic>> startLiveSession(String liveId) async {
    try {
      return await ApiService.startLiveSession(liveId);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred while starting live session', statusCode: 0);
    }
  }
}
