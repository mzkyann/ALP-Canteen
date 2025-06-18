import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const String _baseUrl = 'http://127.0.0.1:8000/api/v1';
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// 🔐 Get token from secure storage
  static Future<String?> _getToken() async {
    final token = await _secureStorage.read(key: 'token');
    developer.log('🔑 Token loaded: ${token ?? "<empty>"}', name: 'UserService');
    return token;
  }

  /// 👤 Get current authenticated user
  static Future<Map<String, dynamic>> getUser() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('[401] No token found in secure storage');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/user'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    developer.log('📡 GET /user -> ${response.statusCode}', name: 'UserService');
    developer.log('📦 Response body: ${response.body}', name: 'UserService');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] is Map<String, dynamic>) {
        return json['data'];
      } else {
        throw Exception('[500] Invalid user data format');
      }
    } else {
      throw Exception('[${response.statusCode}] Failed to fetch user: ${response.body}');
    }
  }

  /// 🚪 Logout user and clear secure token
  static Future<void> logout({Function()? onLogout}) async {
    final token = await _getToken();
    if (token == null) {
      developer.log('ℹ️ No token found during logout. Skipping API call.', name: 'UserService');
      return;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    developer.log('📡 POST /logout -> ${response.statusCode}', name: 'UserService');

    if (response.statusCode == 200) {
      await _secureStorage.delete(key: 'token');
      developer.log('🧹 Token cleared from secure storage', name: 'UserService');
      onLogout?.call();
    } else {
      throw Exception('[${response.statusCode}] Failed to logout: ${response.body}');
    }
  }
}
