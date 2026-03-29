import '../models/user_model.dart';
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
      throw ApiException(
        message: 'An unexpected error occurred during login',
        statusCode: 0,
      );
    }
  }

  // Registration API
  static Future<Map<String, dynamic>> signup(SignupRequest request) async {
    try {
      return await ApiService.signup(request);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'An unexpected error occurred during signup',
        statusCode: 0,
      );
    }
  }
}