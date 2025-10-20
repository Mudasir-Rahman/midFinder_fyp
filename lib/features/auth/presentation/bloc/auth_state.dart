import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entities.dart';

abstract class AppAuthState extends Equatable {
  const AppAuthState(); // Fixed: Changed from AuthState to AppAuthState

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AppAuthState {} // Fixed: extends AppAuthState

class AuthLoading extends AppAuthState {} // Fixed: extends AppAuthState

class AuthAuthenticated extends AppAuthState { // Fixed: extends AppAuthState
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AppAuthState {} // Fixed: extends AppAuthState

class AuthError extends AppAuthState { // Fixed: extends AppAuthState
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthRoleSelected extends AppAuthState { // Fixed: extends AppAuthState
  final String role;
  const AuthRoleSelected(this.role);

  @override
  List<Object?> get props => [role];
}

class AuthRegistrationCheck extends AppAuthState { // Fixed: extends AppAuthState
  final UserEntity user;
  const AuthRegistrationCheck(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthRegistrationComplete extends AppAuthState { // Fixed: extends AppAuthState
  final UserEntity user;
  const AuthRegistrationComplete(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthRegistrationIncomplete extends AppAuthState { // Fixed: extends AppAuthState
  final UserEntity user;
  const AuthRegistrationIncomplete(this.user);

  @override
  List<Object?> get props => [user];
}