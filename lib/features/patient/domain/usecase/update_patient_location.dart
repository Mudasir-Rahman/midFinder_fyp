import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entity/patient_entity.dart';
import '../repository/patient_repository.dart';

class UpdatePatientLocationUseCase implements UseCase<PatientEntity, UpdatePatientLocationParams> {
  final PatientRepository repository;

  UpdatePatientLocationUseCase(this.repository);

  @override
  Future<Either<Failure, PatientEntity>> call(UpdatePatientLocationParams params) async {
    return await repository.updatePatientLocation(
      userId: params.userId,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class UpdatePatientLocationParams {
  final String userId;
  final double latitude;
  final double longitude;

  UpdatePatientLocationParams({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });
}