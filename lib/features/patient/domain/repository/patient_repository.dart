import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entity/patient_entity.dart';


abstract class PatientRepository {
  Future<Either<Failure, PatientEntity>> registerPatient(
      PatientEntity patient,
      );

  Future<Either<Failure, PatientEntity>> updatePatientLocation({
    required String userId,
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, PatientEntity>> getPatientProfile(String userId);
}