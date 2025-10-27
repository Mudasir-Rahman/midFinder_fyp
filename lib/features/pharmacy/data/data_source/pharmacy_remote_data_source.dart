import '../model/pharmacy_model.dart';


abstract class PharmacyRemoteDataSource {
  Future<PharmacyModel> registerPharmacy({
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

  Future<PharmacyModel> getPharmacyProfile(String userId);

  Future<PharmacyModel> updatePharmacyProfile({
    required String pharmacyId,
    String? pharmacyName,
    String? address,
    String? phone,
    List<String>? operatingDays,
    String? openingTime,
    String? closingTime,
  });

  Future<String> uploadLicenseImage({
    required String pharmacyId,
    required String imagePath,
  });

  Future<List<PharmacyModel>> getNearbyPharmacies({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  });
  Future<PharmacyModel> selectPharmacyForOrder({
    required String pharmacyId,
    required String patientId,
    required List<Map<String, dynamic>> medicines,
  });
}