import 'package:equatable/equatable.dart';

import '../../domain/entity/patient_entity.dart';

abstract class PatientEvent extends Equatable {
  const PatientEvent();

  @override
  List<Object> get props => [];
}

class RegisterPatientEvent extends PatientEvent {
  final PatientEntity patient;

  const RegisterPatientEvent(this.patient);

  @override
  List<Object> get props => [patient];
}

class UpdatePatientLocationEvent extends PatientEvent {
  final String userId;
  final double latitude;
  final double longitude;

  const UpdatePatientLocationEvent({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [userId, latitude, longitude];
}

class GetPatientProfileEvent extends PatientEvent {
  final String userId;

  const GetPatientProfileEvent(this.userId);

  @override
  List<Object> get props => [userId];
}