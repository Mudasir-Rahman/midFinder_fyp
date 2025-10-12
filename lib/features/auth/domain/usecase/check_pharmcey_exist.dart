// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../../../core/usecase/usecase.dart';
// import '../repository/auth_repository.dart';
//
// class CheckPharmacyExists implements UseCase<bool, CheckPharmacyExistsParams> {
//   final AuthRepository repository;
//
//   CheckPharmacyExists(this.repository);
//
//   @override
//   Future<Either<Failure, bool>> call(CheckPharmacyExistsParams params) async {
//     return await repository.checkPharmacyExists(params.userId);
//   }
// }
//
// class CheckPharmacyExistsParams extends Equatable {
//   final String userId;
//
//   const CheckPharmacyExistsParams({required this.userId});
//
//   @override
//   List<Object> get props => [userId];
// }