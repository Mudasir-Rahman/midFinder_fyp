part of 'pharmacy_bloc.dart';

abstract class PharmacyEvent extends Equatable {
  const PharmacyEvent();

  @override
  List<Object> get props => [];
}

class RegisterPharmacyEvent extends PharmacyEvent {
  final String userId;
  final String pharmacyName;
  final String licenseNumber;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final List<String> operatingDays;
  final String openingTime;
  final String closingTime;
  final String? licenseImagePath;

  const RegisterPharmacyEvent({
    required this.userId,
    required this.pharmacyName,
    required this.licenseNumber,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.operatingDays,
    required this.openingTime,
    required this.closingTime,
    this.licenseImagePath,
  });

  @override
  List<Object> get props => [
    userId,
    pharmacyName,
    licenseNumber,
    address,
    phone,
    latitude,
    longitude,
    operatingDays,
    openingTime,
    closingTime,
    licenseImagePath ?? '',
  ];
}

class GetPharmacyProfileEvent extends PharmacyEvent {
  final String userId;

  const GetPharmacyProfileEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdatePharmacyProfileEvent extends PharmacyEvent {
  final String pharmacyId;
  final String? pharmacyName;
  final String? address;
  final String? phone;
  final List<String>? operatingDays;
  final String? openingTime;
  final String? closingTime;

  const UpdatePharmacyProfileEvent({
    required this.pharmacyId,
    this.pharmacyName,
    this.address,
    this.phone,
    this.operatingDays,
    this.openingTime,
    this.closingTime,
  });

  @override
  List<Object> get props => [
    pharmacyId,
    pharmacyName ?? '',
    address ?? '',
    phone ?? '',
    operatingDays ?? [],
    openingTime ?? '',
    closingTime ?? '',
  ];
}

class UploadLicenseImageEvent extends PharmacyEvent {
  final String pharmacyId;
  final String imagePath;

  const UploadLicenseImageEvent({
    required this.pharmacyId,
    required this.imagePath,
  });

  @override
  List<Object> get props => [pharmacyId, imagePath];
}

class ResetPharmacyStateEvent extends PharmacyEvent {}