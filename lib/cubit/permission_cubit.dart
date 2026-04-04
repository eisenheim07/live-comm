import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import '../utils/app_logger.dart';
import 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  CameraController? _cameraController;
  bool _isCameraGranted = false;
  bool _isMicrophoneGranted = false;

  PermissionCubit() : super(const PermissionInitial());

  /// Check current permission status
  Future<void> checkPermissions() async {
    emit(const PermissionChecking());

    try {
      final cameraStatus = await Permission.camera.status;
      final micStatus = await Permission.microphone.status;

      _isCameraGranted = cameraStatus.isGranted;
      _isMicrophoneGranted = micStatus.isGranted;

      AppLogger.info('Camera: ${cameraStatus.name}, Microphone: ${micStatus.name}', 'Permission');

      // Initialize camera if permission granted
      if (_isCameraGranted) {
        await _initializeCamera();
      } else {
        emit(PermissionStatusUpdated(
          isCameraGranted: _isCameraGranted,
          isMicrophoneGranted: _isMicrophoneGranted,
        ));
      }
    } catch (e) {
      AppLogger.error('Error checking permissions', 'Permission', e);
      emit(PermissionError('Failed to check permissions: $e'));
    }
  }

  /// Initialize camera for preview
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        AppLogger.warning('No cameras available', 'Permission');
        emit(PermissionStatusUpdated(
          isCameraGranted: _isCameraGranted,
          isMicrophoneGranted: _isMicrophoneGranted,
        ));
        return;
      }

      // Use front camera if available, otherwise use first camera
      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      AppLogger.success('Camera initialized successfully', 'Permission');

      emit(PermissionStatusUpdated(
        isCameraGranted: _isCameraGranted,
        isMicrophoneGranted: _isMicrophoneGranted,
        cameraController: _cameraController,
      ));
    } catch (e) {
      AppLogger.error('Error initializing camera', 'Permission', e);
      emit(PermissionStatusUpdated(
        isCameraGranted: _isCameraGranted,
        isMicrophoneGranted: _isMicrophoneGranted,
      ));
    }
  }

  /// Request camera permission
  Future<void> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      _isCameraGranted = status.isGranted;

      AppLogger.info('Camera permission: ${status.name}', 'Permission');

      if (status.isPermanentlyDenied) {
        AppLogger.warning('Camera permission permanently denied', 'Permission');
        openAppSettings();
      }

      // Initialize camera if granted
      if (_isCameraGranted) {
        await _initializeCamera();
      } else {
        emit(PermissionStatusUpdated(
          isCameraGranted: _isCameraGranted,
          isMicrophoneGranted: _isMicrophoneGranted,
        ));
      }
    } catch (e) {
      AppLogger.error('Error requesting camera permission', 'Permission', e);
      emit(PermissionError('Failed to request camera permission: $e'));
    }
  }

  /// Request microphone permission
  Future<void> requestMicrophonePermission() async {
    try {
      final status = await Permission.microphone.request();
      _isMicrophoneGranted = status.isGranted;

      AppLogger.info('Microphone permission: ${status.name}', 'Permission');

      if (status.isPermanentlyDenied) {
        AppLogger.warning('Microphone permission permanently denied', 'Permission');
        openAppSettings();
      }

      emit(PermissionStatusUpdated(
        isCameraGranted: _isCameraGranted,
        isMicrophoneGranted: _isMicrophoneGranted,
        cameraController: _cameraController,
      ));
    } catch (e) {
      AppLogger.error('Error requesting microphone permission', 'Permission', e);
      emit(PermissionError('Failed to request microphone permission: $e'));
    }
  }

  /// Dispose camera controller
  Future<void> disposeCamera() async {
    try {
      await _cameraController?.dispose();
      _cameraController = null;
      AppLogger.info('Camera disposed', 'Permission');
    } catch (e) {
      AppLogger.error('Error disposing camera', 'Permission', e);
    }
  }

  @override
  Future<void> close() {
    disposeCamera();
    return super.close();
  }
}
