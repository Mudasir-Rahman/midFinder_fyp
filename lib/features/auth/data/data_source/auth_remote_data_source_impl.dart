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
      print('=== SIGNUP STARTED ===');
      print('Email: $email');
      print('Role: $role');

      // Step 1: Create auth user (email + password only)
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw ServerException('User creation failed in Auth');

      print('=== AUTH USER CREATED ===');
      print('User ID: ${user.id}');

      // Step 2: MANUALLY create profile in profiles table
      try {
        // Use insert without checking error (modern Supabase returns void for inserts)
        await supabaseClient
            .from('profiles')
            .insert({
          'id': user.id, // Same ID as auth user
          'email': email,
          'role': role.toLowerCase(), // Ensure lowercase
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });

        print('=== PROFILE CREATED SUCCESSFULLY ===');
        print('Profile for user: ${user.id}');

      } catch (e) {
        print('=== PROFILE ERROR ===');
        print('Error: $e');

        // If profile creation fails, check if it's a duplicate error
        if (e.toString().contains('duplicate key') || e.toString().contains('already exists')) {
          print('Profile already exists, continuing...');
          // Profile might have been created by trigger, continue
        } else {
          throw ServerException('Failed to create user profile: $e');
        }
      }

      // Step 3: Return user model
      return UserModel(
        id: user.id,
        email: email,
        password: password,
        role: role,
        createdAt: DateTime.now(),
      );

    } on AuthException catch (e) {
      print('=== AUTH EXCEPTION ===');
      print('Error: ${e.message}');
      throw ServerException('Auth failed: ${e.message}');
    } catch (e) {
      print('=== SIGNUP GENERAL EXCEPTION ===');
      print('Error: $e');
      throw ServerException('Sign up failed: $e');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Login user
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw ServerException('Login failed: No user returned');

      // Fetch profile info
      final data = await supabaseClient
          .from('profiles')
          .select('id, email, role, created_at')
          .eq('id', user.id)
          .single();

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