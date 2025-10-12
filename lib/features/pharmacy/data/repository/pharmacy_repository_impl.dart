import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

import '../../domain/entity/pharmacy_entity.dart';
import '../../domain/repository/pharmacy_repository.dart';
import '../data_source/pharmacy_remote_data_source.dart';


class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyRemoteDataSource remoteDataSource;

  PharmacyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PharmacyEntity>> registerPharmacy({
    required String userId,
    required String pharmacyName,
    required String licenseNumber,
    required String address,
    required String phone,
    required double latitude,
    required double longitude,
    required List<String> operatingDays,
    required String openingTime,
    required String closingTime,
    String? licenseImageUrl,
  }) async {
    try {
      final result = await remoteDataSource.registerPharmacy(
        userId: userId,
        pharmacyName: pharmacyName,
        licenseNumber: licenseNumber,
        address: address,
        phone: phone,
        latitude: latitude,
        longitude: longitude,
        operatingDays: operatingDays,
        openingTime: openingTime,
        closingTime: closingTime,
        licenseImageUrl: licenseImageUrl,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to register pharmacy: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PharmacyEntity>> getPharmacyProfile(String userId) async {
    try {
      final result = await remoteDataSource.getPharmacyProfile(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to get pharmacy profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PharmacyEntity>> updatePharmacyProfile({
    required String pharmacyId,
    String? pharmacyName,
    String? address,
    String? phone,
    List<String>? operatingDays,
    String? openingTime,
    String? closingTime,
  }) async {
    try {
      final result = await remoteDataSource.updatePharmacyProfile(
        pharmacyId: pharmacyId,
        pharmacyName: pharmacyName,
        address: address,
        phone: phone,
        operatingDays: operatingDays,
        openingTime: openingTime,
        closingTime: closingTime,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to update pharmacy profile: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLicenseImage({
    required String pharmacyId,
    required String imagePath,
  }) async {
    try {
      final result = await remoteDataSource.uploadLicenseImage(
        pharmacyId: pharmacyId,
        imagePath: imagePath,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to upload license image: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<PharmacyEntity>>> getNearbyPharmacies({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    try {
      final result = await remoteDataSource.getNearbyPharmacies(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radiusInKm,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Failed to get nearby pharmacies: ${e.toString()}'));
    }
  }
}