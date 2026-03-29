import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';
import '../repositories/app_repository.dart';
import '../services/storage_service.dart';
import '../utils/configs.dart';
import '../utils/app_logger.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());

    try {
      final loginRequest = LoginRequest(email: email, password: password);
      final user = await AppRepository.login(loginRequest);

      // Debug logging
      AppLogger.logObject('User received', user, 'Login');
      AppLogger.debug('User token: ${user.token}', 'Login');

      // Store user data and token
      await StorageService.saveUser(user);
      
      // Verify user was saved
      final savedUser = await StorageService.getUser();
      AppLogger.logObject('User saved', savedUser, 'Login');
      AppLogger.debug('Saved user token: ${savedUser?.token}', 'Login');

      emit(AuthSuccess(user));
    } on ApiException catch (e) {
      AppLogger.error('Login API Error: ${e.message}', 'Login', e);
      emit(AuthError(e.message, exception: e));
    } catch (e) {
      AppLogger.error('Login Unexpected Error', 'Login', e);
      emit(const AuthError('An unexpected error occurred. Please try again.'));
    }
  }

  void clearError() {
    if (state is AuthError) {
      emit(const AuthInitial());
    }
  }
}
