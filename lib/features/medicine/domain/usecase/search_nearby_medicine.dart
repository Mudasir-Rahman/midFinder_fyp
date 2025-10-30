import 'package:dartz/dartz.dart';
import 'package:rx_locator/core/error/failures.dart';
import 'package:rx_locator/core/usecase/usecase.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';
import 'package:rx_locator/features/medicine/domain/repository/medicine_repository.dart';

class SearchNearbyMedicineParams {
  final String query;
  final double latitude;
  final double longitude;

  const SearchNearbyMedicineParams({
    required this.query,
    required this.latitude,
    required this.longitude,
  });
}

class SearchNearbyMedicine implements UseCase<List<MedicineEntity>, SearchNearbyMedicineParams> {
  final MedicineRepository repository;

  SearchNearbyMedicine(this.repository);

  @override
  Future<Either<Failure, List<MedicineEntity>>> call(SearchNearbyMedicineParams params) async {
    return await repository.searchNearbyMedicine(
      params.query,
      params.latitude,
      params.longitude,
    );
  }
}