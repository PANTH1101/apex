import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Register new user
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'phone': phone,
        },
      );

      AuthResponse authResponse = AuthResponse.fromJson(response);
      await _saveToken(authResponse.token);
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );

      AuthResponse authResponse = AuthResponse.fromJson(response);
      await _saveToken(authResponse.token);
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  // Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.get(
        '/users/me',
        requiresAuth: true,
      );
      return User.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<User> updateProfile({
    String? name,
    String? phone,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;

      final response = await _apiClient.put(
        '/users/me',
        data,
        requiresAuth: true,
      );
      return User.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Save JWT token
  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Get JWT token
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Clear JWT token (logout)
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }
}
