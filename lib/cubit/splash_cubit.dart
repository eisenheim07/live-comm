import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/storage_service.dart';
import '../utils/app_logger.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  /// Check user authentication status and navigate accordingly
  Future<void> checkAuthenticationStatus() async {
    emit(const SplashLoading());

    try {
      // Add a small delay for splash screen visibility
      await Future.delayed(const Duration(seconds: 2));

      // Check if user is stored in preferences
      final user = await StorageService.getUser();
      
      // Debug logging
      AppLogger.debug('User: $user', 'Splash');
      
      if (user != null) {
        // User exists - navigate to dashboard
        AppLogger.success('User exists - navigating to dashboard', 'Splash');
        emit(const SplashAuthenticated());
      } else {
        // User is null - navigate to login
        AppLogger.info('User is null - navigating to login', 'Splash');
        emit(const SplashUnauthenticated());
      }
    } catch (e) {
      // On any error, navigate to login screen
      AppLogger.error('Error checking authentication', 'Splash', e);
      emit(const SplashUnauthenticated());
    }
  }
}