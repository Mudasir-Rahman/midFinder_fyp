import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rx_locator/core/error/failures.dart';
import 'package:rx_locator/features/medicine/data/data_source/medicine_remote_data_source.dart';
import 'package:rx_locator/features/medicine/data/model/medicine_model.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource remoteDataSource;

  MedicineRepositoryImpl({
    required this.remoteDataSource,
  });

  // 🩺 Get all medicines
  @override
  Future<Either<Failure, List<MedicineEntity>>> getAllMedicines() async {
    try {
      final medicines = await remoteDataSource.getAllMedicines();
      // Since MedicineModel extends MedicineEntity, we can cast directly
      return Right(medicines.cast<MedicineEntity>().toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // 🔍 Search medicine by query
  @override
  Future<Either<Failure, List<MedicineEntity>>> searchMedicine(String query) async {
    try {
      final medicines = await remoteDataSource.searchMedicine(query);
      // Since MedicineModel extends MedicineEntity, we can cast directly
      return Right(medicines.cast<MedicineEntity>().toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // 📋 Get medicine detail (SINGLE medicine)
  @override
  Future<Either<Failure, MedicineEntity>> getMedicineDetail(String medicineId) async {
    try {
      final medicine = await remoteDataSource.getMedicineDetail(medicineId);
      // Since MedicineModel extends MedicineEntity, we can return directly
      return Right(medicine);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ➕ Add new medicine with optional image
  @override
  Future<Either<Failure, void>> addMedicine(MedicineEntity medicine, {XFile? imageFile}) async {
    try {
      // Convert XFile to File if image is provided
      File? file;
      if (imageFile != null) {
        file = File(imageFile.path);
      }

      // Since MedicineEntity is the base class, we need to create a MedicineModel
      final medicineModel = MedicineModel(
        id: medicine.id,
        pharmacyId: medicine.pharmacyId,
        medicineName: medicine.medicineName,
        dosage: medicine.dosage,
        manufacturer: medicine.manufacturer,
        description: medicine.description,
        category: medicine.category,
        genericName: medicine.genericName,
        imageUrl: medicine.imageUrl,
        createdAt: medicine.createdAt,
        price: medicine.price,
        stockQuantity: medicine.stockQuantity,
        isAvailable: medicine.isAvailable,
        requiresPrescription: medicine.requiresPrescription,
      );

      print('🟢 [Repository] Adding medicine: ${medicineModel.toJson()}');

      // Call remote data source with File parameter
      await remoteDataSource.addMedicine(medicineModel, imageFile: file);

      print('✅ [Repository] Medicine added successfully');
      return const Right(null);
    } on PostgrestException catch (e) {
      print('❌ [Supabase Error] ${e.message}');
      return Left(ServerFailure(e.message));
    } on ServerFailure catch (e) {
      print('❌ [Server Failure] ${e.message}');
      return Left(e);
    } catch (e) {
      print('❌ [Repository Error] $e');
      return Left(ServerFailure('Failed to add medicine: ${e.toString()}'));
    }
  }

  // ✏️ Update existing medicine with optional image
  @override
  Future<Either<Failure, void>> updateMedicine(MedicineEntity medicine, {XFile? imageFile}) async {
    try {
      // Convert XFile to File if image is provided
      File? file;
      if (imageFile != null) {
        file = File(imageFile.path);
      }

      // Since MedicineEntity is the base class, we need to create a MedicineModel
      final medicineModel = MedicineModel(
        id: medicine.id,
        pharmacyId: medicine.pharmacyId,
        medicineName: medicine.medicineName,
        dosage: medicine.dosage,
        manufacturer: medicine.manufacturer,
        description: medicine.description,
        category: medicine.category,
        genericName: medicine.genericName,
        imageUrl: medicine.imageUrl,
        createdAt: medicine.createdAt,
        price: medicine.price,
        stockQuantity: medicine.stockQuantity,
        isAvailable: medicine.isAvailable,
        requiresPrescription: medicine.requiresPrescription,
      );

      print('🟠 [Repository] Updating medicine ${medicine.id}');

      // Call remote data source with File parameter
      await remoteDataSource.updateMedicine(medicineModel, imageFile: file);

      print('✅ [Repository] Medicine updated successfully');
      return const Right(null);
    } on PostgrestException catch (e) {
      print('❌ [Supabase Error] ${e.message}');
      return Left(ServerFailure(e.message));
    } on ServerFailure catch (e) {
      print('❌ [Server Failure] ${e.message}');
      return Left(e);
    } catch (e) {
      print('❌ [Repository Error] $e');
      return Left(ServerFailure('Failed to update medicine: ${e.toString()}'));
    }
  }

  // 🏥 Get pharmacy's medicines (takes String pharmacyId)
  @override
  Future<Either<Failure, List<MedicineEntity>>> getPharmacyMedicine(String pharmacyId) async {
    try {
      final medicines = await remoteDataSource.getPharmacyMedicine(pharmacyId);
      // Since MedicineModel extends MedicineEntity, we can cast directly
      return Right(medicines.cast<MedicineEntity>().toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // 🧩 Get medicines by category
  @override
  Future<Either<Failure, List<MedicineEntity>>> getMedicineByCategory(String category) async {
    try {
      final medicines = await remoteDataSource.getMedicineByCategory(category);
      // Since MedicineModel extends MedicineEntity, we can cast directly
      return Right(medicines.cast<MedicineEntity>().toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}