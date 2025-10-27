// import 'package:equatable/equatable.dart';
//
// import '../../domain/entity/pharmacy_entity.dart';
//
// class PharmacyModel extends PharmacyEntity {
//   const PharmacyModel({
//     required String id,
//     required String userId,
//     required String pharmacyName,
//     required String licenseNumber,
//     required String address,
//     required String phone,
//     required double latitude,
//     required double longitude,
//     required List<String> operatingDays,
//     required String openingTime,
//     required String closingTime,
//     bool isVerified = false,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     String? licenseImageUrl,
//   }) : super(
//     id: id,
//     userId: userId,
//     pharmacyName: pharmacyName,
//     licenseNumber: licenseNumber,
//     address: address,
//     phone: phone,
//     latitude: latitude,
//     longitude: longitude,
//     operatingDays: operatingDays,
//     openingTime: openingTime,
//     closingTime: closingTime,
//     isVerified: isVerified,
//     createdAt: createdAt,
//     updatedAt: updatedAt,
//     licenseImageUrl: licenseImageUrl,
//   );
//
//   factory PharmacyModel.fromJson(Map<String, dynamic> json) {
//     return PharmacyModel(
//       id: json['id']?.toString() ?? '',
//       userId: json['user_id']?.toString() ?? '',
//       pharmacyName: json['pharmacy_name']?.toString() ?? '',
//       licenseNumber: json['license_number']?.toString() ?? '',
//       address: json['address']?.toString() ?? '',
//       phone: json['phone']?.toString() ?? '',
//       latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
//       longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
//       operatingDays: List<String>.from(json['operating_days'] ?? []),
//       openingTime: json['opening_time']?.toString() ?? '09:00',
//       closingTime: json['closing_time']?.toString() ?? '18:00',
//       isVerified: json['is_verified'] ?? false,
//       licenseImageUrl: json['license_image_url']?.toString(),
//       createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
//       updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'pharmacy_name': pharmacyName,
//       'license_number': licenseNumber,
//       'address': address,
//       'phone': phone,
//       'latitude': latitude,
//       'longitude': longitude,
//       'operating_days': operatingDays,
//       'opening_time': openingTime,
//       'closing_time': closingTime,
//       'is_verified': isVerified,
//       'license_image_url': licenseImageUrl,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//     };
//   }
//
//   PharmacyModel copyWith({
//     String? id,
//     String? userId,
//     String? pharmacyName,
//     String? licenseNumber,
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
//     String? licenseImageUrl,
//   }) {
//     return PharmacyModel(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       pharmacyName: pharmacyName ?? this.pharmacyName,
//       licenseNumber: licenseNumber ?? this.licenseNumber,
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
//       licenseImageUrl: licenseImageUrl ?? this.licenseImageUrl,
//     );
//   }
// }
import 'package:equatable/equatable.dart';
import '../../domain/entity/pharmacy_entity.dart';

class PharmacyModel extends PharmacyEntity {
  const PharmacyModel({
    required String id,
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
    bool isVerified = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? licenseImageUrl,
    double? distanceFromPatient, // ✅ Added for UI
  }) : super(
    id: id,
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
    isVerified: isVerified,
    createdAt: createdAt,
    updatedAt: updatedAt,
    licenseImageUrl: licenseImageUrl,
    distanceFromPatient: distanceFromPatient, // ✅ Added
  );

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      pharmacyName: json['pharmacy_name']?.toString() ?? '',
      licenseNumber: json['license_number']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      operatingDays: List<String>.from(json['operating_days'] ?? []),
      openingTime: json['opening_time']?.toString() ?? '09:00',
      closingTime: json['closing_time']?.toString() ?? '18:00',
      isVerified: json['is_verified'] ?? false,
      licenseImageUrl: json['license_image_url']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      distanceFromPatient: json['distance_from_patient']?.toDouble(), // ✅ Optional local use
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'pharmacy_name': pharmacyName,
      'license_number': licenseNumber,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'operating_days': operatingDays,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'is_verified': isVerified,
      'license_image_url': licenseImageUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      // ⚠️ Do not include distanceFromPatient in DB writes
    };
  }

  PharmacyModel copyWith({
    String? id,
    String? userId,
    String? pharmacyName,
    String? licenseNumber,
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
    String? licenseImageUrl,
    double? distanceFromPatient, // ✅ Added
  }) {
    return PharmacyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pharmacyName: pharmacyName ?? this.pharmacyName,
      licenseNumber: licenseNumber ?? this.licenseNumber,
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
      licenseImageUrl: licenseImageUrl ?? this.licenseImageUrl,
      distanceFromPatient: distanceFromPatient ?? this.distanceFromPatient, // ✅ Added
    );
  }
}
