import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/core/error/failures.dart';
import 'package:rx_locator/features/medicine/data/model/medicine_model.dart';
import 'medicine_remote_data_source.dart';

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  final SupabaseClient supabaseClient;

  MedicineRemoteDataSourceImpl({required this.supabaseClient});

  /// 🔹 Default fallback image URL
  static const String defaultImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/480px-No_image_available.svg.png';

  // ============================================================
  // 🔹 Helper: Upload image to Supabase Storage
  // ============================================================
  Future<String> _uploadMedicineImage(File? imageFile) async {
    if (imageFile == null) return defaultImageUrl;

    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw const ServerFailure('User not authenticated.');
      }

      final imagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabaseClient.storage
          .from('medicine_image')
          .upload(imagePath, imageFile);

      final imageUrl = supabaseClient.storage
          .from('medicine_image')
          .getPublicUrl(imagePath);

      return imageUrl;
    } on StorageException catch (e) {
      throw ServerFailure('Image upload failed: ${e.message}');
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }

  // ============================================================
  // 🔹 Debug: Check authentication state
  // ============================================================
  Future<void> _debugAuthState() async {
    final user = supabaseClient.auth.currentUser;
    print('🔐 Current User: ${user?.id}');
    print('🔐 User Email: ${user?.email}');

    if (user != null) {
      final pharmacy = await supabaseClient
          .from('pharmacies')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();
      print('🏪 Pharmacy Profile: $pharmacy');
    }
  }

  // ============================================================
  // 🔹 Add new medicine (with RLS pharmacy check)
  // ============================================================
  @override
  Future<void> addMedicine(MedicineModel medicine, {File? imageFile}) async {
    try {
      await _debugAuthState();

      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw const ServerFailure('User not authenticated. Please log in.');
      }

      // 🔍 Get pharmacy_id of this user
      final pharmacyResponse = await supabaseClient
          .from('pharmacies')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (pharmacyResponse == null) {
        throw const ServerFailure('Pharmacy profile not found. Please complete your pharmacy registration first.');
      }

      final pharmacyId = pharmacyResponse['id'] as String;

      // 🔹 SIMPLE IMAGE HANDLING - FIXED
      String imageUrl = defaultImageUrl;
      if (imageFile != null) {
        try {
          imageUrl = await _uploadMedicineImage(imageFile);
          print('📸 Image uploaded successfully: $imageUrl');
        } catch (e) {
          print('❌ Image upload failed, using default: $e');
          // Continue with default image even if upload fails
        }
      } else {
        print('🖼️ No image provided, using default image');
      }

      final data = medicine.toJson();
      data['pharmacy_id'] = pharmacyId;
      data['image_url'] = imageUrl;
      data['created_at'] = DateTime.now().toIso8601String();

      final response = await supabaseClient
          .from('medicines')
          .insert(data)
          .select()
          .single();

      print('✅ Medicine added for pharmacy_id: $pharmacyId');
    } on PostgrestException catch (e) {
      throw ServerFailure('Database error: ${e.message}');
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }

  // ============================================================
  // 🔹 Update medicine (RLS-safe)
  // ============================================================
  @override
  Future<void> updateMedicine(MedicineModel medicine, {File? imageFile}) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) throw const ServerFailure('User not authenticated.');

      // Check ownership
      final pharmacyResponse = await supabaseClient
          .from('pharmacies')
          .select('id')
          .eq('user_id', userId)
          .single();

      final pharmacyId = pharmacyResponse['id'] as String;

      // 🔹 SIMPLE IMAGE HANDLING - FIXED
      String imageUrl = medicine.imageUrl ?? defaultImageUrl;
      if (imageFile != null) {
        try {
          imageUrl = await _uploadMedicineImage(imageFile);
          print('📸 Image uploaded successfully: $imageUrl');
        } catch (e) {
          print('❌ Image upload failed, keeping existing image: $e');
          // Keep existing image URL if upload fails
        }
      }

      final data = medicine.toJson();
      data['image_url'] = imageUrl;

      await supabaseClient
          .from('medicines')
          .update(data)
          .eq('id', medicine.id!)
          .eq('pharmacy_id', pharmacyId);

      print('🔄 Medicine updated for pharmacy_id: $pharmacyId');
    } on PostgrestException catch (e) {
      throw ServerFailure('Database error: ${e.message}');
    } catch (e) {
      throw ServerFailure('Unexpected error: $e');
    }
  }

  // ============================================================
  // 🔹 Get all available medicines
  // ============================================================
  @override
  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select('*, pharmacies(pharmacy_name, address, phone)')
          .eq('is_available', true)
          .order('medicine_name');

      return response
          .map((json) => MedicineModel.fromJson(json))
          .cast<MedicineModel>()
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ============================================================
  // 🔹 Search medicines
  // ============================================================
  @override
  Future<List<MedicineModel>> searchMedicine(String query) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select('*, pharmacies(pharmacy_name, address, phone)')
          .or('medicine_name.ilike.%$query%,generic_name.ilike.%$query%')
          .eq('is_available', true)
          .order('medicine_name');

      return response
          .map((json) => MedicineModel.fromJson(json))
          .cast<MedicineModel>()
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ============================================================
  // 🔹 Get single medicine detail
  // ============================================================
  @override
  Future<MedicineModel> getMedicineDetail(String medicineId) async {
    try {
      final dynamic response = await supabaseClient
          .from('medicines')
          .select('*, pharmacies(pharmacy_name, address, phone)')
          .eq('id', medicineId)
          .single();

      return MedicineModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ============================================================
  // 🔹 Get medicines of current pharmacy
  // ============================================================
  @override
  Future<List<MedicineModel>> getPharmacyMedicine(String pharmacyId) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select()
          .eq('pharmacy_id', pharmacyId)
          .order('medicine_name');

      return response
          .map((json) => MedicineModel.fromJson(json))
          .cast<MedicineModel>()
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // ============================================================
  // 🔹 Get medicines by category
  // ============================================================
  @override
  Future<List<MedicineModel>> getMedicineByCategory(String category) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select('*, pharmacies(pharmacy_name, address, phone)')
          .eq('category', category)
          .eq('is_available', true)
          .order('medicine_name');

      return response
          .map((json) => MedicineModel.fromJson(json))
          .cast<MedicineModel>()
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}