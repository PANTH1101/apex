import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Automatically detect platform and use appropriate URL
  static String get baseUrl {
    if (kIsWeb) {
      // For Web (Chrome, Edge, etc.)
      return 'http://localhost:8080/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // For Android Emulator: 10.0.2.2 maps to localhost on host
      return 'http://10.0.2.2:8080/api';
    } else {
      // For Windows Desktop, iOS, etc.
      return 'http://localhost:8080/api';
    }
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    
    if (includeAuth) {
      String? token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(includeAuth: requiresAuth),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data, {bool requiresAuth = false}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(includeAuth: requiresAuth),
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to post data');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data, {bool requiresAuth = false}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(includeAuth: requiresAuth),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to update data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
