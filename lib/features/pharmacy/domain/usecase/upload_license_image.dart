import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/pharmacy_repository.dart';

class UploadLicenseImage implements UseCase<String, UploadLicenseImageParams> {
  final PharmacyRepository repository;

  UploadLicenseImage(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadLicenseImageParams params) async {
    return await repository.uploadLicenseImage(
      pharmacyId: params.pharmacyId,
      imagePath: params.imagePath,
    );
  }
}

class UploadLicenseImageParams {
  final String pharmacyId;
  final String imagePath;

  UploadLicenseImageParams({
    required this.pharmacyId,
    required this.imagePath,
  });
}