import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
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
    emit(PharmacyLoading());

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

    _emitEitherResult(result, emit, (pharmacy) {
      return PharmacyRegistrationSuccess(pharmacy: pharmacy);
    });

    // Upload license image if provided
    if (event.licenseImagePath != null && result.isRight()) {
      final pharmacy = (result as Right).value;
      add(UploadLicenseImageEvent(
        pharmacyId: pharmacy.id,
        imagePath: event.licenseImagePath!,
      ));
    }
  }

  Future<void> _onGetPharmacyProfile(
      GetPharmacyProfileEvent event,
      Emitter<PharmacyState> emit,
      ) async {
    emit(PharmacyLoading());

    final result = await getPharmacyProfile(event.userId);

    _emitEitherResult(result, emit, (pharmacy) {
      return PharmacyProfileLoaded(pharmacy: pharmacy);
    });
  }

  Future<void> _onUpdatePharmacyProfile(
      UpdatePharmacyProfileEvent event,
      Emitter<PharmacyState> emit,
      ) async {
    emit(PharmacyLoading());

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
      return PharmacyUpdateSuccess(pharmacy: pharmacy);
    });
  }

  Future<void> _onUploadLicenseImage(
      UploadLicenseImageEvent event,
      Emitter<PharmacyState> emit,
      ) async {
    emit(PharmacyLoading());

    final result = await uploadLicenseImage(UploadLicenseImageParams(
      pharmacyId: event.pharmacyId,
      imagePath: event.imagePath,
    ));

    result.fold(
          (failure) => emit(PharmacyError(message: _mapFailureToMessage(failure))),
          (imageUrl) => emit(LicenseImageUploadSuccess(imageUrl: imageUrl)),
    );
  }

  void _onResetPharmacyState(
      ResetPharmacyStateEvent event,
      Emitter<PharmacyState> emit,
      ) {
    emit(PharmacyInitial());
  }

  void _emitEitherResult(
      Either<Failure, PharmacyEntity> result,
      Emitter<PharmacyState> emit,
      PharmacyState Function(PharmacyEntity) successState,
      ) {
    result.fold(
          (failure) => emit(PharmacyError(message: _mapFailureToMessage(failure))),
          (pharmacy) => emit(successState(pharmacy)),
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