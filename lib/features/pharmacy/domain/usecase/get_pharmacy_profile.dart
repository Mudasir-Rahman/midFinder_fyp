import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

import '../entity/pharmacy_entity.dart';
import '../repository/pharmacy_repository.dart';

class GetPharmacyProfile implements UseCase<PharmacyEntity, String> {
  final PharmacyRepository repository;

  GetPharmacyProfile(this.repository);

  @override
  Future<Either<Failure, PharmacyEntity>> call(String userId) async {
    return await repository.getPharmacyProfile(userId);
  }
}