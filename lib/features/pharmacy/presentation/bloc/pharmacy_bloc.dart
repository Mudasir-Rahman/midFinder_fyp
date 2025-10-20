// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
// import '../../domain/entity/pharmacy_entity.dart';
// import '../../domain/usecase/register_pharmacy.dart';
// import '../../domain/usecase/get_pharmacy_profile.dart';
// import '../../domain/usecase/update_pharmacy_profile.dart';
// import '../../domain/usecase/upload_license_image.dart';
//
// part 'pharmacy_event.dart';
// part 'pharmacy_state.dart';
//
// class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
//   final RegisterPharmacy registerPharmacy;
//   final GetPharmacyProfile getPharmacyProfile;
//   final UpdatePharmacyProfile updatePharmacyProfile;
//   final UploadLicenseImage uploadLicenseImage;
//
//   PharmacyBloc({
//     required this.registerPharmacy,
//     required this.getPharmacyProfile,
//     required this.updatePharmacyProfile,
//     required this.uploadLicenseImage,
//   }) : super(PharmacyInitial()) {
//     on<RegisterPharmacyEvent>(_onRegisterPharmacy);
//     on<GetPharmacyProfileEvent>(_onGetPharmacyProfile);
//     on<UpdatePharmacyProfileEvent>(_onUpdatePharmacyProfile);
//     on<UploadLicenseImageEvent>(_onUploadLicenseImage);
//     on<ResetPharmacyStateEvent>(_onResetPharmacyState);
//   }
//
//   Future<void> _onRegisterPharmacy(
//       RegisterPharmacyEvent event,
//       Emitter<PharmacyState> emit,
//       ) async {
//     emit(PharmacyLoading());
//
//     final result = await registerPharmacy(RegisterPharmacyParams(
//       userId: event.userId,
//       pharmacyName: event.pharmacyName,
//       licenseNumber: event.licenseNumber,
//       address: event.address,
//       phone: event.phone,
//       latitude: event.latitude,
//       longitude: event.longitude,
//       operatingDays: event.operatingDays,
//       openingTime: event.openingTime,
//       closingTime: event.closingTime,
//       licenseImageUrl: null,
//     ));
//
//     _emitEitherResult(result, emit, (pharmacy) {
//       return PharmacyRegistrationSuccess(pharmacy: pharmacy);
//     });
//
//     // Upload license image if provided
//     if (event.licenseImagePath != null && result.isRight()) {
//       final pharmacy = (result as Right).value;
//       add(UploadLicenseImageEvent(
//         pharmacyId: pharmacy.id,
//         imagePath: event.licenseImagePath!,
//       ));
//     }
//   }
//
//   Future<void> _onGetPharmacyProfile(
//       GetPharmacyProfileEvent event,
//       Emitter<PharmacyState> emit,
//       ) async {
//     emit(PharmacyLoading());
//
//     final result = await getPharmacyProfile(event.userId);
//
//     _emitEitherResult(result, emit, (pharmacy) {
//       return PharmacyProfileLoaded(pharmacy: pharmacy);
//     });
//   }
//
//   Future<void> _onUpdatePharmacyProfile(
//       UpdatePharmacyProfileEvent event,
//       Emitter<PharmacyState> emit,
//       ) async {
//     emit(PharmacyLoading());
//
//     final result = await updatePharmacyProfile(UpdatePharmacyProfileParams(
//       pharmacyId: event.pharmacyId,
//       pharmacyName: event.pharmacyName,
//       address: event.address,
//       phone: event.phone,
//       operatingDays: event.operatingDays,
//       openingTime: event.openingTime,
//       closingTime: event.closingTime,
//     ));
//
//     _emitEitherResult(result, emit, (pharmacy) {
//       return PharmacyUpdateSuccess(pharmacy: pharmacy);
//     });
//   }
//
//   Future<void> _onUploadLicenseImage(
//       UploadLicenseImageEvent event,
//       Emitter<PharmacyState> emit,
//       ) async {
//     emit(PharmacyLoading());
//
//     final result = await uploadLicenseImage(UploadLicenseImageParams(
//       pharmacyId: event.pharmacyId,
//       imagePath: event.imagePath,
//     ));
//
//     result.fold(
//           (failure) => emit(PharmacyError(message: _mapFailureToMessage(failure))),
//           (imageUrl) => emit(LicenseImageUploadSuccess(imageUrl: imageUrl)),
//     );
//   }
//
//   void _onResetPharmacyState(
//       ResetPharmacyStateEvent event,
//       Emitter<PharmacyState> emit,
//       ) {
//     emit(PharmacyInitial());
//   }
//
//   void _emitEitherResult(
//       Either<Failure, PharmacyEntity> result,
//       Emitter<PharmacyState> emit,
//       PharmacyState Function(PharmacyEntity) successState,
//       ) {
//     result.fold(
//           (failure) => emit(PharmacyError(message: _mapFailureToMessage(failure))),
//           (pharmacy) => emit(successState(pharmacy)),
//     );
//   }
//
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return 'Server error: ${failure.message}';
//       case NetworkFailure:
//         return 'Network error: ${failure.message}';
//       case NotFoundFailure:
//         return 'Pharmacy not found: ${failure.message}';
//       case UploadFailure:
//         return 'Upload failed: ${failure.message}';
//       default:
//         return 'Unexpected error: ${failure.message}';
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entity/pharmacy_entity.dart';
import '../../domain/usecase/register_pharmacy.dart';
import '../../domain/usecase/get_pharmacy_profile.dart';
import '../../domain/usecase/update_pharmacy_profile.dart';
import '../../domain/usecase/upload_license_image.dart';

part 'pharmacy_event.dart';
part 'pharmacy_state.dart';

class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
  final RegisterPharmacy registerPharmacy;
  final GetPharmacyProfile getPharmacyProfile;
  final UpdatePharmacyProfile updatePharmacyProfile;
  final UploadLicenseImage uploadLicenseImage;

  PharmacyBloc({
    required this.registerPharmacy,
    required this.getPharmacyProfile,
    required this.updatePharmacyProfile,
    required this.uploadLicenseImage,
  }) : super(PharmacyInitial()) {
    on<RegisterPharmacyEvent>(_onRegisterPharmacy);
    on<GetPharmacyProfileEvent>(_onGetPharmacyProfile);
    on<UpdatePharmacyProfileEvent>(_onUpdatePharmacyProfile);
    on<UploadLicenseImageEvent>(_onUploadLicenseImage);
    on<ResetPharmacyStateEvent>(_onResetPharmacyState);
  }

  Future<void> _onRegisterPharmacy(
      RegisterPharmacyEvent event,
      Emitter<PharmacyState> emit,
      ) async {
    print('🔄 PHARMACY BLOC: Starting registration process');

    // Verify authentication BEFORE starting the process
    final currentUser = Supabase.instance.client.auth.currentUser;
    print('🔐 Current Auth User: ${currentUser?.id}');
    print('📋 Event User ID: ${event.userId}');

    if (currentUser == null) {
      print('❌ PHARMACY BLOC: User not authenticated at BLOC level');
      emit(PharmacyError(message: 'User not authenticated. Please login again.'));
      return;
    }

    if (currentUser.id != event.userId) {
      print('❌ PHARMACY BLOC: User ID mismatch - Event: ${event.userId}, Current: ${currentUser.id}');
      emit(PharmacyError(message: 'User authentication mismatch. Please restart the app.'));
      return;
    }

    emit(PharmacyLoading());
    print('✅ PHARMACY BLOC: Authentication verified, proceeding with registration...');

    try {
      final result = await registerPharmacy(RegisterPharmacyParams(
        userId: event.userId,
        pharmacyName: event.pharmacyName,
        licenseNumber: event.licenseNumber,
        address: event.address,
        phone: event.phone,
        latitude: event.latitude,
        longitude: event.longitude,
        operatingDays: event.operatingDays,
        openingTime: event.openingTime,
        closingTime: event.closingTime,
        licenseImageUrl: null,
      ));

      print('📊 PHARMACY BLOC: Registration result received');

      // Verify auth again AFTER registration
      final postAuthUser = Supabase.instance.client.auth.currentUser;
      if (postAuthUser == null) {
        print('❌ PHARMACY BLOC: User authentication LOST during registration');
        emit(PharmacyError(message: 'Authentication lost during registration. Please login again.'));
        return;
      }

      _emitEitherResult(result, emit, (pharmacy) {
        print('🎉 PHARMACY BLOC: Registration successful - Pharmacy ID: ${pharmacy.id}');
        return PharmacyRegistrationSuccess(pharmacy: pharmacy);
      });

    } catch (e) {
      print('❌ PHARMACY BLOC: Registration exception: $e');

      // Check if it's an auth error
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        emit(PharmacyError(message: 'Authentication lost. Please login again.'));
      } else {
        emit(PharmacyError(message: 'Registration failed: $e'));
      }
    }
  }

  Future<void> _onGetPharmacyProfile(
      GetPharmacyProfileEvent event,
      Emitter<PharmacyState> emit,
      ) async {
    print('🔄 PHARMACY BLOC: Fetching pharmacy profile for user: ${event.userId}');

    // Verify authentication
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser == null || currentUser.id != event.userId) {
      print('❌ PHARMACY BLOC: Auth failed for profile fetch');
      emit(PharmacyError(message: 'Authentication required to fetch profile'));
      return;
    }

    emit(PharmacyLoading());

    try {
      final result = await getPharmacyProfile(event.userId);

      _emitEitherResult(result, emit, (pharmacy) {
        print('✅ PHARMACY BLOC: Profile loaded successfully');
        return PharmacyProfileLoaded(pharmacy: pharmacy);
      });
    } catch (e) {
      print('❌ PHARMACY BLOC: Profile fetch exception: $e');
      emit(PharmacyError(message: 'Failed to load pharmacy profile: $e'));
    }
  }

  Future<void> _onUpdatePharmacyProfile(
      UpdatePharmacyProfileEvent event,
      Emitter<PharmacyState> emit,
      ) async {
    print('🔄 PHARMACY BLOC: Updating pharmacy profile: ${event.pharmacyId}');
    emit(PharmacyLoading());

    try {
      final result = await updatePharmacyProfile(UpdatePharmacyProfileParams(
        pharmacyId: event.pharmacyId,
        pharmacyName: event.pharmacyName,
        address: event.address,
        phone: event.phone,
        operatingDays: event.operatingDays,
        openingTime: event.openingTime,
        closingTime: event.closingTime,
      ));

      _emitEitherResult(result, emit, (pharmacy) {
        print('✅ PHARMACY BLOC: Profile updated successfully');
        return PharmacyUpdateSuccess(pharmacy: pharmacy);
      });
    } catch (e) {
      print('❌ PHARMACY BLOC: Profile update exception: $e');
      emit(PharmacyError(message: 'Failed to update profile: $e'));
    }
  }

  Future<void> _onUploadLicenseImage(
      UploadLicenseImageEvent event,
      Emitter<PharmacyState> emit,
      ) async {
    print('🔄 PHARMACY BLOC: Uploading license image for pharmacy: ${event.pharmacyId}');
    emit(PharmacyLoading());

    try {
      final result = await uploadLicenseImage(UploadLicenseImageParams(
        pharmacyId: event.pharmacyId,
        imagePath: event.imagePath,
      ));

      result.fold(
            (failure) {
          print('❌ PHARMACY BLOC: License image upload failed: ${failure.message}');
          emit(PharmacyError(message: _mapFailureToMessage(failure)));
        },
            (imageUrl) {
          print('✅ PHARMACY BLOC: License image uploaded successfully: $imageUrl');
          emit(LicenseImageUploadSuccess(imageUrl: imageUrl));
        },
      );
    } catch (e) {
      print('❌ PHARMACY BLOC: License upload exception: $e');
      emit(PharmacyError(message: 'Failed to upload license image: $e'));
    }
  }

  void _onResetPharmacyState(
      ResetPharmacyStateEvent event,
      Emitter<PharmacyState> emit,
      ) {
    print('🔄 PHARMACY BLOC: Resetting state to initial');
    emit(PharmacyInitial());
  }

  void _emitEitherResult(
      Either<Failure, PharmacyEntity> result,
      Emitter<PharmacyState> emit,
      PharmacyState Function(PharmacyEntity) successState,
      ) {
    result.fold(
          (failure) {
        print('❌ PHARMACY BLOC: Operation failed: ${_mapFailureToMessage(failure)}');
        emit(PharmacyError(message: _mapFailureToMessage(failure)));
      },
          (pharmacy) {
        print('✅ PHARMACY BLOC: Operation succeeded - Pharmacy: ${pharmacy.pharmacyName}');
        emit(successState(pharmacy));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case NotFoundFailure:
        return 'Pharmacy not found: ${failure.message}';
      case UploadFailure:
        return 'Upload failed: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}