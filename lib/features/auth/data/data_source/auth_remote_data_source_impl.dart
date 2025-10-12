// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../../../core/error/exception.dart';
// import '../models/user_model.dart';
// import 'auth_remote_data_source.dart';
//
// class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
//   final SupabaseClient supabaseClient;
//
//   AuthRemoteDataSourceImpl({required this.supabaseClient});
//
//   @override
//   Future<UserModel> signUp({
//     required String email,
//     required String password,
//     required String role,
//   }) async {
//     try {
//       final response = await supabaseClient.auth.signUp(
//         email: email,
//         password: password,
//       );
//
//       final user = response.user;
//       if (user == null) throw ServerException('Sign up failed');
//
//       await supabaseClient.from('profiles').insert({
//         'id': user.id,
//         'email': email,
//         'role': role,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//
//       return UserModel(
//         id: user.id,
//         email: email,
//         password: password,
//         role: role,
//         createdAt: DateTime.now(),
//       );
//     } on AuthException catch (e) {
//       throw ServerException(e.message);
//     } catch (e) {
//       throw ServerException('Sign up failed: $e');
//     }
//   }
//
//   @override
//   Future<UserModel> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await supabaseClient.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//
//       final user = response.user;
//       if (user == null) throw ServerException('Login failed');
//
//       final data = await supabaseClient
//           .from('profiles')
//           .select('id, email, role, created_at')
//           .eq('id', user.id)
//           .single();
//
//       return UserModel(
//         id: user.id,
//         email: email,
//         password: password,
//         role: data['role'],
//         createdAt: data['created_at'] as DateTime?, // ✅ FIXED - Simple cast
//       );
//     } on AuthException catch (e) {
//       throw ServerException(e.message);
//     } catch (e) {
//       throw ServerException('Login failed: $e');
//     }
//   }
//
//   @override
//   Future<void> logout() async {
//     try {
//       await supabaseClient.auth.signOut();
//     } catch (e) {
//       throw ServerException('Logout failed: $e');
//     }
//   }
//
//   @override
//   Future<UserModel?> getCurrentUser() async {
//     try {
//       final user = supabaseClient.auth.currentUser;
//       if (user == null) return null;
//
//       final data = await supabaseClient
//           .from('profiles')
//           .select('id, email, role, created_at')
//           .eq('id', user.id)
//           .maybeSingle();
//
//       if (data == null) return null;
//
//       return UserModel(
//         id: user.id,
//         email: user.email ?? data['email'],
//         password: null,
//         role: data['role'],
//         createdAt: data['created_at'] as DateTime?, // ✅ FIXED - Simple cast
//       );
//     } catch (e) {
//       throw ServerException('Get current user failed: $e');
//     }
//   }
// }
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exception.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // 🔹 Create auth user with role in metadata
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'role': role}, // 👈 role passed to metadata (used by SQL trigger)
      );

      final user = response.user;
      if (user == null) throw ServerException('User creation failed');

      // ❌ Do NOT manually insert into "profiles" — SQL trigger does it automatically

      return UserModel(
        id: user.id,
        email: email,
        password: password,
        role: role,
        createdAt: DateTime.now(),
      );
    } on AuthException catch (e) {
      throw ServerException('Auth failed: ${e.message}');
    } catch (e) {
      throw ServerException('Sign up failed: $e');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // 🔹 Login user
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw ServerException('Login failed: No user returned');

      // 🔹 Fetch profile info
      final data = await supabaseClient
          .from('profiles')
          .select('id, email, role, created_at')
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) throw ServerException('Profile not found in database');

      final createdAt = DateTime.tryParse(data['created_at']?.toString() ?? '');

      return UserModel(
        id: user.id,
        email: data['email'] ?? email,
        password: password,
        role: data['role'],
        createdAt: createdAt,
      );
    } on AuthException catch (e) {
      throw ServerException('Auth failed: ${e.message}');
    } catch (e) {
      throw ServerException('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException('Logout failed: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user == null) return null;

      final data = await supabaseClient
          .from('profiles')
          .select('id, email, role, created_at')
          .eq('id', user.id)
          .maybeSingle();

      if (data == null) return null;

      final createdAt = DateTime.tryParse(data['created_at']?.toString() ?? '');

      return UserModel(
        id: user.id,
        email: user.email ?? data['email'],
        password: null,
        role: data['role'],
        createdAt: createdAt,
      );
    } catch (e) {
      throw ServerException('Get current user failed: $e');
    }
  }
}
