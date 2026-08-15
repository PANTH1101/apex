import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
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

  /// Base URL for static resources (images).
  /// Strips the /api suffix from baseUrl.
  static String get staticBaseUrl {
    return baseUrl.replaceAll('/api', '');
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

  Future<void> delete(String endpoint, {bool requiresAuth = false}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(includeAuth: requiresAuth),
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else if (response.statusCode == 404) {
        throw Exception('Not found');
      } else {
        String message = 'Failed to delete';
        try {
          final errorBody = json.decode(response.body);
          message = errorBody['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getList(String endpoint, {bool requiresAuth = false}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(includeAuth: requiresAuth),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
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

  /// Multipart POST — used for image uploads.
  /// [fileField] is the form field name (e.g. "image").
  /// [filePath]  is the local filesystem path of the file to upload.
  /// [mimeType]  e.g. "image/jpeg".
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required String fileField,
    required String filePath,
    required String mimeType,
  }) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$endpoint'),
      );
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.files.add(
        await http.MultipartFile.fromPath(
          fileField,
          filePath,
          contentType: _parseMime(mimeType),
        ),
      );

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        return json.decode(body) as Map<String, dynamic>;
      } else if (streamed.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (streamed.statusCode == 403) {
        throw Exception('Forbidden');
      } else if (streamed.statusCode == 404) {
        throw Exception('Not found');
      } else {
        String message = 'Upload failed';
        try {
          final err = json.decode(body);
          message = err['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE that returns a JSON body (used for image removal which returns
  /// the updated EventResponse).
  Future<Map<String, dynamic>> deleteReturningBody(
      String endpoint, {bool requiresAuth = false}) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(includeAuth: requiresAuth),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 204) {
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else if (response.statusCode == 404) {
        throw Exception('Not found');
      } else {
        String message = 'Failed to delete';
        try {
          final err = json.decode(response.body);
          message = err['message'] ?? message;
        } catch (_) {}
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  http.MediaType _parseMime(String mime) {
    final parts = mime.split('/');
    return http.MediaType(parts[0], parts.length > 1 ? parts[1] : '*');
  }
}
