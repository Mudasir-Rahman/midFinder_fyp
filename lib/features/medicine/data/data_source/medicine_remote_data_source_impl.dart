// lib/features/medicine/data/data_source/medicine_remote_data_source_impl.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/core/error/failures.dart';
import 'package:rx_locator/features/medicine/data/model/medicine_model.dart';
import 'medicine_remote_data_source.dart';

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  final SupabaseClient supabaseClient;

  MedicineRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<MedicineModel>> getAllMedicines() async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select()
          .order('medicine_name');

      if (response.isEmpty) {
        return [];
      }

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

  @override
  Future<List<MedicineModel>> searchMedicine(String query) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select()
          .ilike('medicine_name', '%$query%')
          .order('medicine_name');

      if (response.isEmpty) {
        return [];
      }

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

  @override
  Future<MedicineModel> getMedicineDetail(String medicineId) async {
    try {
      final dynamic response = await supabaseClient
          .from('medicines')
          .select()
          .eq('id', medicineId)
          .single();

      return MedicineModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> addMedicine(MedicineModel medicine) async {
    try {
      await supabaseClient
          .from('medicines')
          .insert(medicine.toJson());
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateMedicine(MedicineModel medicine) async {
    try {
      await supabaseClient
          .from('medicines')
          .update(medicine.toJson())
          .eq('id', medicine.id);
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<MedicineModel>> getPharmacyMedicine(String pharmacyId) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select()
          .eq('pharmacy_id', pharmacyId)
          .order('medicine_name');

      if (response.isEmpty) {
        return [];
      }

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

  @override
  Future<List<MedicineModel>> getMedicineByCategory(String category) async {
    try {
      final List<dynamic> response = await supabaseClient
          .from('medicines')
          .select()
          .eq('category', category)
          .order('medicine_name');

      if (response.isEmpty) {
        return [];
      }

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