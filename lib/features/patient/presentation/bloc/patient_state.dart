import 'package:equatable/equatable.dart';
import '../../../pharmacy/domain/entity/pharmacy_entity.dart';
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

// ✅ NEW STATE: Nearby Pharmacies Loaded
class NearbyPharmaciesLoaded extends PatientState {
  final List<PharmacyEntity> pharmacies;

  const NearbyPharmaciesLoaded(this.pharmacies);

  @override
  List<Object> get props => [pharmacies];
}

class PatientError extends PatientState {
  final String message;

  const PatientError(this.message);

  @override
  List<Object> get props => [message];
}