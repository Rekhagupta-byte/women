import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:women/core/error/exceptions.dart';
import 'package:women/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  // ✅ Add a constructor to initialize SupabaseClient
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const ServerException('User not found');
      }

      // ✅ Convert Supabase User to UserModel
      return UserModel(
        id: response.user!.id,
        name: response.user!.userMetadata?['name'] ??
            'Unknown', // Handle missing name
        email: response.user!.email!,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        // ✅ Use supabaseClient.auth
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw ServerException("Signup failed");
      }

      return UserModel(
        id: response.user!.id,
        name: name,
        email: response.user!.email!,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
