// import 'package:equatable/equatable.dart';
//
// class PatientEntity extends Equatable {
//   final String userId;
//   final String cnic;
//   final String phone;
//   final String address;
//   final double? latitude;
//   final double? longitude;
//   final DateTime createdAt;
//
//   const PatientEntity({
//     required this.userId,
//     required this.cnic,
//     required this.phone,
//     required this.address,
//     this.latitude,
//     this.longitude,
//     required this.createdAt,
//   });
//
//   @override
//   List<Object?> get props => [
//     userId,
//     cnic,
//     phone,
//     address,
//     latitude,
//     longitude,
//     createdAt,
//   ];
// }
import 'package:equatable/equatable.dart';

class PatientEntity extends Equatable {
  final String userId;
  final String name;
  final String cnic;
  final String phone;
  final String address;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  const PatientEntity({
    required this.userId,
    required this.name,
    required this.cnic,
    required this.phone,
    required this.address,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    userId,
    name,
    cnic,
    phone,
    address,
    latitude,
    longitude,
    createdAt,
  ];
}
