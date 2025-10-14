import 'package:dartz/dartz.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';
import '../../../../core/error/failures.dart';
import '../entities/medicine_entity.dart';

class GetMedicineDetail implements UseCase<MedicineEntity, String> {
  final MedicineRepository repository;
  GetMedicineDetail(this.repository);

  @override
  Future<Either<Failure, MedicineEntity>> call(String medicineId) async {
    return await repository.getMedicineDetail(medicineId);
  }
}