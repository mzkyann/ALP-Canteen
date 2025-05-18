import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class AuthService {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonBody['success'] == true) {
      // Extract user from jsonBody['data']['user']
      final user = UserModel.fromJson(jsonBody['data']['user']);
      final token = jsonBody['data']['token'];
      final isVerifiedSeller = jsonBody['data']['is_verified_seller'];

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
}
