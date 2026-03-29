import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/signup_request.dart';
import '../repositories/app_repository.dart';
import '../utils/configs.dart';
import '../utils/app_logger.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(const SignupInitial());

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? shopName,
    String? gstNumber,
  }) async {
    emit(const SignupLoading());

    try {
      final signupRequest = SignupRequest(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
        shopName: shopName,
        gstNumber: gstNumber,
      );

      AppLogger.logObject('Signup request', signupRequest.toJson(), 'Signup');

      final response = await AppRepository.signup(signupRequest);

      AppLogger.logObject('Signup response', response, 'Signup');

      // Check if signup was successful
      final success = response['success'] ?? false;
      if (success) {
        final message = response['message'] ?? 'Account created successfully!';
        AppLogger.success('Signup successful: $message', 'Signup');
        emit(SignupSuccess(message));
      } else {
        final errorMessage = response['message'] ?? 'Signup failed';
        AppLogger.error('Signup failed: $errorMessage', 'Signup');
        emit(SignupError(errorMessage));
      }
    } on ApiException catch (e) {
      AppLogger.error('Signup API Error: ${e.message}', 'Signup', e);
      emit(SignupError(e.message, exception: e));
    } catch (e) {
      AppLogger.error('Signup Unexpected Error', 'Signup', e);
      emit(const SignupError('An unexpected error occurred. Please try again.'));
    }
  }

  void clearError() {
    if (state is SignupError) {
      emit(const SignupInitial());
    }
  }
}