
import 'dart:io';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exception.dart';
import '../model/pharmacy_model.dart';
import 'pharmacy_remote_data_source.dart';

class PharmacyRemoteDataSourceImpl implements PharmacyRemoteDataSource {
  final SupabaseClient supabaseClient;

  PharmacyRemoteDataSourceImpl({required this.supabaseClient});

  @override
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
  }) async {
    try {
      final response = await supabaseClient
          .from('pharmacies')
          .insert({
        'user_id': userId,
        'pharmacy_name': pharmacyName,
        'license_number': licenseNumber,
        'address': address,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude,
        'operating_days': operatingDays,
        'opening_time': openingTime,
        'closing_time': closingTime,
        'license_image_url': licenseImageUrl,
        'is_verified': false,
        'created_at': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      return PharmacyModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to register pharmacy: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<PharmacyModel> getPharmacyProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('pharmacies')
          .select()
          .eq('user_id', userId)
          .single();

      return PharmacyModel.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        throw NotFoundException('Pharmacy profile not found');
      }
      throw ServerException('Failed to fetch pharmacy profile: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<PharmacyModel> updatePharmacyProfile({
    required String pharmacyId,
    String? pharmacyName,
    String? address,
    String? phone,
    List<String>? operatingDays,
    String? openingTime,
    String? closingTime,
  }) async {
    try {
      final updates = <String, dynamic>{};

      if (pharmacyName != null) updates['pharmacy_name'] = pharmacyName;
      if (address != null) updates['address'] = address;
      if (phone != null) updates['phone'] = phone;
      if (operatingDays != null) updates['operating_days'] = operatingDays;
      if (openingTime != null) updates['opening_time'] = openingTime;
      if (closingTime != null) updates['closing_time'] = closingTime;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await supabaseClient
          .from('pharmacies')
          .update(updates)
          .eq('id', pharmacyId)
          .select()
          .single();

      return PharmacyModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update pharmacy profile: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadLicenseImage({
    required String pharmacyId,
    required String imagePath,
  }) async {
    try {
      final file = File(imagePath);
      final fileBytes = await file.readAsBytes();

      final fileName = 'license_${pharmacyId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabaseClient.storage
          .from('license_images')
          .uploadBinary(fileName, fileBytes);

      final imageUrl = supabaseClient.storage
          .from('license_images')
          .getPublicUrl(fileName);

      await supabaseClient
          .from('pharmacies')
          .update({'license_image_url': imageUrl})
          .eq('id', pharmacyId);

      return imageUrl;
    } on StorageException catch (e) {
      throw UploadException('Failed to upload license image: ${e.message}');
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update pharmacy record: ${e.message}');
    } catch (e) {
      throw UploadException('Unexpected error during upload: ${e.toString()}');
    }
  }

  @override
  Future<List<PharmacyModel>> getNearbyPharmacies({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    try {
      final response = await supabaseClient
          .from('pharmacies')
          .select()
          .eq('is_verified', true);

      final pharmacies = (response as List)
          .map((json) => PharmacyModel.fromJson(json))
          .toList();

      final nearbyPharmacies = pharmacies.where((pharmacy) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          pharmacy.latitude,
          pharmacy.longitude,
        );
        return distance <= radiusInKm;
      }).toList();

      return nearbyPharmacies;
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch nearby pharmacies: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  // ✅ ADD THIS NEW METHOD FOR PATIENT PHARMACY SELECTION
  @override
  Future<PharmacyModel> selectPharmacyForOrder({
    required String pharmacyId,
    required String patientId,
    required List<Map<String, dynamic>> medicines,
  }) async {
    try {
      // 1. First verify pharmacy exists and is available
      final pharmacyResponse = await supabaseClient
          .from('pharmacies')
          .select()
          .eq('id', pharmacyId)
          .eq('is_verified', true)
          .single();

      final pharmacy = PharmacyModel.fromJson(pharmacyResponse);

      // 2. Check medicine availability in pharmacy inventory
      final medicineIds = medicines.map((med) => med['medicine_id']).toList();

      final inventoryResponse = await supabaseClient
          .from('pharmacy_inventory')
          .select('medicine_id, stock_quantity')
          .eq('pharmacy_id', pharmacyId)
          .filter('medicine_id', 'in', medicineIds);

      // 3. Validate stock availability
      for (final medicine in medicines) {
        final inventoryItem = inventoryResponse.firstWhere(
              (item) => item['medicine_id'] == medicine['medicine_id'],
          orElse: () => {'stock_quantity': 0},
        );

        if ((inventoryItem['stock_quantity'] as int) < (medicine['quantity'] as int)) {
          throw Exception('Insufficient stock for medicine ${medicine['medicine_id']}');
        }
      }

      // 4. Create order or reserve medicines (depending on your flow)
      final orderResponse = await supabaseClient
          .from('orders')
          .insert({
        'patient_id': patientId,
        'pharmacy_id': pharmacyId,
        'medicines': medicines,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      return pharmacy;

    } on PostgrestException catch (e) {
      throw ServerException('Failed to select pharmacy: ${e.message}');
    } catch (e) {
      throw ServerException('Pharmacy selection error: ${e.toString()}');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180;
}