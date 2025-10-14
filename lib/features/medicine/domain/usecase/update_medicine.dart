import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import '../../../../core/error/failures.dart';
import '../repository/medicine_repository.dart';

class UpdateMedicine implements UseCase<void, UpdateMedicineParams> {
  final MedicineRepository repository;

  UpdateMedicine(this.repository);
@override
  Future<Either<Failure, void>> call(UpdateMedicineParams params)  async {
 return await repository.updateMedicine(params.medicine);
}

}
class UpdateMedicineParams extends Equatable {
  final MedicineEntity medicine;

  const UpdateMedicineParams({required this.medicine});
  @override
  List<Object?> get props => [medicine];

}