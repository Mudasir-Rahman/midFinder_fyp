
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ===== Core Services =====
import 'package:rx_locator/core/services/image_upload_service.dart';
import 'package:rx_locator/core/database/local_database_service.dart';

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
import 'features/patient/data/repository/repository/favorite_repository_impl.dart';
import 'features/patient/data/repository/repository/patient_repository_impl.dart';
import 'features/patient/domain/repository/patient_repository.dart';
import 'features/patient/domain/usecase/get_patient_profile.dart';
import 'features/patient/domain/usecase/register_patient.dart';
import 'features/patient/domain/usecase/update_patient_location.dart';
import 'features/patient/presentation/bloc/patient_bloc.dart';

// ===== Favorites Imports =====
import 'features/patient/domain/repository/favorite_repository.dart';
import 'features/patient/domain/usecase/favorite_usecases.dart';
import 'features/patient/presentation/bloc/favorite_bloc.dart';

// ===== Pharmacy Imports =====
import 'features/pharmacy/data/data_source/pharmacy_remote_data_source.dart';
import 'features/pharmacy/data/data_source/pharmacy_remote_data_source_impl.dart';
import 'features/pharmacy/data/repository/pharmacy_repository_impl.dart';
import 'features/pharmacy/domain/repository/pharmacy_repository.dart';
import 'features/pharmacy/domain/usecase/get_pharmacy_profile.dart';
import 'features/pharmacy/domain/usecase/register_pharmacy.dart';
import 'features/pharmacy/domain/usecase/update_pharmacy_profile.dart';
import 'features/pharmacy/domain/usecase/upload_license_image.dart';
import 'features/pharmacy/domain/usecase/search_nearby_pharmacies.dart';
import 'features/pharmacy/presentation/bloc/pharmacy_bloc.dart';

// ===== Medicine Imports =====
import 'features/medicine/data/data_source/medicine_remote_data_source.dart';
import 'features/medicine/data/data_source/medicine_remote_data_source_impl.dart';
import 'features/medicine/data/repository/medicine_repository_impl.dart';
import 'features/medicine/domain/repository/medicine_repository.dart';
import 'features/medicine/domain/usecase/add_medicine.dart';
import 'features/medicine/domain/usecase/get_all_medicine.dart';
import 'features/medicine/domain/usecase/get_medicine_by_category.dart';
import 'features/medicine/domain/usecase/get_medicine_detail.dart';
import 'features/medicine/domain/usecase/get_pharmacy_medicine.dart';
import 'features/medicine/domain/usecase/search_medicine.dart';
import 'features/medicine/domain/usecase/update_medicine.dart';
import 'features/medicine/domain/usecase/search_nearby_medicine.dart'; // ✅ ADD THIS IMPORT
import 'features/medicine/presentation/bloc/medicine_bloc.dart';

final sl = GetIt.instance;

/// =======================================================
/// MAIN INITIALIZATION
/// =======================================================
Future<void> init() async {
  await _initCore();
  await _initAuth();
  await _initPharmacy();
  await _initPatient();
  await _initMedicine();
  await _initFavorites();
}

/// =======================================================
/// CORE SERVICES
/// =======================================================
Future<void> _initCore() async {
  // Supabase client
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Image Upload Service
  sl.registerLazySingleton<ImageUploadService>(
        () => ImageUploadService(sl()),
  );

  // Local Database Service
  sl.registerLazySingleton<LocalDatabaseService>(() => LocalDatabaseService());
}

/// =======================================================
/// FAVORITES FEATURE
/// =======================================================
Future<void> _initFavorites() async {
  // Repository
  sl.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(localDatabaseService: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetFavoritesUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddFavoriteUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveFavoriteUseCase(repository: sl()));
  sl.registerLazySingleton(() => IsFavoriteUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearFavoritesUseCase(repository: sl()));

  // Bloc
  sl.registerFactory<FavoriteBloc>(
        () => FavoriteBloc(
      getFavorites: sl(),
      addFavorite: sl(),
      removeFavorite: sl(),
      isFavorite: sl(),
      clearFavorites: sl(),
    ),
  );
}

/// =======================================================
/// AUTH FEATURE
/// =======================================================
Future<void> _initAuth() async {
  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => UserSignUp(sl()));
  sl.registerLazySingleton(() => UserLogin(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Shared Use Cases
  sl.registerLazySingleton(() => GetPatientProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetPharmacyProfile(sl()));

  // Bloc
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

/// =======================================================
/// PHARMACY FEATURE
/// =======================================================
Future<void> _initPharmacy() async {
  // Data Source
  sl.registerLazySingleton<PharmacyRemoteDataSource>(
        () => PharmacyRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<PharmacyRepository>(
        () => PharmacyRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => RegisterPharmacy(sl()));
  sl.registerLazySingleton(() => UpdatePharmacyProfile(sl()));
  sl.registerLazySingleton(() => UploadLicenseImage(sl()));
  sl.registerLazySingleton(() => SearchNearbyPharmacies(sl()));

  // GetPharmacyProfile already registered in Auth section

  // Bloc
  sl.registerFactory<PharmacyBloc>(
        () => PharmacyBloc(
      registerPharmacy: sl(),
      getPharmacyProfile: sl(),
      updatePharmacyProfile: sl(),
      uploadLicenseImage: sl(),
    ),
  );
}

/// =======================================================
/// PATIENT FEATURE
/// =======================================================
Future<void> _initPatient() async {
  // Data Source
  sl.registerLazySingleton<PatientRemoteDataSource>(
        () => PatientRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<PatientRepository>(
        () => PatientRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => RegisterPatientUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePatientLocationUseCase(sl()));
  // GetPatientProfile already registered in Auth section

  // Bloc
  sl.registerFactory<PatientBloc>(
        () => PatientBloc(
      registerPatient: sl(),
      updatePatientLocation: sl(),
      getPatientProfile: sl(),
      searchNearbyPharmacies: sl(),
    ),
  );
}

/// =======================================================
/// MEDICINE FEATURE
/// =======================================================
Future<void> _initMedicine() async {
  // Data Source
  sl.registerLazySingleton<MedicineRemoteDataSource>(
        () => MedicineRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<MedicineRepository>(
        () => MedicineRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SearchMedicine(sl()));
  sl.registerLazySingleton(() => GetMedicineDetail(sl()));
  sl.registerLazySingleton(() => AddMedicine(sl()));
  sl.registerLazySingleton(() => UpdateMedicine(sl()));
  sl.registerLazySingleton(() => GetMedicinePharmacy(sl()));
  sl.registerLazySingleton(() => GetMedicineByCategory(sl()));
  sl.registerLazySingleton(() => GetAllMedicines(sl()));
  sl.registerLazySingleton(() => SearchNearbyMedicine(sl())); // ✅ ADD THIS

  // Bloc
  sl.registerFactory<MedicineBloc>(
        () => MedicineBloc(
      searchMedicine: sl(),
      searchNearbyMedicine: sl(), // ✅ ADD THIS PARAMETER
      getMedicineDetail: sl(),
      addMedicine: sl(),
      updateMedicine: sl(),
      getPharmacyMedicine: sl(),
      getMedicineByCategory: sl(),
      getAllMedicines: sl(),
      imageUploadService: sl(),
    ),
  );

  /// =======================================================
  /// FAVORITES FEATURE - FIXED VERSION
  /// =======================================================
  Future<void> _initFavorites() async {
    // Repository - Register both interface and implementation
    sl.registerLazySingleton<FavoriteRepositoryImpl>(
          () => FavoriteRepositoryImpl(localDatabaseService: sl()),
    );

    // Also register the abstract type
    sl.registerLazySingleton<FavoriteRepository>(
          () => sl<FavoriteRepositoryImpl>(),
    );

    // Use Cases - Be explicit about the repository type
    sl.registerLazySingleton(() => GetFavoritesUseCase(repository: sl<FavoriteRepository>()));
    sl.registerLazySingleton(() => AddFavoriteUseCase(repository: sl<FavoriteRepository>()));
    sl.registerLazySingleton(() => RemoveFavoriteUseCase(repository: sl<FavoriteRepository>()));
    sl.registerLazySingleton(() => IsFavoriteUseCase(repository: sl<FavoriteRepository>()));
    sl.registerLazySingleton(() => ClearFavoritesUseCase(repository: sl<FavoriteRepository>()));

    // Bloc
    sl.registerFactory<FavoriteBloc>(
          () => FavoriteBloc(
        getFavorites: sl(),
        addFavorite: sl(),
        removeFavorite: sl(),
        isFavorite: sl(),
        clearFavorites: sl(),
      ),
    );
  }
}