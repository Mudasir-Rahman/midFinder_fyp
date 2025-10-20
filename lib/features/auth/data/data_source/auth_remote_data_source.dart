
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({required String email, required String password,required String role});
  Future<UserModel> login({required String email, required String password});
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> verifyUserAuth(String userId);
}