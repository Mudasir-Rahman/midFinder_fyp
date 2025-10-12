import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entity/patient_entity.dart';
import '../repository/patient_repository.dart';

class RegisterPatientUseCase implements UseCase<PatientEntity, PatientEntity> {
  final PatientRepository repository;

  RegisterPatientUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(PatientEntity params) async {
    return await repository.registerPatient(params);
  }
}