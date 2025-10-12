import 'package:equatable/equatable.dart';
import '../../domain/entity/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required String userId,
    required String name, // ← ADD THIS
    required String cnic,
    required String phone,
    required String address,
    double? latitude,
    double? longitude,
    required DateTime createdAt,
  }) : super(
    userId: userId,
    name: name, // ← ADD THIS
    cnic: cnic,
    phone: phone,
    address: address,
    latitude: latitude,
    longitude: longitude,
    createdAt: createdAt,
  );

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '', // ← ADD THIS
      cnic: json['cnic'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name, // ← ADD THIS
      'cnic': cnic,
      'phone': phone,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
    };
  }
}