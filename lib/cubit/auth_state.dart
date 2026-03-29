import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserModel user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  final dynamic exception;

  const AuthError(this.message, {this.exception});

  @override
  List<Object?> get props => [message, exception];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

class AuthOtpSent extends AuthState {
  const AuthOtpSent();
}