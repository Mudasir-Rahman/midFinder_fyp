import 'package:dartz/dartz.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entity/patient_entity.dart';
import '../../../domain/repository/patient_repository.dart';
import '../../data_source/patient_remote_data_source.dart';
import '../../patient_model/patient_model.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  PatientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PatientEntity>> registerPatient(
      PatientEntity patient,
      ) async {
    try {
      final patientModel = PatientModel(
        userId: patient.userId,
        name: patient.name, // ← ADD THIS
        cnic: patient.cnic,
        phone: patient.phone,
        address: patient.address,
        latitude: patient.latitude,
        longitude: patient.longitude,
        createdAt: patient.createdAt,
      );

      final result = await remoteDataSource.registerPatient(patientModel);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to register patient: $e'));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> updatePatientLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final result = await remoteDataSource.updatePatientLocation(
        userId: userId,
        latitude: latitude,
        longitude: longitude,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to update patient location: $e'));
    }
  }

  @override
  Future<Either<Failure, PatientEntity>> getPatientProfile(String userId) async {
    try {
      final result = await remoteDataSource.getPatientProfile(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to get patient profile: $e'));
    }
  }
}