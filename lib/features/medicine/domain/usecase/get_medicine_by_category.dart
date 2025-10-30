// import 'package:dartz/dartz.dart';
// import 'package:rx_locator/core/usecase/usecase.dart';
// import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';
// import '../../../../core/error/failures.dart';
// import '../entities/medicine_entity.dart';
//
// class GetMedicineByCategory implements UseCase<List<MedicineEntity>, String> {
//   final MedicineRepository repository;
//   GetMedicineByCategory(this.repository);
//
//   @override
//   Future<Either<Failure, List<MedicineEntity>>> call(String category) async {
//     return await repository.getMedicineByCategory(category);
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';
import '../../../../core/error/failures.dart';
import '../entities/medicine_entity.dart';

// ✅ ADD PARAMS CLASS
class GetMedicineByCategoryParams {
  final String category;

  const GetMedicineByCategoryParams({required this.category});
}

class GetMedicineByCategory implements UseCase<List<MedicineEntity>, GetMedicineByCategoryParams> {
  final MedicineRepository repository;

  GetMedicineByCategory(this.repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(GetMedicineByCategoryParams params) async {
    return await repository.getMedicineByCategory(params.category);
  }
}