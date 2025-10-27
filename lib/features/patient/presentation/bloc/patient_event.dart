// import 'package:equatable/equatable.dart';
// import '../../domain/entity/patient_entity.dart';
//
// abstract class PatientEvent extends Equatable {
//   const PatientEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class RegisterPatientEvent extends PatientEvent {
//   final PatientEntity patient;
//
//   const RegisterPatientEvent(this.patient);
//
//   @override
//   List<Object> get props => [patient];
// }
//
// class UpdatePatientLocationEvent extends PatientEvent {
//   final String userId;
//   final double latitude;
//   final double longitude;
//
//   const UpdatePatientLocationEvent({
//     required this.userId,
//     required this.latitude,
//     required this.longitude,
//   });
//
//   @override
//   List<Object> get props => [userId, latitude, longitude];
// }
//
// class GetPatientProfileEvent extends PatientEvent {
//   final String userId;
//
//   const GetPatientProfileEvent( {required  this.userId});
//
//   @override
//   List<Object> get props => [userId];
// }
//
// // ✅ NEW EVENT: Get Nearby Pharmacies
// class GetNearbyPharmaciesEvent extends PatientEvent {
//   final double latitude;
//   final double longitude;
//   final double radiusInKm;
//
//   const GetNearbyPharmaciesEvent({
//     required this.latitude,
//     required this.longitude,
//     required this.radiusInKm,
//   });
//
//   @override
//   List<Object> get props => [latitude, longitude, radiusInKm];
// }
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

  const GetPatientProfileEvent( {required  this.userId});

  @override
  List<Object> get props => [userId];
}

// ✅ NEW EVENT: Auto-load stored patient
class LoadStoredPatientEvent extends PatientEvent {
  const LoadStoredPatientEvent();
}

// ✅ NEW EVENT: Get Nearby Pharmacies
class GetNearbyPharmaciesEvent extends PatientEvent {
  final double latitude;
  final double longitude;
  final double radiusInKm;

  const GetNearbyPharmaciesEvent({
    required this.latitude,
    required this.longitude,
    required this.radiusInKm,
  });

  @override
  List<Object> get props => [latitude, longitude, radiusInKm];
}