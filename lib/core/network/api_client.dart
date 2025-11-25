import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../utils/shared_prefs.dart';
import 'api_response.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await SharedPrefs.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        print('🔑 Token added to request: Bearer ${token.substring(0, 20)}...');
      } else {
        print('⚠️ Warning: Auth required but no token found');
      }
    }

    return headers;
  }

  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    bool requiresAuth = false,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      print('📤 GET Request: ${ApiConstants.baseUrl}$endpoint');
      
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(requiresAuth: requiresAuth),
      );

      print('📥 Response Status: ${response.statusCode}');
      
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('❌ GET Error: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      print('📤 POST Request: ${ApiConstants.baseUrl}$endpoint');
      print('📦 Body: $body');
      
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(requiresAuth: requiresAuth),
        body: jsonEncode(body),
      );

      print('📥 Response Status: ${response.statusCode}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('❌ POST Error: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<T>> postFormUrlEncoded<T>(
    String endpoint, {
    required Map<String, String> body,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      print('📤 POST Form Request: ${ApiConstants.baseUrl}$endpoint');
      
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: body,
      );

      print('📥 Response Status: ${response.statusCode}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('❌ POST Form Error: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      print('📤 PUT Request: ${ApiConstants.baseUrl}$endpoint');
      print('📦 Body: $body');
      
      final response = await _client.put(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(requiresAuth: requiresAuth),
        body: jsonEncode(body),
      );

      print('📥 Response Status: ${response.statusCode}');

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      print('❌ PUT Error: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse<bool>> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      print('📤 DELETE Request: ${ApiConstants.baseUrl}$endpoint');
      
      final response = await _client.delete(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(requiresAuth: requiresAuth),
      );

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(true);
      } else {
        return ApiResponse.error(
          'Failed to delete: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ DELETE Error: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJson,
  ) {
    print('📄 Full Response Body: ${response.body}');
    print('📄 Response Body Length: ${response.body.length}');
    print('📑 Response Headers: ${response.headers}');
    
    // Handle 401 Unauthorized - Token expired or invalid
    if (response.statusCode == 401) {
      print('🚫 Unauthorized: Token may be expired or invalid');

      // Try to surface server detail message if present
      String detail = 'Session expired. Please login again.';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('detail')) {
          detail = body['detail'].toString();
        }
      } catch (_) {}

      // Clear stored token proactively so subsequent requests don't reuse invalid token
      try {
        SharedPrefs.clearToken();
        print('🔓 Cleared stored auth token due to 401 response');
      } catch (_) {}

      return ApiResponse.error(
        detail,
        statusCode: 401,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        print('✅ Parsing JSON response...');
        if (fromJson != null) {
          final data = jsonDecode(response.body);
          print('✅ JSON decoded, calling fromJson...');
          return ApiResponse.success(fromJson(data));
        }
        final decoded = jsonDecode(response.body) as T;
        print('✅ JSON decoded successfully');
        return ApiResponse.success(decoded);
      } catch (e, stackTrace) {
        print('❌ JSON Parse Error: $e');
        print('❌ StackTrace: $stackTrace');
        return ApiResponse.error('Failed to parse response: $e');
      }
    } else {
      String errorMessage = 'Request failed with status: ${response.statusCode}';
      try {
        final errorBody = jsonDecode(response.body);
        if (errorBody is Map && errorBody.containsKey('detail')) {
          errorMessage = errorBody['detail'].toString();
        }
      } catch (_) {}
      // If body is not JSON (e.g., plain text 'Internal Server Error'), surface it for easier debugging
      try {
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json') && response.body.isNotEmpty) {
          errorMessage = response.body;
        }
      } catch (_) {}
      
      return ApiResponse.error(
        errorMessage,
        statusCode: response.statusCode,
      );
    }
  }
}