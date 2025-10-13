import 'package:flutter/material.dart';
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  const MedicineModel({
    required String id,
    required String medicineName,
    required String dosage,
    required String manufacturer,
    required String description,
    required String category,
    required String genericName,
    String? imageUrl,
    required DateTime createdAt,
  }) : super(
    id: id,
    medicineName: medicineName,
    dosage: dosage,
    manufacturer: manufacturer,
    description: description,
    category: category,
    genericName: genericName,
    imageUrl: imageUrl,
    createdAt: createdAt,
  );

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id']?.toString() ?? '',
      medicineName: json['medicine_name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      manufacturer: json['manufacturer']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      genericName: json['generic_name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  static DateTime _parseDateTime(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine_name': medicineName,
      'dosage': dosage,
      'manufacturer': manufacturer,
      'description': description,
      'category': category,
      'generic_name': genericName,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Optional: Add copyWith method for immutability
  MedicineModel copyWith({
    String? id,
    String? medicineName,
    String? dosage,
    String? manufacturer,
    String? description,
    String? category,
    String? genericName,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      manufacturer: manufacturer ?? this.manufacturer,
      description: description ?? this.description,
      category: category ?? this.category,
      genericName: genericName ?? this.genericName,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}