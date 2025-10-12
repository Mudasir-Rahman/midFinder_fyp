import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entities.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    String? password,
    required String? role,
    DateTime? createdAt,
  }) : super(
    id: id,
    email: email,
    password: password,
    role: role,
    createdAt: createdAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString(),
      role: json['role']?.toString(),
      createdAt: _parseDateTime(json['created_at']), // ← FIX THIS
    );
  }

  // Add this helper method to safely parse DateTime
  static DateTime? _parseDateTime(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}