import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/medicine_repository.dart';

class SearchMedicine implements UseCase<List<MedicineEntity>,SearchMedicineParams>{
  final MedicineRepository repository;
  SearchMedicine(this.repository);

@override
Future<Either<Failure, List<MedicineEntity>>> call(SearchMedicineParams params) async {
return await repository.searchMedicine(params.query);
}

}
class SearchMedicineParams extends Equatable {
  final String query;

  const SearchMedicineParams({required this.query});

  @override
  List<Object?> get props => [query];
}