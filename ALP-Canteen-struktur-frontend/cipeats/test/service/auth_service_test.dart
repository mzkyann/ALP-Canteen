import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cipeats/service/auth_service.dart';
import 'package:cipeats/model/user_model.dart';

@GenerateMocks([http.Client])
import 'auth_service_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late AuthService authService;
  const baseUrl = 'http://127.0.0.1:8000/api/v1'; // Match your actual API base URL

  setUp(() {
    mockClient = MockClient();
    authService = AuthService(client: mockClient);
  });

  group('login', () {
    test('should return user data when login is successful', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password';
      final mockResponse = {
        'success': true,
        'data': {
          'user': {'id': 1, 'name': 'Test User', 'email': email},
          'token': 'mock_token',
          'is_verified_seller': true,
        },
      };

      // Match the exact request parameters
      when(mockClient.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"email":"test@example.com","password":"password"}',
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      // Act
      final result = await authService.login(email: email, password: password);

      // Assert
      expect(result['success'], true);
      expect(result['user'], isA<UserModel>());
      expect((result['user'] as UserModel).email, email);
      expect(result['token'], 'mock_token');
      expect(result['isVerifiedSeller'], true);
    });

    test('should return error message when credentials are invalid', () async {
      // Arrange
      final mockErrorResponse = {
        'success': false,
        'message': 'Invalid credentials',
      };

      when(mockClient.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"email":"wrong@example.com","password":"wrong_password"}',
      )).thenAnswer((_) async => http.Response(jsonEncode(mockErrorResponse), 401));

      // Act
      final result = await authService.login(
        email: 'wrong@example.com', 
        password: 'wrong_password'
      );

      // Assert
      expect(result['success'], false);
      expect(result['message'], 'Invalid credentials');
    });

    test('should throw exception when server error occurs', () async {
      // Arrange
      when(mockClient.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: '{"email":"test@example.com","password":"password"}',
      )).thenAnswer((_) async => http.Response('Server Error', 500));

      // Act & Assert
      expect(
        () => authService.login(email: 'test@example.com', password: 'password'),
        throwsA(isA<Exception>()),
      );
    });
  });
}