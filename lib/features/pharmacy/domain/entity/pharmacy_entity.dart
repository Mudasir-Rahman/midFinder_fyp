// import 'package:equatable/equatable.dart';
//
// class PharmacyEntity extends Equatable {
//   final String id;
//   final String userId;
//   final String pharmacyName;
//   final String licenseNumber;
//   final String? licenseImageUrl;
//   final String address;
//   final String phone;
//   final double latitude;
//   final double longitude;
//   final List<String> operatingDays;
//   final String openingTime;
//   final String closingTime;
//   final bool isVerified;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   const PharmacyEntity({
//     required this.id,
//     required this.userId,
//     required this.pharmacyName,
//     required this.licenseNumber,
//     this.licenseImageUrl,
//     required this.address,
//     required this.phone,
//     required this.latitude,
//     required this.longitude,
//     required this.operatingDays,
//     required this.openingTime,
//     required this.closingTime,
//     this.isVerified = false,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   @override
//   List<Object?> get props => [
//     id,
//     userId,
//     pharmacyName,
//     licenseNumber,
//     licenseImageUrl,
//     address,
//     phone,
//     latitude,
//     longitude,
//     operatingDays,
//     openingTime,
//     closingTime,
//     isVerified,
//     createdAt,
//     updatedAt,
//   ];
//
//   PharmacyEntity copyWith({
//     String? id,
//     String? userId,
//     String? pharmacyName,
//     String? licenseNumber,
//     String? licenseImageUrl,
//     String? address,
//     String? phone,
//     double? latitude,
//     double? longitude,
//     List<String>? operatingDays,
//     String? openingTime,
//     String? closingTime,
//     bool? isVerified,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return PharmacyEntity(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       pharmacyName: pharmacyName ?? this.pharmacyName,
//       licenseNumber: licenseNumber ?? this.licenseNumber,
//       licenseImageUrl: licenseImageUrl ?? this.licenseImageUrl,
//       address: address ?? this.address,
//       phone: phone ?? this.phone,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       operatingDays: operatingDays ?? this.operatingDays,
//       openingTime: openingTime ?? this.openingTime,
//       closingTime: closingTime ?? this.closingTime,
//       isVerified: isVerified ?? this.isVerified,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }
import 'package:equatable/equatable.dart';

class PharmacyEntity extends Equatable {
  final String id;
  final String userId;
  final String pharmacyName;
  final String licenseNumber;
  final String? licenseImageUrl;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final List<String> operatingDays;
  final String openingTime;
  final String closingTime;
  final bool isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // ✅ Added this for displaying distance dynamically
  final double? distanceFromPatient;

  const PharmacyEntity({
    required this.id,
    required this.userId,
    required this.pharmacyName,
    required this.licenseNumber,
    this.licenseImageUrl,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.operatingDays,
    required this.openingTime,
    required this.closingTime,
    this.isVerified = false,
    this.createdAt,
    this.updatedAt,
    this.distanceFromPatient, // ✅ optional
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    pharmacyName,
    licenseNumber,
    licenseImageUrl,
    address,
    phone,
    latitude,
    longitude,
    operatingDays,
    openingTime,
    closingTime,
    isVerified,
    createdAt,
    updatedAt,
    distanceFromPatient, // ✅ include in comparison
  ];

  PharmacyEntity copyWith({
    String? id,
    String? userId,
    String? pharmacyName,
    String? licenseNumber,
    String? licenseImageUrl,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    List<String>? operatingDays,
    String? openingTime,
    String? closingTime,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distanceFromPatient, // ✅ added for copy
  }) {
    return PharmacyEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseImageUrl: licenseImageUrl ?? this.licenseImageUrl,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      operatingDays: operatingDays ?? this.operatingDays,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      distanceFromPatient: distanceFromPatient ?? this.distanceFromPatient, // ✅ added
    );
  }
}
