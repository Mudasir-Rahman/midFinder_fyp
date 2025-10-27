//
// import 'package:bloc/bloc.dart';
//
// import '../../../../core/error/failures.dart';
//
// import '../../../pharmacy/domain/usecase/search_nearby_pharmacies.dart';
//
// import '../../domain/usecase/register_patient.dart';
// import '../../domain/usecase/update_patient_location.dart';
// import '../../domain/usecase/get_patient_profile.dart';
// import 'patient_event.dart';
// import 'patient_state.dart';
//
// class PatientBloc extends Bloc<PatientEvent, PatientState> {
//   final RegisterPatientUseCase registerPatient;
//   final UpdatePatientLocationUseCase updatePatientLocation;
//   final GetPatientProfileUseCase getPatientProfile;
//   final SearchNearbyPharmacies searchNearbyPharmacies;
//
//   PatientBloc({
//     required this.registerPatient,
//     required this.updatePatientLocation,
//     required this.getPatientProfile,
//     required this.searchNearbyPharmacies,
//   }) : super(PatientInitial()) {
//     on<RegisterPatientEvent>(_onRegisterPatientEvent);
//     on<UpdatePatientLocationEvent>(_onUpdatePatientLocationEvent);
//     on<GetPatientProfileEvent>(_onGetPatientProfileEvent);
//     on<GetNearbyPharmaciesEvent>(_onGetNearbyPharmaciesEvent);
//   }
//
//   // Register Patient
//   Future<void> _onRegisterPatientEvent(
//       RegisterPatientEvent event,
//       Emitter<PatientState> emit,
//       ) async {
//     emit(PatientLoading());
//     final result = await registerPatient(event.patient);
//     result.fold(
//           (failure) => emit(PatientError(_mapFailureToMessage(failure))),
//           (patient) => emit(PatientRegistered(patient)),
//     );
//   }
//
//   // Update Patient Location
//   Future<void> _onUpdatePatientLocationEvent(
//       UpdatePatientLocationEvent event,
//       Emitter<PatientState> emit,
//       ) async {
//     emit(PatientLoading());
//     final result = await updatePatientLocation(UpdatePatientLocationParams(
//       userId: event.userId,
//       latitude: event.latitude,
//       longitude: event.longitude,
//     ));
//     result.fold(
//           (failure) => emit(PatientError(_mapFailureToMessage(failure))),
//           (patient) => emit(PatientLocationUpdated(patient)),
//     );
//   }
//
//   // Get Patient Profile
//   Future<void> _onGetPatientProfileEvent(
//       GetPatientProfileEvent event,
//       Emitter<PatientState> emit,
//       ) async {
//     emit(PatientLoading());
//     final result = await getPatientProfile(event.userId);
//     result.fold(
//           (failure) => emit(PatientError(_mapFailureToMessage(failure))),
//           (patient) => emit(PatientProfileLoaded(patient)),
//     );
//   }
//
//   // Get Nearby Pharmacies
//   Future<void> _onGetNearbyPharmaciesEvent(
//       GetNearbyPharmaciesEvent event,
//       Emitter<PatientState> emit,
//       ) async {
//     emit(PatientLoading());
//     final result = await searchNearbyPharmacies(SearchNearbyPharmaciesParams(
//       latitude: event.latitude,
//       longitude: event.longitude,
//       radiusInKm: event.radiusInKm,
//     ));
//     result.fold(
//           (failure) => emit(PatientError(_mapFailureToMessage(failure))),
//           (pharmacies) => emit(NearbyPharmaciesLoaded(pharmacies)),
//     );
//   }
//
//   // Map Failures to Messages
//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return 'Server Error: ${failure.message}';
//       case CacheFailure:
//         return 'Cache Error: ${failure.message}';
//       case NetworkFailure:
//         return 'Network Error: ${failure.message}';
//       default:
//         return 'Unexpected Error: ${failure.message}';
//     }
//   }
// }
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../pharmacy/domain/entity/pharmacy_entity.dart';
import '../../../pharmacy/domain/usecase/search_nearby_pharmacies.dart';
import '../../domain/entity/patient_entity.dart';
import '../../domain/usecase/register_patient.dart';
import '../../domain/usecase/update_patient_location.dart';
import '../../domain/usecase/get_patient_profile.dart';
import 'patient_event.dart';
import 'patient_state.dart';

class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final RegisterPatientUseCase registerPatient;
  final UpdatePatientLocationUseCase updatePatientLocation;
  final GetPatientProfileUseCase getPatientProfile;
  final SearchNearbyPharmacies searchNearbyPharmacies;

  PatientBloc({
    required this.registerPatient,
    required this.updatePatientLocation,
    required this.getPatientProfile,
    required this.searchNearbyPharmacies,
  }) : super(PatientInitial()) {
    on<RegisterPatientEvent>(_onRegisterPatientEvent);
    on<UpdatePatientLocationEvent>(_onUpdatePatientLocationEvent);
    on<GetPatientProfileEvent>(_onGetPatientProfileEvent);
    on<LoadStoredPatientEvent>(_onLoadStoredPatientEvent); // NEW EVENT
    on<GetNearbyPharmaciesEvent>(_onGetNearbyPharmaciesEvent);
  }

  // Register Patient
  Future<void> _onRegisterPatientEvent(
      RegisterPatientEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());
    final result = await registerPatient(event.patient);
    result.fold(
          (failure) => emit(PatientError(_mapFailureToMessage(failure))),
          (patient) => emit(PatientRegistered(patient)),
    );
  }

  // Update Patient Location
  Future<void> _onUpdatePatientLocationEvent(
      UpdatePatientLocationEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());
    final result = await updatePatientLocation(UpdatePatientLocationParams(
      userId: event.userId,
      latitude: event.latitude,
      longitude: event.longitude,
    ));
    result.fold(
          (failure) => emit(PatientError(_mapFailureToMessage(failure))),
          (patient) => emit(PatientLocationUpdated(patient)),
    );
  }

  // Get Patient Profile
  Future<void> _onGetPatientProfileEvent(
      GetPatientProfileEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());
    final result = await getPatientProfile(event.userId);
    result.fold(
          (failure) => emit(PatientError(_mapFailureToMessage(failure))),
          (patient) => emit(PatientProfileLoaded(patient)),
    );
  }

  // NEW: Auto-load patient profile
  Future<void> _onLoadStoredPatientEvent(
      LoadStoredPatientEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());

    try {
      // Get stored user ID from your auth service
      final userId = await _getStoredUserId();

      if (userId != null && userId.isNotEmpty) {
        final result = await getPatientProfile(userId);
        result.fold(
              (failure) => emit(PatientError(_mapFailureToMessage(failure))),
              (patient) => emit(PatientProfileLoaded(patient)),
        );
      } else {
        emit(PatientInitial()); // No user stored
      }
    } catch (e) {
      emit(PatientError('Failed to load patient: $e'));
    }
  }

  // Get Nearby Pharmacies
  Future<void> _onGetNearbyPharmaciesEvent(
      GetNearbyPharmaciesEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());
    final result = await searchNearbyPharmacies(SearchNearbyPharmaciesParams(
      latitude: event.latitude,
      longitude: event.longitude,
      radiusInKm: event.radiusInKm,
    ));
    result.fold(
          (failure) => emit(PatientError(_mapFailureToMessage(failure))),
          (pharmacies) => emit(NearbyPharmaciesLoaded(pharmacies)),
    );
  }

  // Helper method to get stored user ID
  Future<String?> _getStoredUserId() async {
    // Implement your storage logic here
    // Example with SharedPreferences:
    // final prefs = await SharedPreferences.getInstance();
    // return prefs.getString('patient_user_id');

    // For now, return null - you'll need to implement this
    return null;
  }

  // Map Failures to Messages
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error: ${failure.message}';
      case CacheFailure:
        return 'Cache Error: ${failure.message}';
      case NetworkFailure:
        return 'Network Error: ${failure.message}';
      default:
        return 'Unexpected Error: ${failure.message}';
    }
  }
}