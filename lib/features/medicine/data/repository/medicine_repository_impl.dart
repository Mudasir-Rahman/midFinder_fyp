import 'package:dartz/dartz.dart';
import 'package:rx_locator/features/medicine/data/data_source/medicine_remote_data_source.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';
import 'package:rx_locator/core/error/failures.dart';
import 'package:rx_locator/features/medicine/data/model/medicine_model.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource remoteDataSource;

  MedicineRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<MedicineEntity>>> getAllMedicines() async {
    try {
      final medicines = await remoteDataSource.getAllMedicines();
      // Since MedicineModel extends MedicineEntity, we can return them directly
      return Right(medicines.toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MedicineEntity>>> searchMedicine(String query) async {
    try {
      final medicines = await remoteDataSource.searchMedicine(query);
      return Right(medicines.toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicineEntity>> getMedicineDetail(String medicineId) async {
    try {
      final medicine = await remoteDataSource.getMedicineDetail(medicineId);
      return Right(medicine);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMedicine(MedicineEntity medicine) async {
    try {
      // Since MedicineModel extends MedicineEntity, we can cast it directly
      // or create a new MedicineModel from the entity if needed
      final medicineModel = medicine as MedicineModel;
      await remoteDataSource.addMedicine(medicineModel);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMedicine(MedicineEntity medicine) async {
    try {
      final medicineModel = medicine as MedicineModel;
      await remoteDataSource.updateMedicine(medicineModel);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MedicineEntity>>> getPharmacyMedicine(String pharmacyId) async {
    try {
      final medicines = await remoteDataSource.getPharmacyMedicine(pharmacyId);
      return Right(medicines.toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MedicineEntity>>> getMedicineByCategory(String category) async {
    try {
      final medicines = await remoteDataSource.getMedicineByCategory(category);
      return Right(medicines.toList());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}