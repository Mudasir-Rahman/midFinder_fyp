import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? password;
  final String? role;
  final DateTime? createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.password,
    this.role,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, password, role, createdAt]; // Include password

  // Optional: Create a copyWith method for convenience
  UserEntity copyWith({
    String? id,
    String? email,
    String? password,
    String? role,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}