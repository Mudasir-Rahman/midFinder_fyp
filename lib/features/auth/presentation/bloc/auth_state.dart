import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entities.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthRoleSelected extends AuthState {
  final String role;
  const AuthRoleSelected(this.role);

  @override
  List<Object?> get props => [role];
}
class AuthRegistrationCheck extends AuthState {
  final UserEntity user;
  const AuthRegistrationCheck(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthRegistrationComplete extends AuthState {
  final UserEntity user;
  const AuthRegistrationComplete(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthRegistrationIncomplete extends AuthState {
  final UserEntity user;
  const AuthRegistrationIncomplete(this.user);

  @override
  List<Object?> get props => [user];
}