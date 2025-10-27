import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/pharmacy_entity.dart';
import '../repository/pharmacy_repository.dart';

class SearchNearbyPharmacies implements UseCase<List<PharmacyEntity>, SearchNearbyPharmaciesParams> {
  final PharmacyRepository repository;

  SearchNearbyPharmacies(this.repository);

  @override
  Future<Either<Failure, List<PharmacyEntity>>> call(SearchNearbyPharmaciesParams params) async {
    return await repository.getNearbyPharmacies(
      latitude: params.latitude,
      longitude: params.longitude,
      radiusInKm: params.radiusInKm,
    );
  }
}

class SearchNearbyPharmaciesParams {
  final double latitude;
  final double longitude;
  final double radiusInKm;

  SearchNearbyPharmaciesParams({
    required this.latitude,
    required this.longitude,
    required this.radiusInKm,
  });
}