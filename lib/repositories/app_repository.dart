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
}
