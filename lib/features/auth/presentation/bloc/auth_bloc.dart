// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../../patient/domain/usecase/get_patient_profile.dart';
// import '../../../pharmacy/domain/usecase/get_pharmacy_profile.dart';
// import '../../domain/entities/user_entities.dart';
// import '../../domain/usecase/getCurrentUser.dart';
// import '../../domain/usecase/user_login.dart';
// import '../../domain/usecase/user_sign_up.dart';
// import 'auth_event.dart';
// import 'auth_state.dart';
//
// class AuthBloc extends Bloc<AuthEvent, AppAuthState> {
//   final UserLogin userLogin;
//   final UserSignUp userSignUp;
//   final GetCurrentUser getCurrentUser;
//   final GetPharmacyProfile getPharmacyProfile;
//   final GetPatientProfileUseCase getPatientProfile;
//
//   String? selectedRole;
//
//   AuthBloc({
//     required this.userLogin,
//     required this.userSignUp,
//     required this.getCurrentUser,
//     required this.getPharmacyProfile,
//     required this.getPatientProfile,
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
//       Emitter<AppAuthState> emit,
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
//     await result.fold(
//           (failure) async {
//         print('❌ LOGIN FAILED: ${failure.message}');
//         if (!emit.isDone) {
//           emit(AuthError(_mapFailureToMessage(failure)));
//         }
//       },
//           (user) async {
//         print('✅ LOGIN SUCCESS: ${user.email}');
//
//         final currentAuthUser = Supabase.instance.client.auth.currentUser;
//         if (currentAuthUser == null || currentAuthUser.id != user.id) {
//           print('❌ AUTH VERIFICATION FAILED AFTER LOGIN');
//           if (!emit.isDone) {
//             emit(AuthError('Authentication failed after login. Please try again.'));
//           }
//           return;
//         }
//
//         if (!emit.isDone) {
//           emit(AuthRegistrationCheck(user));
//         }
//
//         if (user.role == 'pharmacyowner') {
//           await _checkPharmacyRegistration(user, emit);
//         } else if (user.role == 'patient') {
//           await _checkPatientRegistration(user, emit);
//         } else {
//           if (!emit.isDone) {
//             emit(AuthAuthenticated(user));
//           }
//         }
//       },
//     );
//   }
//
//   // ---------------- SIGN UP ----------------
//   Future<void> _onSignUpEvent(
//       SignUpEvent event,
//       Emitter<AppAuthState> emit,
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
//     await result.fold(
//           (failure) async {
//         print('❌ SIGNUP FAILED: ${failure.message}');
//         if (!emit.isDone) {
//           emit(AuthError(_mapFailureToMessage(failure)));
//         }
//       },
//           (user) async {
//         print('✅ SIGNUP SUCCESS: ${user.email}');
//
//         final currentAuthUser = Supabase.instance.client.auth.currentUser;
//         if (currentAuthUser == null || currentAuthUser.id != user.id) {
//           print('❌ AUTH VERIFICATION FAILED AFTER SIGNUP');
//           if (!emit.isDone) {
//             emit(AuthError('Authentication failed after signup. Please try again.'));
//           }
//           return;
//         }
//
//         if (!emit.isDone) {
//           emit(AuthRegistrationCheck(user));
//         }
//
//         if (user.role == 'pharmacyowner') {
//           await _checkPharmacyRegistration(user, emit);
//         } else if (user.role == 'patient') {
//           await _checkPatientRegistration(user, emit);
//         } else {
//           if (!emit.isDone) {
//             emit(AuthAuthenticated(user));
//           }
//         }
//       },
//     );
//   }
//
//   // ---------------- PHARMACY REGISTRATION CHECK ----------------
//   Future<void> _checkPharmacyRegistration(UserEntity user, Emitter<AppAuthState> emit) async {
//     try {
//       print('🔐 CHECKING PHARMACY REGISTRATION FOR USER: ${user.id}');
//
//       final currentAuthUser = Supabase.instance.client.auth.currentUser;
//       print('📊 CURRENT AUTH USER: ${currentAuthUser?.id}');
//       print('📊 EXPECTED USER: ${user.id}');
//       print('📊 AUTHENTICATED: ${currentAuthUser != null}');
//
//       if (currentAuthUser == null) {
//         print('❌ AUTH LOST DURING PHARMACY CHECK - User not authenticated');
//         if (!emit.isDone) {
//           emit(AuthError('Authentication lost. Please login again.'));
//         }
//         return;
//       }
//
//       if (currentAuthUser.id != user.id) {
//         print('❌ USER ID MISMATCH DURING PHARMACY CHECK');
//         if (!emit.isDone) {
//           emit(AuthError('User authentication mismatch. Please restart the app.'));
//         }
//         return;
//       }
//
//       print('✅ AUTH VERIFIED - Proceeding with pharmacy profile check');
//       final result = await getPharmacyProfile(user.id);
//
//       await result.fold(
//             (failure) async {
//           print('❌ PHARMACY NOT FOUND - Registration incomplete');
//           if (!emit.isDone) {
//             emit(AuthRegistrationIncomplete(user));
//           }
//         },
//             (pharmacy) async {
//           print('✅ PHARMACY FOUND - Registration complete');
//           if (!emit.isDone) {
//             emit(AuthRegistrationComplete(user));
//           }
//         },
//       );
//     } catch (e) {
//       print('❌ ERROR IN PHARMACY REGISTRATION CHECK: $e');
//
//       final currentAuthUser = Supabase.instance.client.auth.currentUser;
//       if (currentAuthUser == null) {
//         print('❌ AUTH LOST - Redirecting to login');
//         if (!emit.isDone) {
//           emit(AuthError('Authentication lost. Please login again.'));
//         }
//       } else {
//         print('⚠️ Other error, but user still authenticated - marking as incomplete');
//         if (!emit.isDone) {
//           emit(AuthRegistrationIncomplete(user));
//         }
//       }
//     }
//   }
//
//   // ---------------- PATIENT REGISTRATION CHECK ----------------
//   Future<void> _checkPatientRegistration(UserEntity user, Emitter<AppAuthState> emit) async {
//     try {
//       print('🔐 CHECKING PATIENT REGISTRATION FOR USER: ${user.id}');
//
//       final currentAuthUser = Supabase.instance.client.auth.currentUser;
//       if (currentAuthUser == null || currentAuthUser.id != user.id) {
//         print('❌ AUTH LOST DURING PATIENT CHECK');
//         if (!emit.isDone) {
//           emit(AuthError('Authentication lost. Please login again.'));
//         }
//         return;
//       }
//
//       final result = await getPatientProfile(user.id);
//
//       result.fold(
//             (failure) {
//           print('❌ PATIENT NOT FOUND - Registration incomplete');
//           if (!emit.isDone) {
//             emit(AuthRegistrationIncomplete(user));
//           }
//         },
//             (patient) {
//           print('✅ PATIENT FOUND - Registration complete');
//           if (!emit.isDone) {
//             emit(AuthRegistrationComplete(user));
//           }
//         },
//       );
//     } catch (e) {
//       print('❌ ERROR IN PATIENT REGISTRATION CHECK: $e');
//
//       final currentAuthUser = Supabase.instance.client.auth.currentUser;
//       if (currentAuthUser == null) {
//         if (!emit.isDone) {
//           emit(AuthError('Authentication lost. Please login again.'));
//         }
//       } else {
//         if (!emit.isDone) {
//           emit(AuthRegistrationIncomplete(user));
//         }
//       }
//     }
//   }
//
//   // ---------------- ROLE SELECT ----------------
//   Future<void> _onRoleSelectedEvent(
//       RoleSelectedEvent event,
//       Emitter<AppAuthState> emit,
//       ) async {
//     selectedRole = event.role;
//     if (!emit.isDone) {
//       emit(AuthRoleSelected(event.role));
//     }
//   }
//
//   // ---------------- LOGOUT ----------------
//   Future<void> _onLogoutEvent(
//       LogoutEvent event,
//       Emitter<AppAuthState> emit,
//       ) async {
//     emit(AuthLoading());
//     try {
//       await Supabase.instance.client.auth.signOut();
//       print('✅ LOGOUT SUCCESSFUL');
//     } catch (e) {
//       print('❌ LOGOUT ERROR: $e');
//     }
//     selectedRole = null;
//     if (!emit.isDone) {
//       emit(AuthUnauthenticated());
//     }
//   }
//
//   // ---------------- CHECK CURRENT USER ----------------
//   Future<void> _onCheckAuthStatusEvent(
//       CheckAuthStatusEvent event,
//       Emitter<AppAuthState> emit,
//       ) async {
//     emit(AuthLoading());
//
//     final currentAuthUser = Supabase.instance.client.auth.currentUser;
//     print('🔐 CHECK AUTH STATUS - Current Auth User: ${currentAuthUser?.id}');
//
//     if (currentAuthUser == null) {
//       print('❌ NO AUTH USER FOUND - Emitting unauthenticated');
//       if (!emit.isDone) {
//         emit(AuthUnauthenticated());
//       }
//       return;
//     }
//
//     final result = await getCurrentUser();
//
//     await result.fold(
//           (failure) async {
//         print('❌ GET CURRENT USER FAILED: ${failure.message}');
//         if (!emit.isDone) {
//           emit(AuthUnauthenticated());
//         }
//       },
//           (user) async {
//         if (user != null) {
//           print('✅ USER FOUND: ${user.email}');
//
//           if (user.id != currentAuthUser.id) {
//             print('❌ USER ID MISMATCH IN AUTH CHECK');
//             if (!emit.isDone) {
//               emit(AuthError('User authentication mismatch. Please login again.'));
//             }
//             return;
//           }
//
//           if (!emit.isDone) {
//             emit(AuthRegistrationCheck(user));
//           }
//
//           if (user.role == 'pharmacyowner') {
//             await _checkPharmacyRegistration(user, emit);
//           } else if (user.role == 'patient') {
//             await _checkPatientRegistration(user, emit);
//           } else {
//             if (!emit.isDone) {
//               emit(AuthAuthenticated(user));
//             }
//           }
//         } else {
//           print('❌ GET CURRENT USER RETURNED NULL');
//           if (!emit.isDone) {
//             emit(AuthUnauthenticated());
//           }
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
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/failures.dart';
import '../../../patient/domain/usecase/get_patient_profile.dart';
import '../../../pharmacy/domain/usecase/get_pharmacy_profile.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/usecase/getCurrentUser.dart';
import '../../domain/usecase/user_login.dart';
import '../../domain/usecase/user_sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AppAuthState> {
  final UserLogin userLogin;
  final UserSignUp userSignUp;
  final GetCurrentUser getCurrentUser;
  final GetPharmacyProfile getPharmacyProfile;
  final GetPatientProfileUseCase getPatientProfile;

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
      Emitter<AppAuthState> emit,
      ) async {
    emit(AuthLoading());

    final Either<Failure, UserEntity> result = await userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    await result.fold(
          (failure) async {
        print('❌ LOGIN FAILED: ${failure.message}');
        if (!emit.isDone) {
          emit(AuthError(_mapFailureToMessage(failure)));
        }
      },
          (user) async {
        print('✅ LOGIN SUCCESS: ${user.email}');

        final currentAuthUser = Supabase.instance.client.auth.currentUser;
        if (currentAuthUser == null || currentAuthUser.id != user.id) {
          print('❌ AUTH VERIFICATION FAILED AFTER LOGIN');
          if (!emit.isDone) {
            emit(AuthError('Authentication failed after login. Please try again.'));
          }
          return;
        }

        if (!emit.isDone) {
          emit(AuthRegistrationCheck(user));
        }

        if (user.role == 'pharmacyowner') {
          await _checkPharmacyRegistration(user, emit);
        } else if (user.role == 'patient') {
          await _checkPatientRegistration(user, emit);
        } else {
          if (!emit.isDone) {
            emit(AuthAuthenticated(user));
          }
        }
      },
    );
  }

  // ---------------- SIGN UP ----------------
  Future<void> _onSignUpEvent(
      SignUpEvent event,
      Emitter<AppAuthState> emit,
      ) async {
    emit(AuthLoading());

    final Either<Failure, UserEntity> result = await userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        role: event.role,
      ),
    );

    await result.fold(
          (failure) async {
        print('❌ SIGNUP FAILED: ${failure.message}');
        if (!emit.isDone) {
          emit(AuthError(_mapFailureToMessage(failure)));
        }
      },
          (user) async {
        print('✅ SIGNUP SUCCESS: ${user.email}');

        final currentAuthUser = Supabase.instance.client.auth.currentUser;
        if (currentAuthUser == null || currentAuthUser.id != user.id) {
          print('❌ AUTH VERIFICATION FAILED AFTER SIGNUP');
          if (!emit.isDone) {
            emit(AuthError('Authentication failed after signup. Please try again.'));
          }
          return;
        }

        if (!emit.isDone) {
          emit(AuthRegistrationCheck(user));
        }

        if (user.role == 'pharmacyowner') {
          await _checkPharmacyRegistration(user, emit);
        } else if (user.role == 'patient') {
          await _checkPatientRegistration(user, emit);
        } else {
          if (!emit.isDone) {
            emit(AuthAuthenticated(user));
          }
        }
      },
    );
  }

  // ---------------- PHARMACY REGISTRATION CHECK ----------------
  Future<void> _checkPharmacyRegistration(UserEntity user, Emitter<AppAuthState> emit) async {
    try {
      print('🔐 CHECKING PHARMACY REGISTRATION FOR USER: ${user.id}');

      final currentAuthUser = Supabase.instance.client.auth.currentUser;
      print('📊 CURRENT AUTH USER: ${currentAuthUser?.id}');
      print('📊 EXPECTED USER: ${user.id}');
      print('📊 AUTHENTICATED: ${currentAuthUser != null}');

      if (currentAuthUser == null) {
        print('❌ AUTH LOST DURING PHARMACY CHECK - User not authenticated');
        if (!emit.isDone) {
          emit(AuthError('Authentication lost. Please login again.'));
        }
        return;
      }

      if (currentAuthUser.id != user.id) {
        print('❌ USER ID MISMATCH DURING PHARMACY CHECK');
        if (!emit.isDone) {
          emit(AuthError('User authentication mismatch. Please restart the app.'));
        }
        return;
      }

      print('✅ AUTH VERIFIED - Proceeding with pharmacy profile check');
      final result = await getPharmacyProfile(user.id);

      await result.fold(
            (failure) async {
          print('❌ PHARMACY NOT FOUND - Registration incomplete');
          if (!emit.isDone) {
            emit(AuthRegistrationIncomplete(user));
          }
        },
            (pharmacy) async {
          print('✅ PHARMACY FOUND - Registration complete');
          if (!emit.isDone) {
            emit(AuthRegistrationComplete(user));
          }
        },
      );
    } catch (e) {
      print('❌ ERROR IN PHARMACY REGISTRATION CHECK: $e');

      final currentAuthUser = Supabase.instance.client.auth.currentUser;
      if (currentAuthUser == null) {
        print('❌ AUTH LOST - Redirecting to login');
        if (!emit.isDone) {
          emit(AuthError('Authentication lost. Please login again.'));
        }
      } else {
        print('⚠️ Other error, but user still authenticated - marking as incomplete');
        if (!emit.isDone) {
          emit(AuthRegistrationIncomplete(user));
        }
      }
    }
  }

  // ---------------- PATIENT REGISTRATION CHECK (UPDATED) ----------------
  Future<void> _checkPatientRegistration(UserEntity user, Emitter<AppAuthState> emit) async {
    try {
      print('🔐 CHECKING PATIENT REGISTRATION FOR USER: ${user.id}');

      final currentAuthUser = Supabase.instance.client.auth.currentUser;
      if (currentAuthUser == null || currentAuthUser.id != user.id) {
        print('❌ AUTH LOST DURING PATIENT CHECK');
        if (!emit.isDone) {
          emit(AuthError('Authentication lost. Please login again.'));
        }
        return;
      }

      // ✅ ADDED: Small delay to allow database to sync patient registration
      print('⏳ Waiting for patient profile to be available...');
      await Future.delayed(Duration(milliseconds: 1500));

      final result = await getPatientProfile(user.id);

      result.fold(
            (failure) {
          print('❌ PATIENT NOT FOUND - Registration incomplete');
          if (!emit.isDone) {
            emit(AuthRegistrationIncomplete(user));
          }
        },
            (patient) {
          print('✅ PATIENT FOUND - Registration complete');
          print('   - Patient Name: ${patient.name}');
          print('   - Patient Phone: ${patient.phone}');
          if (!emit.isDone) {
            emit(AuthRegistrationComplete(user));
          }
        },
      );
    } catch (e) {
      print('❌ ERROR IN PATIENT REGISTRATION CHECK: $e');

      final currentAuthUser = Supabase.instance.client.auth.currentUser;
      if (currentAuthUser == null) {
        if (!emit.isDone) {
          emit(AuthError('Authentication lost. Please login again.'));
        }
      } else {
        if (!emit.isDone) {
          emit(AuthRegistrationIncomplete(user));
        }
      }
    }
  }

  // ---------------- ROLE SELECT ----------------
  Future<void> _onRoleSelectedEvent(
      RoleSelectedEvent event,
      Emitter<AppAuthState> emit,
      ) async {
    selectedRole = event.role;
    if (!emit.isDone) {
      emit(AuthRoleSelected(event.role));
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> _onLogoutEvent(
      LogoutEvent event,
      Emitter<AppAuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await Supabase.instance.client.auth.signOut();
      print('✅ LOGOUT SUCCESSFUL');
    } catch (e) {
      print('❌ LOGOUT ERROR: $e');
    }
    selectedRole = null;
    if (!emit.isDone) {
      emit(AuthUnauthenticated());
    }
  }

  // ---------------- CHECK CURRENT USER ----------------
  Future<void> _onCheckAuthStatusEvent(
      CheckAuthStatusEvent event,
      Emitter<AppAuthState> emit,
      ) async {
    emit(AuthLoading());

    final currentAuthUser = Supabase.instance.client.auth.currentUser;
    print('🔐 CHECK AUTH STATUS - Current Auth User: ${currentAuthUser?.id}');

    if (currentAuthUser == null) {
      print('❌ NO AUTH USER FOUND - Emitting unauthenticated');
      if (!emit.isDone) {
        emit(AuthUnauthenticated());
      }
      return;
    }

    final result = await getCurrentUser();

    await result.fold(
          (failure) async {
        print('❌ GET CURRENT USER FAILED: ${failure.message}');
        if (!emit.isDone) {
          emit(AuthUnauthenticated());
        }
      },
          (user) async {
        if (user != null) {
          print('✅ USER FOUND: ${user.email}');

          if (user.id != currentAuthUser.id) {
            print('❌ USER ID MISMATCH IN AUTH CHECK');
            if (!emit.isDone) {
              emit(AuthError('User authentication mismatch. Please login again.'));
            }
            return;
          }

          if (!emit.isDone) {
            emit(AuthRegistrationCheck(user));
          }

          if (user.role == 'pharmacyowner') {
            await _checkPharmacyRegistration(user, emit);
          } else if (user.role == 'patient') {
            await _checkPatientRegistration(user, emit);
          } else {
            if (!emit.isDone) {
              emit(AuthAuthenticated(user));
            }
          }
        } else {
          print('❌ GET CURRENT USER RETURNED NULL');
          if (!emit.isDone) {
            emit(AuthUnauthenticated());
          }
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