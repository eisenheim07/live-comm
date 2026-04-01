import 'package:livecomm/utils/configs.dart';

import '../services/http_service.dart';
import '../services/service_locator_simple.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/login_request.dart';
import '../models/signup_request.dart';

class ApiService {
  // HTTP Service instance (injected via service locator)
  static HttpService get _httpService => serviceLocator.httpService;

  // Authentication Endpoints
  static Future<UserModel> login(LoginRequest request) async {
    try {
      final response = await _httpService.post(endpoint: ApiConfig.LOGIN, body: request.toJson());

      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Registration Endpoint
  static Future<Map<String, dynamic>> signup(SignupRequest request) async {
    try {
      final response = await _httpService.post(
        endpoint: ApiConfig.REGISTER,
        body: request.toJson(),
      );
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Profile Endpoints
  static Future<UserModel> getProfile() async {
    try {
      final response = await _httpService.get(
        endpoint: ApiConfig.PROFILE,
        headers: await _getAuthHeaders(),
      );
      
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Products Endpoints
  static Future<List<ProductModel>> getProducts({String? category, String? isLive}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (isLive != null && isLive.isNotEmpty) {
        queryParams['is_live'] = isLive;
      }

      final response = await _httpService.get(
        endpoint: ApiConfig.PRODUCTS,
        headers: await _getAuthHeaders(),
        queryParameters: queryParams,
      );
      
      final List<dynamic> productsData = response['data'] ?? response;
      return productsData.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get single product details by ID
  static Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final response = await _httpService.get(
        endpoint: '${ApiConfig.PRODUCTS}/$productId',
        headers: await _getAuthHeaders(),
      );
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete product by ID
  static Future<Map<String, dynamic>> deleteProduct(String productId) async {
    try {
      final response = await _httpService.delete(
        endpoint: '${ApiConfig.DELETE_PRODUCT}/$productId',
        headers: await _getAuthHeaders(),
      );
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to get authorization headers
  static Future<Map<String, String>> _getAuthHeaders() async {
    final user = await StorageService.getUser();
    final token = user?.token;
    
    if (token == null || token.isEmpty) {
      throw const ApiException(
        message: 'Authentication token not found. Please login again.',
        statusCode: 401,
      );
    }
    
    return {
      'Authorization': 'Bearer $token',
    };
  }
}
