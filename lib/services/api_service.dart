import 'package:livecomm/utils/configs.dart';

import '../services/http_service.dart';
import '../services/service_locator_simple.dart';
import '../models/user_model.dart';
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
}
