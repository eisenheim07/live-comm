import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
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
        // User exists - check permissions
        AppLogger.success('User exists - checking permissions', 'Splash');
        await checkPermissions();
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

  /// Check camera and microphone permissions
  Future<void> checkPermissions() async {
    emit(const SplashCheckingPermissions());

    try {
      AppLogger.info('Checking camera and microphone permissions', 'Splash');

      final cameraStatus = await Permission.camera.status;
      final microphoneStatus = await Permission.microphone.status;

      AppLogger.debug('Camera permission: ${cameraStatus.name}', 'Splash');
      AppLogger.debug('Microphone permission: ${microphoneStatus.name}', 'Splash');

      if (cameraStatus.isGranted && microphoneStatus.isGranted) {
        // Both permissions granted - navigate to dashboard
        AppLogger.success('All permissions granted - navigating to dashboard', 'Splash');
        emit(const SplashPermissionsGranted());
      } else {
        // Permissions not granted - navigate to permission screen
        AppLogger.info('Permissions not granted - navigating to permission screen', 'Splash');
        emit(const SplashPermissionsDenied());
      }
    } catch (e) {
      // On error, navigate to permission screen to be safe
      AppLogger.error('Error checking permissions', 'Splash', e);
      emit(const SplashPermissionsDenied());
    }
  }
}