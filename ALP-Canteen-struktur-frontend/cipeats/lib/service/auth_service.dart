import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/user_model.dart';

class AuthService {
  final http.Client client;
  final _storage = const FlutterSecureStorage();

  AuthService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/login');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonBody['success'] == true) {
      final user = UserModel.fromJson(jsonBody['data']['user']);
      final token = jsonBody['data']['token'];
      final isVerifiedSeller = jsonBody['data']['is_verified_seller'];

      // Save token securely
      await _storage.write(key: 'token', value: token);

      return {
        'success': true,
        'user': user,
        'token': token,
        'isVerifiedSeller': isVerifiedSeller,
      };
    } else {
      return {
        'success': false,
        'message': jsonBody['message'] ?? 'Login failed',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/register');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
      }),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 201 && jsonBody['success'] == true) {
      final userJson = jsonBody['data']['user'];
      final token = jsonBody['data']['token'];

      if (userJson == null || userJson is! Map<String, dynamic>) {
        return {
          'success': false,
          'message': 'Invalid user data from server',
        };
      }

      final user = UserModel.fromJson(userJson);
      if (token != null) await _storage.write(key: 'token', value: token);

      return {
        'success': true,
        'user': user,
        'token': token,
        'message': jsonBody['message'] ?? 'Registration successful.',
      };
    } else {
      return {
        'success': false,
        'message': jsonBody['message'] ?? 'Registration failed',
      };
    }
  }
}
