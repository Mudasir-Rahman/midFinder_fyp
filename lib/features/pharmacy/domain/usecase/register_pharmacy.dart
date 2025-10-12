import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entity/pharmacy_entity.dart';
import '../repository/pharmacy_repository.dart';

class RegisterPharmacy implements UseCase<PharmacyEntity, RegisterPharmacyParams> {
  final PharmacyRepository repository;

  RegisterPharmacy(this.repository);

  @override
  Future<Either<Failure, PharmacyEntity>> call(RegisterPharmacyParams params) async {
    return await repository.registerPharmacy(
      userId: params.userId,
      pharmacyName: params.pharmacyName,
      licenseNumber: params.licenseNumber,
      address: params.address,
      phone: params.phone,
      latitude: params.latitude,
      longitude: params.longitude,
      operatingDays: params.operatingDays,
      openingTime: params.openingTime,
      closingTime: params.closingTime,
      licenseImageUrl: params.licenseImageUrl,
    );
  }
}

class RegisterPharmacyParams {
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
  final String? licenseImageUrl;

  RegisterPharmacyParams({
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
    this.licenseImageUrl,
  });
}