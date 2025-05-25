import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cipeats/view_model/login_view_model.dart';
import 'package:cipeats/model/user_model.dart';
import 'package:flutter/material.dart';

import '../service/auth_service_wrapper.mocks.dart';

void main() {
  late MockAuthServiceWrapper mockAuthService;
  late LoginViewModelNotifier viewModel;

  setUp(() {
    mockAuthService = MockAuthServiceWrapper();
    viewModel = LoginViewModelNotifier(authService: mockAuthService);
  });

  test('setEmail updates email and clears error', () {
    // Arrange
    const testEmail = 'test@example.com';

    // Act
    viewModel.setEmail(testEmail);

    // Assert
    expect(viewModel.state.email, testEmail);
    expect(viewModel.state.errorMessage, isNull);
  });

  test('login fails if email or password is empty', () async {
    // Arrange
    // (state.email and state.password are empty by default)

    // Act
    await viewModel.login(FakeBuildContext());

    // Assert
    expect(viewModel.state.errorMessage, 'Email and password cannot be empty.');
  });

  test('login success updates state and navigates', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';
    final user = UserModel(fullName: 'John Doe'); // Adjust constructor

    when(mockAuthService.login(email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) async => {
              'success': true,
              'user': user,
              'token': 'abc123',
              'isVerifiedSeller': true,
            });

    viewModel.setEmail(email);
    viewModel.setPassword(password);

    // Act
    await viewModel.login(FakeBuildContext());

    // Assert
    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.errorMessage, "Invalid credentials");
  });

  test('login failure updates errorMessage', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'wrongpassword';

    when(mockAuthService.login(email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) async => {
              'success': false,
              'message': 'Invalid credentials',
            });

    viewModel.setEmail(email);
    viewModel.setPassword(password);

    // Act
    await viewModel.login(FakeBuildContext());

    // Assert
    expect(viewModel.state.errorMessage, 'Invalid credentials');
  });

  test('login exception sets errorMessage', () async {
    // Arrange
    const email = 'test@example.com';
    const password = 'password123';

    when(mockAuthService.login(email: anyNamed('email'), password: anyNamed('password')))
        .thenThrow(Exception('Something went wrong'));

    viewModel.setEmail(email);
    viewModel.setPassword(password);

    // Act
    await viewModel.login(FakeBuildContext());

    // Assert
    expect(viewModel.state.errorMessage, 'Invalid credentials');
  });
}

// Stub for BuildContext used in Navigator (can be replaced with widget tests later)
class FakeBuildContext extends Fake implements BuildContext {}
