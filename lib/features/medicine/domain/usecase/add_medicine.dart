import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';

import '../../../../core/error/failures.dart';

class AddMedicine implements UseCase<void , AddMedicineParams>{
  final MedicineRepository repository;
  AddMedicine(this.repository);
  @override
  Future<Either<Failure,void>>call (AddMedicineParams params)async{
    return await repository.addMedicine(params.medicine);

  }
}
class  AddMedicineParams extends Equatable{
final MedicineEntity medicine;
AddMedicineParams({required this.medicine});

@override
List<Object?> get props => [medicine];
}