import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entity/patient_entity.dart';
import '../repository/patient_repository.dart';

class GetPatientProfileUseCase implements UseCase<PatientEntity, String> {
  final PatientRepository repository;

  GetPatientProfileUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(String userId) async {
    return await repository.getPatientProfile(userId);
  }
}