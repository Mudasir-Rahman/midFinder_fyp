import 'package:dartz/dartz.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';
import '../../../../core/error/failures.dart';
import '../entities/medicine_entity.dart';

class GetAllMedicines implements UseCase<List<MedicineEntity>, NoParams> {
  final MedicineRepository repository;
  GetAllMedicines(this.repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(NoParams params) async {
    return await repository.getAllMedicines();
  }
}