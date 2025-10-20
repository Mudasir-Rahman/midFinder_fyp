// lib/features/medicine/data/data_source/medicine_remote_data_source.dart

import 'dart:io';
import 'package:rx_locator/features/medicine/data/model/medicine_model.dart';

abstract class MedicineRemoteDataSource {
  // Get ALL medicines
  Future<List<MedicineModel>> getAllMedicines();

  // Search medicines
  Future<List<MedicineModel>> searchMedicine(String query);

  // Get medicine details - SINGLE medicine
  Future<MedicineModel> getMedicineDetail(String medicineId);

  // Add new medicine (optionally with image)
  Future<void> addMedicine(MedicineModel medicine, {File? imageFile});

  // Update existing medicine (optionally with image)
  Future<void> updateMedicine(MedicineModel medicine, {File? imageFile});

  // Get pharmacy's medicines
  Future<List<MedicineModel>> getPharmacyMedicine(String pharmacyId);

  // Get medicines by category
  Future<List<MedicineModel>> getMedicineByCategory(String category);
}
