import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_locator/core/error/failures.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

abstract class MedicineRepository {
  // For Patients - Search medicines
  Future<Either<Failure, List<MedicineEntity>>> searchMedicine(String query);

  // ✅ ADD THIS: Search nearby medicines
  Future<Either<Failure, List<MedicineEntity>>> searchNearbyMedicine(String query, double latitude, double longitude);

  // For Patients - Get medicine details (SINGLE medicine, not list)
  Future<Either<Failure, MedicineEntity>> getMedicineDetail(String medicineId);

  // For Pharmacy - Add new medicine (returns void, not list)
  Future<Either<Failure, void>> addMedicine(MedicineEntity medicine, {XFile? imageFile});

  // For Pharmacy - Update existing medicine (returns void, not list)
  Future<Either<Failure, void>> updateMedicine(MedicineEntity medicine, {XFile? imageFile});

  // For Pharmacy - Get pharmacy's medicines (takes String pharmacyId, not MedicineEntity)
  Future<Either<Failure, List<MedicineEntity>>> getPharmacyMedicine(String pharmacyId);

  // Get medicines by category
  Future<Either<Failure, List<MedicineEntity>>> getMedicineByCategory(String category);

  // Get all medicines
  Future<Either<Failure, List<MedicineEntity>>> getAllMedicines();
}