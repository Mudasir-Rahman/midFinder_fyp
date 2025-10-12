// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../../../core/error/failures.dart';
// import '../../../../core/usecase/usecase.dart';
// import '../repository/auth_repository.dart';
//
// class GetUserRole implements UseCase<String, GetUserRoleParams> {
//   final AuthRepository repository;
//
//   GetUserRole(this.repository);
//
//   @override
//   Future<Either<Failure, String>> call(GetUserRoleParams params) async {
//     return await repository.getUserRole(params.userId);
//   }
// }
//
// class GetUserRoleParams extends Equatable {
//   final String userId;
//
//   const GetUserRoleParams({required this.userId});
//
//   @override
//   List<Object> get props => [userId];
// }