// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../domain/entities/user_entities.dart';
// import '../../domain/usecase/getCurrentUser.dart';
// import '../../domain/usecase/user_login.dart';
// import '../../domain/usecase/user_sign_up.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final UserLogin userLogin;
//   final UserSignUp userSignUp;
//   final GetCurrentUser getCurrentUser;
//
//   // To store role temporarily before signup
//   String? selectedRole;
//
//   AuthBloc({
//     required this.userLogin,
//     required this.userSignUp,
//     required this.getCurrentUser,
//   }) : super(AuthInitial()) {
//     on<LoginEvent>(_onLoginEvent);
//     on<SignUpEvent>(_onSignUpEvent);
//     on<LogoutEvent>(_onLogoutEvent);
//     on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
//     on<RoleSelectedEvent>(_onRoleSelectedEvent);
//   }
//
//   // ---------------- LOGIN ----------------
//   Future<void> _onLoginEvent(
//       LoginEvent event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//
//     final Either<Failure, UserEntity> result = await userLogin(
//       UserLoginParams(
//         email: event.email,
//         password: event.password,
//       ),
//     );
//
//     result.fold(
//           (failure) => emit(AuthError(_mapFailureToMessage(failure))),
//           (user) => emit(AuthAuthenticated(user)),
//     );
//   }
//
//   // ---------------- SIGN UP ----------------
//   Future<void> _onSignUpEvent(
//       SignUpEvent event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//
//     final Either<Failure, UserEntity> result = await userSignUp(
//       UserSignUpParams(
//         email: event.email,
//         password: event.password,
//         role: event.role,
//       ),
//     );
//
//     result.fold(
//           (failure) => emit(AuthError(_mapFailureToMessage(failure))),
//           (user) => emit(AuthAuthenticated(user)),
//     );
//   }
//
//   // ---------------- ROLE SELECT ----------------
//   Future<void> _onRoleSelectedEvent(
//       RoleSelectedEvent event,
//       Emitter<AuthState> emit,
//       ) async {
//     selectedRole = event.role;
//     emit(AuthRoleSelected(event.role));
//   }
//
//   // ---------------- LOGOUT ----------------
//   Future<void> _onLogoutEvent(
//       LogoutEvent event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//     // Normally you’d call Supabase.auth.signOut() here
//     await Future.delayed(const Duration(milliseconds: 500));
//     selectedRole = null;
//     emit(AuthUnauthenticated());
//   }
//
//   // ---------------- CHECK CURRENT USER ----------------
//   Future<void> _onCheckAuthStatusEvent(
//       CheckAuthStatusEvent event,
//       Emitter<AuthState> emit,
//       ) async {
//     emit(AuthLoading());
//     final result = await getCurrentUser();
//
//     result.fold(
//           (failure) => emit(AuthUnauthenticated()),
//           (user) {
//         if (user != null) {
//           emit(AuthAuthenticated(user));
//         } else {
//           emit(AuthUnauthenticated());
//         }
//       },
//     );
//   }
//
//   // ---------------- FAILURE MESSAGE HELPER ----------------
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return failure.message;
//       case CacheFailure:
//         return 'Cache failure: ${failure.message}';
//       case NetworkFailure:
//         return 'Network failure: ${failure.message}';
//       case AuthFailure:
//         return 'Authentication failure: ${failure.message}';
//       default:
//         return 'Unexpected error: ${failure.message}';
//     }
//   }
// }
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../patient/domain/usecase/get_patient_profile.dart';
import '../../../pharmacy/domain/usecase/get_pharmacy_profile.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/usecase/getCurrentUser.dart';
import '../../domain/usecase/user_login.dart';
import '../../domain/usecase/user_sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserLogin userLogin;
  final UserSignUp userSignUp;
  final GetCurrentUser getCurrentUser;
  final GetPharmacyProfile getPharmacyProfile;
  final GetPatientProfileUseCase getPatientProfile;

  // To store role temporarily before signup
  String? selectedRole;

  AuthBloc({
    required this.userLogin,
    required this.userSignUp,
    required this.getCurrentUser,
    required this.getPharmacyProfile,
    required this.getPatientProfile,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<RoleSelectedEvent>(_onRoleSelectedEvent);
  }

  // ---------------- LOGIN ----------------
  Future<void> _onLoginEvent(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final Either<Failure, UserEntity> result = await userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (user) async {
        // Check registration status based on role
        emit(AuthRegistrationCheck(user));

        if (user.role == 'pharmacyowner') {
          await _checkPharmacyRegistration(user, emit);
        } else if (user.role == 'patient') {
          await _checkPatientRegistration(user, emit); // ✅ Now implemented
        } else {
          emit(AuthAuthenticated(user)); // Fallback
        }
      },
    );
  }

  // ---------------- SIGN UP ----------------
  Future<void> _onSignUpEvent(
      SignUpEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final Either<Failure, UserEntity> result = await userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        role: event.role,
      ),
    );

    result.fold(
          (failure) => emit(AuthError(_mapFailureToMessage(failure))),
          (user) async {
        // Check registration status based on role
        emit(AuthRegistrationCheck(user));

        if (user.role == 'pharmacyowner') {
          await _checkPharmacyRegistration(user, emit);
        } else if (user.role == 'patient') {
          await _checkPatientRegistration(user, emit); // ✅ Now implemented
        } else {
          emit(AuthAuthenticated(user)); // Fallback
        }
      },
    );
  }

  // ---------------- PHARMACY REGISTRATION CHECK ----------------
  Future<void> _checkPharmacyRegistration(UserEntity user, Emitter<AuthState> emit) async {
    final result = await getPharmacyProfile(user.id);

    result.fold(
          (failure) {
        // Pharmacy not found - registration incomplete
        emit(AuthRegistrationIncomplete(user));
      },
          (pharmacy) {
        // Pharmacy found - registration complete
        emit(AuthRegistrationComplete(user));
      },
    );
  }

  // ---------------- PATIENT REGISTRATION CHECK ----------------
  Future<void> _checkPatientRegistration(UserEntity user, Emitter<AuthState> emit) async {
    final result = await getPatientProfile(user.id);

    result.fold(
          (failure) {
        // Patient not found - registration incomplete
        emit(AuthRegistrationIncomplete(user));
      },
          (patient) {
        // Patient found - registration complete
        emit(AuthRegistrationComplete(user));
      },
    );
  }

  // ---------------- ROLE SELECT ----------------
  Future<void> _onRoleSelectedEvent(
      RoleSelectedEvent event,
      Emitter<AuthState> emit,
      ) async {
    selectedRole = event.role;
    emit(AuthRoleSelected(event.role));
  }

  // ---------------- LOGOUT ----------------
  Future<void> _onLogoutEvent(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    // Normally you'd call Supabase.auth.signOut() here
    await Future.delayed(const Duration(milliseconds: 500));
    selectedRole = null;
    emit(AuthUnauthenticated());
  }

  // ---------------- CHECK CURRENT USER ----------------
  Future<void> _onCheckAuthStatusEvent(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    final result = await getCurrentUser();

    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  // ---------------- FAILURE MESSAGE HELPER ----------------
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case CacheFailure:
        return 'Cache failure: ${failure.message}';
      case NetworkFailure:
        return 'Network failure: ${failure.message}';
      case AuthFailure:
        return 'Authentication failure: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}