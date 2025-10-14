
import 'package:dartz/dartz.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';
import '../../../../core/error/failures.dart';

class GetMedicinePharmacy implements UseCase<List<MedicineEntity>, String> {
  final MedicineRepository repository;
  GetMedicinePharmacy(this.repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(String pharmacyId) async {
    return await repository.getPharmacyMedicine(pharmacyId);
  }
}