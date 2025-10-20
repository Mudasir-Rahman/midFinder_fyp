
import 'package:rx_locator/features/medicine/domain/entities/medicine_entity.dart';

class MedicineModel extends MedicineEntity {
  const MedicineModel({
    String? id,
    required String pharmacyId,
    required String medicineName,
    required String dosage,
    required String manufacturer,
    required String description,
    required String category,
    required String genericName,
    String? imageUrl,
    required DateTime createdAt,
    double? price,
    int? stockQuantity,
    bool? isAvailable,
    bool? requiresPrescription,
  }) : super(
    id: id ?? '',
    pharmacyId: pharmacyId,
    medicineName: medicineName,
    dosage: dosage,
    manufacturer: manufacturer,
    description: description,
    category: category,
    genericName: genericName,
    imageUrl: imageUrl,
    createdAt: createdAt,
    price: price,
    stockQuantity: stockQuantity,
    isAvailable: isAvailable,
    requiresPrescription: requiresPrescription,
  );

  // 🧩 Factory from Supabase JSON
  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id']?.toString(),
      pharmacyId: json['pharmacy_id']?.toString() ?? '',
      medicineName: json['medicine_name']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      manufacturer: json['manufacturer']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      genericName: json['generic_name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      price: (json['price'] as num?)?.toDouble(),
      stockQuantity: json['stock_quantity'] as int?,
      isAvailable: json['is_available'] as bool? ?? true,
      requiresPrescription: json['requires_prescription'] as bool? ?? false,
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  static DateTime _parseDateTime(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // ✅ Safe `toJson` (excludes id if empty)
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'pharmacy_id': pharmacyId,
      'medicine_name': medicineName,
      'dosage': dosage,
      'manufacturer': manufacturer,
      'description': description,
      'category': category,
      'generic_name': genericName,
      'image_url': imageUrl,
      'price': price,
      'stock_quantity': stockQuantity,
      'is_available': isAvailable ?? true,
      'requires_prescription': requiresPrescription ?? false,
      'created_at': createdAt.toIso8601String(),
    };

    if (id.isNotEmpty) {
      data['id'] = id;
    }

    return data;
  }

  // 🔁 Copy method
  MedicineModel copyWith({
    String? id,
    String? pharmacyId,
    String? medicineName,
    String? dosage,
    String? manufacturer,
    String? description,
    String? category,
    String? genericName,
    String? imageUrl,
    DateTime? createdAt,
    double? price,
    int? stockQuantity,
    bool? isAvailable,
    bool? requiresPrescription,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      pharmacyId: pharmacyId ?? this.pharmacyId,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      manufacturer: manufacturer ?? this.manufacturer,
      description: description ?? this.description,
      category: category ?? this.category,
      genericName: genericName ?? this.genericName,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
    );
  }
}
