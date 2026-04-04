import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashCheckingPermissions extends SplashState {
  const SplashCheckingPermissions();
}

class SplashPermissionsGranted extends SplashState {
  const SplashPermissionsGranted();
}

class SplashPermissionsDenied extends SplashState {
  const SplashPermissionsDenied();
}

class SplashAuthenticated extends SplashState {
  const SplashAuthenticated();
}

class SplashUnauthenticated extends SplashState {
  const SplashUnauthenticated();
}