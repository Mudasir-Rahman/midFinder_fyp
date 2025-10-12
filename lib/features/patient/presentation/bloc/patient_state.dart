import 'package:equatable/equatable.dart';

import '../../domain/entity/patient_entity.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientRegistered extends PatientState {
  final PatientEntity patient;

  const PatientRegistered(this.patient);

  @override
  List<Object> get props => [patient];
}

class PatientProfileLoaded extends PatientState {
  final PatientEntity patient;

  const PatientProfileLoaded(this.patient);

  @override
  List<Object> get props => [patient];
}

class PatientLocationUpdated extends PatientState {
  final PatientEntity patient;

  const PatientLocationUpdated(this.patient);

  @override
  List<Object> get props => [patient];
}

class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object> get props => [message];
}