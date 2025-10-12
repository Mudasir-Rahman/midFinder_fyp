import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../entity/pharmacy_entity.dart';

abstract class PharmacyRepository {
  Future<Either<Failure, PharmacyEntity>> registerPharmacy({
    required String userId,
    required String pharmacyName,
    required String licenseNumber,
    required String address,
    required String phone,
    required double latitude,
    required double longitude,
    required List<String> operatingDays,
    required String openingTime,
    required String closingTime,
    String? licenseImageUrl,
  });

  Future<Either<Failure, PharmacyEntity>> getPharmacyProfile(String userId);

  Future<Either<Failure, PharmacyEntity>> updatePharmacyProfile({
    required String pharmacyId,
    String? pharmacyName,
    String? address,
    String? phone,
    List<String>? operatingDays,
    String? openingTime,
    String? closingTime,
  });

  Future<Either<Failure, String>> uploadLicenseImage({
    required String pharmacyId,
    required String imagePath,
  });

  Future<Either<Failure, List<PharmacyEntity>>> getNearbyPharmacies({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  });
}