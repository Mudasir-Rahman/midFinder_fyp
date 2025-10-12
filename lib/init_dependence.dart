//
// import 'package:get_it/get_it.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'features/auth/data/data_source/auth_remote_data_source.dart';
// import 'features/auth/data/data_source/auth_remote_data_source_impl.dart';
// import 'features/auth/data/repository/repository_impl.dart';
// import 'features/auth/domain/repository/auth_repository.dart';
// import 'features/auth/domain/usecase/getCurrentUser.dart';
// import 'features/auth/domain/usecase/user_login.dart';
// import 'features/auth/domain/usecase/user_sign_up.dart';
// import 'features/auth/presentation/bloc/auth_bloc.dart';
//
// // Patient Dependencies
// import 'features/patient/data/data_source/patient_remote_data_source.dart';
// import 'features/patient/data/data_source/patient_remote_data_source_impl.dart';
// import 'features/patient/data/repository/repository/patient_repository_impl.dart';
// import 'features/patient/domain/repository/patient_repository.dart';
// import 'features/patient/domain/usecase/get_patient_profile.dart';
// import 'features/patient/domain/usecase/register_patient.dart';
// import 'features/patient/domain/usecase/update_patient_location.dart';
// import 'features/patient/presentation/bloc/patient_bloc.dart';
//
// // Pharmacy Dependencies
// import 'features/pharmacy/data/data_source/pharmacy_remote_data_source.dart';
// import 'features/pharmacy/data/data_source/pharmacy_remote_data_source_impl.dart';
// import 'features/pharmacy/data/repository/pharmacy_repository_impl.dart';
// import 'features/pharmacy/domain/repository/pharmacy_repository.dart';
// import 'features/pharmacy/domain/usecase/get_pharmacy_profile.dart';
// import 'features/pharmacy/domain/usecase/register_pharmacy.dart';
// import 'features/pharmacy/domain/usecase/update_pharmacy_profile.dart';
// import 'features/pharmacy/domain/usecase/upload_license_image.dart';
// import 'features/pharmacy/presentation/bloc/pharmacy_bloc.dart';
//
// final sl = GetIt.instance;
//
// Future<void> initDependencies() async {
//   await _initAuth();
//   await _initPatient();
//   await _initPharmacy();
// }
//
// Future<void> _initAuth() async {
//   sl.registerLazySingleton<SupabaseClient>(
//         () {
//       try {
//         return Supabase.instance.client;
//       } catch (e) {
//         throw Exception('Supabase not initialized: $e');
//       }
//     },
//   );
//
//   // Data Sources
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//         () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
//   );
//
//   // Repositories
//   sl.registerLazySingleton<AuthRepository>(
//         () => AuthRepositoryImpl(remoteDataSource: sl()),
//   );
//
//   // Use Cases
//   sl.registerLazySingleton(() => UserSignUp(sl()));
//   sl.registerLazySingleton(() => UserLogin(sl()));
//   sl.registerLazySingleton(() => GetCurrentUser(sl()));
//
//   // ✅ REGISTER HERE for AuthBloc registration checks (Single registration)
//   sl.registerLazySingleton(() => GetPatientProfileUseCase(sl()));
//   sl.registerLazySingleton(() => GetPharmacyProfile(sl()));
//
//   // Updated AuthBloc with all dependencies
//   sl.registerFactory<AuthBloc>(
//         () => AuthBloc(
//       userSignUp: sl(),
//       userLogin: sl(),
//       getCurrentUser: sl(),
//       getPharmacyProfile: sl(),
//       getPatientProfile: sl(),
//     ),
//   );
// }
//
// Future<void> _initPatient() async {
//   // Data Sources
//   sl.registerLazySingleton<PatientRemoteDataSource>(
//         () => PatientRemoteDataSourceImpl(supabaseClient: sl()),
//   );
//
//   // Repositories
//   sl.registerLazySingleton<PatientRepository>(
//         () => PatientRepositoryImpl(remoteDataSource: sl()),
//   );
//
//   // Use Cases
//   sl.registerLazySingleton(() => RegisterPatientUseCase(sl()));
//   sl.registerLazySingleton(() => UpdatePatientLocationUseCase(sl()));
//
//   // ❌ REMOVED DUPLICATE - Already registered in _initAuth()
//   // PatientBloc will use the same instance from _initAuth()
//
//   // Bloc
//   sl.registerFactory<PatientBloc>(
//         () => PatientBloc(
//       registerPatient: sl(),
//       getPatientProfile: sl(), // Uses the same instance from _initAuth()
//       updatePatientLocation: sl(),
//     ),
//   );
// }
//
// Future<void> _initPharmacy() async {
//   // Data Sources
//   sl.registerLazySingleton<PharmacyRemoteDataSource>(
//         () => PharmacyRemoteDataSourceImpl(supabaseClient: sl()),
//   );
//
//   // Repositories
//   sl.registerLazySingleton<PharmacyRepository>(
//         () => PharmacyRepositoryImpl(remoteDataSource: sl()),
//   );
//
//   // Use Cases
//   sl.registerLazySingleton(() => RegisterPharmacy(sl()));
//   sl.registerLazySingleton(() => UpdatePharmacyProfile(sl()));
//   sl.registerLazySingleton(() => UploadLicenseImage(sl()));
//
//   // ❌ REMOVED DUPLICATE - Already registered in _initAuth()
//   // PharmacyBloc will use the same instance from _initAuth()
//
//   // Bloc
//   sl.registerFactory<PharmacyBloc>(
//         () => PharmacyBloc(
//       registerPharmacy: sl(),
//       getPharmacyProfile: sl(), // Uses the same instance from _initAuth()
//       updatePharmacyProfile: sl(),
//       uploadLicenseImage: sl(),
//     ),
//   );
// }
//
// // Helper method to reset dependencies (useful for testing)
// Future<void> resetDependencies() async {
//   await sl.reset();
// }
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ===== Auth Imports =====
import 'features/auth/data/data_source/auth_remote_data_source.dart';
import 'features/auth/data/data_source/auth_remote_data_source_impl.dart';
import 'features/auth/data/repository/repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecase/getCurrentUser.dart';
import 'features/auth/domain/usecase/user_login.dart';
import 'features/auth/domain/usecase/user_sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// ===== Patient Imports =====
import 'features/patient/data/data_source/patient_remote_data_source.dart';
import 'features/patient/data/data_source/patient_remote_data_source_impl.dart';
import 'features/patient/data/repository/repository/patient_repository_impl.dart';
import 'features/patient/domain/repository/patient_repository.dart';
import 'features/patient/domain/usecase/get_patient_profile.dart';
import 'features/patient/domain/usecase/register_patient.dart';
import 'features/patient/domain/usecase/update_patient_location.dart';
import 'features/patient/presentation/bloc/patient_bloc.dart';

// ===== Pharmacy Imports =====
import 'features/pharmacy/data/data_source/pharmacy_remote_data_source.dart';
import 'features/pharmacy/data/data_source/pharmacy_remote_data_source_impl.dart';
import 'features/pharmacy/data/repository/pharmacy_repository_impl.dart';
import 'features/pharmacy/domain/repository/pharmacy_repository.dart';
import 'features/pharmacy/domain/usecase/get_pharmacy_profile.dart';
import 'features/pharmacy/domain/usecase/register_pharmacy.dart';
import 'features/pharmacy/domain/usecase/update_pharmacy_profile.dart';
import 'features/pharmacy/domain/usecase/upload_license_image.dart';
import 'features/pharmacy/presentation/bloc/pharmacy_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initAuth();
  await _initPatient();
  await _initPharmacy();
}

/// ===============================
/// AUTH FEATURE
/// ===============================
Future<void> _initAuth() async {
  // ✅ Supabase Client (register only once)
  if (!sl.isRegistered<SupabaseClient>()) {
    sl.registerLazySingleton<SupabaseClient>(
          () {
        try {
          return Supabase.instance.client;
        } catch (e) {
          throw Exception('Supabase not initialized: $e');
        }
      },
    );
  }

  // ✅ Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // ✅ Use Cases
  sl.registerLazySingleton(() => UserSignUp(sl()));
  sl.registerLazySingleton(() => UserLogin(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Shared use cases for both Auth and role-based flows
  sl.registerLazySingleton(() => GetPatientProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetPharmacyProfile(sl()));

  // ✅ Bloc
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      userSignUp: sl(),
      userLogin: sl(),
      getCurrentUser: sl(),
      getPharmacyProfile: sl(),
      getPatientProfile: sl(),
    ),
  );
}

/// ===============================
/// PATIENT FEATURE
/// ===============================
Future<void> _initPatient() async {
  // ✅ Data Source
  sl.registerLazySingleton<PatientRemoteDataSource>(
        () => PatientRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<PatientRepository>(
        () => PatientRepositoryImpl(remoteDataSource: sl()),
  );

  // ✅ Use Cases
  sl.registerLazySingleton(() => RegisterPatientUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePatientLocationUseCase(sl()));

  // ✅ Bloc
  sl.registerFactory<PatientBloc>(
        () => PatientBloc(
      registerPatient: sl(),
      getPatientProfile: sl(), // uses same instance from Auth
      updatePatientLocation: sl(),
    ),
  );
}

/// ===============================
/// PHARMACY FEATURE
/// ===============================
Future<void> _initPharmacy() async {
  // ✅ Data Source
  sl.registerLazySingleton<PharmacyRemoteDataSource>(
        () => PharmacyRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // ✅ Repository
  sl.registerLazySingleton<PharmacyRepository>(
        () => PharmacyRepositoryImpl(remoteDataSource: sl()),
  );

  // ✅ Use Cases
  sl.registerLazySingleton(() => RegisterPharmacy(sl()));
  sl.registerLazySingleton(() => UpdatePharmacyProfile(sl()));
  sl.registerLazySingleton(() => UploadLicenseImage(sl()));

  // ✅ Bloc
  sl.registerFactory<PharmacyBloc>(
        () => PharmacyBloc(
      registerPharmacy: sl(),
      getPharmacyProfile: sl(), // shared from Auth init
      updatePharmacyProfile: sl(),
      uploadLicenseImage: sl(),
    ),
  );
}

/// ===============================
/// UTILITY
/// ===============================
Future<void> resetDependencies() async {
  await sl.reset();
}
