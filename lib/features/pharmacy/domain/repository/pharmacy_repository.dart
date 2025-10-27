// import 'package:dartz/dartz.dart';
// import '../../../../core/error/failures.dart';
//
// import '../entity/pharmacy_entity.dart';
//
// abstract class PharmacyRepository {
//   Future<Either<Failure, PharmacyEntity>> registerPharmacy({
//     required String userId,
//     required String pharmacyName,
//     required String licenseNumber,
//     required String address,
//     required String phone,
//     required double latitude,
//     required double longitude,
//     required List<String> operatingDays,
//     required String openingTime,
//     required String closingTime,
//     String? licenseImageUrl,
//   });
//
//   Future<Either<Failure, PharmacyEntity>> getPharmacyProfile(String userId);
//
//   Future<Either<Failure, PharmacyEntity>> updatePharmacyProfile({
//     required String pharmacyId,
//     String? pharmacyName,
//     String? address,
//     String? phone,
//     List<String>? operatingDays,
//     String? openingTime,
//     String? closingTime,
//   });
//
//   Future<Either<Failure, String>> uploadLicenseImage({
//     required String pharmacyId,
//     required String imagePath,
//   });
//
//   Future<Either<Failure, List<PharmacyEntity>>> getNearbyPharmacies({
//     required double latitude,
//     required double longitude,
//     required double radiusInKm,
//   });
// }
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/pharmacy_entity.dart';

abstract class PharmacyRepository {
  /// Register a new pharmacy (after successful pharmacy owner registration)
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

  /// Fetch pharmacy profile by user ID
  Future<Either<Failure, PharmacyEntity>> getPharmacyProfile(String userId);

  /// Update existing pharmacy profile info
  Future<Either<Failure, PharmacyEntity>> updatePharmacyProfile({
    required String pharmacyId,
    String? pharmacyName,
    String? address,
    String? phone,
    List<String>? operatingDays,
    String? openingTime,
    String? closingTime,
  });

  /// Upload a new or updated license image
  Future<Either<Failure, String>> uploadLicenseImage({
    required String pharmacyId,
    required String imagePath,
  });

  /// Get a list of pharmacies near a given location
  /// (patient latitude/longitude)
  ///
  /// Each returned [PharmacyEntity] will include `distanceFromPatient`
  /// computed locally in kilometers.
  Future<Either<Failure, List<PharmacyEntity>>> getNearbyPharmacies({
    required double latitude,   // patient's latitude
    required double longitude,  // patient's longitude
    required double radiusInKm, // radius to search in km
  });
}
