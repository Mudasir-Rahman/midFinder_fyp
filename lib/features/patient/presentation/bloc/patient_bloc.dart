import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';

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

  PatientBloc({
    required this.registerPatient,
    required this.updatePatientLocation,
    required this.getPatientProfile,
  }) : super(PatientInitial()) {
    on<RegisterPatientEvent>(_onRegisterPatientEvent);
    on<UpdatePatientLocationEvent>(_onUpdatePatientLocationEvent);
    on<GetPatientProfileEvent>(_onGetPatientProfileEvent);
  }

  Future<void> _onRegisterPatientEvent(
      RegisterPatientEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());
    final Either<Failure, PatientEntity> result = await registerPatient(event.patient);

    result.fold(
          (failure) => emit(PatientError(_mapFailureToMessage(failure))),
          (patient) => emit(PatientRegistered(patient)),
    );
  }

  Future<void> _onUpdatePatientLocationEvent(
      UpdatePatientLocationEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());
    final Either<Failure, PatientEntity> result = await updatePatientLocation(
      UpdatePatientLocationParams(
        userId: event.userId,
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    result.fold(
          (failure) => emit(PatientError(_mapFailureToMessage(failure))),
          (patient) => emit(PatientLocationUpdated(patient)),
    );
  }

  Future<void> _onGetPatientProfileEvent(
      GetPatientProfileEvent event,
      Emitter<PatientState> emit,
      ) async {
    emit(PatientLoading());
    final Either<Failure, PatientEntity> result = await getPatientProfile(event.userId);

    result.fold(
          (failure) => emit(PatientError(_mapFailureToMessage(failure))),
          (patient) => emit(PatientProfileLoaded(patient)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case CacheFailure:
        return 'Cache failure: ${failure.message}';
      case NetworkFailure:
        return 'Network failure: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}