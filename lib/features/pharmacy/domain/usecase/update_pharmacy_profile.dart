import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entity/pharmacy_entity.dart';
import '../repository/pharmacy_repository.dart';

class UpdatePharmacyProfile implements UseCase<PharmacyEntity, UpdatePharmacyProfileParams> {
  final PharmacyRepository repository;

  UpdatePharmacyProfile(this.repository);

  @override
  Future<Either<Failure, PharmacyEntity>> call(UpdatePharmacyProfileParams params) async {
    return await repository.updatePharmacyProfile(
      pharmacyId: params.pharmacyId,
      pharmacyName: params.pharmacyName,
      address: params.address,
      phone: params.phone,
      operatingDays: params.operatingDays,
      openingTime: params.openingTime,
      closingTime: params.closingTime,
    );
  }
}

class UpdatePharmacyProfileParams {
  final String pharmacyId;
  final String? pharmacyName;
  final String? address;
  final String? phone;
  final List<String>? operatingDays;
  final String? openingTime;
  final String? closingTime;

  UpdatePharmacyProfileParams({
    required this.pharmacyId,
    this.pharmacyName,
    this.address,
    this.phone,
    this.operatingDays,
    this.openingTime,
    this.closingTime,
  });
}