import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object?> get props => [];
}

class PermissionInitial extends PermissionState {
  const PermissionInitial();
}

class PermissionChecking extends PermissionState {
  const PermissionChecking();
}

class PermissionStatusUpdated extends PermissionState {
  final bool isCameraGranted;
  final bool isMicrophoneGranted;
  final CameraController? cameraController;

  const PermissionStatusUpdated({
    required this.isCameraGranted,
    required this.isMicrophoneGranted,
    this.cameraController,
  });

  @override
  List<Object?> get props => [isCameraGranted, isMicrophoneGranted, cameraController];
}

class PermissionError extends PermissionState {
  final String message;

  const PermissionError(this.message);

  @override
  List<Object?> get props => [message];
}

class PermissionAllGranted extends PermissionState {
  const PermissionAllGranted();
}
