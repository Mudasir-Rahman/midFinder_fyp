part of 'pharmacy_bloc.dart';


abstract class PharmacyState extends Equatable {
  const PharmacyState();

  @override
  List<Object> get props => [];
}

class PharmacyInitial extends PharmacyState {}

class PharmacyLoading extends PharmacyState {}

class PharmacyRegistrationSuccess extends PharmacyState {
  final PharmacyEntity pharmacy;

  const PharmacyRegistrationSuccess({required this.pharmacy});

  @override
  List<Object> get props => [pharmacy];
}

class PharmacyProfileLoaded extends PharmacyState {
  final PharmacyEntity pharmacy;

  const PharmacyProfileLoaded({required this.pharmacy});

  @override
  List<Object> get props => [pharmacy];
}

class PharmacyUpdateSuccess extends PharmacyState {
  final PharmacyEntity pharmacy;

  const PharmacyUpdateSuccess({required this.pharmacy});

  @override
  List<Object> get props => [pharmacy];
}

class LicenseImageUploadSuccess extends PharmacyState {
  final String imageUrl;

  const LicenseImageUploadSuccess({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class PharmacyError extends PharmacyState {
  final String message;

  const PharmacyError({required this.message});

  @override
  List<Object> get props => [message];
}