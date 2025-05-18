import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/login_model.dart';
import '../service/login_service.dart';
import '../model/user_model.dart';

class LoginViewModelNotifier extends StateNotifier<LoginViewModel> {
  LoginViewModelNotifier() : super(LoginViewModel());

  void setEmail(String email) {
    state = state.copyWith(email: email, errorMessage: null);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, errorMessage: null);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<void> login(BuildContext context) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: "Email and password cannot be empty.");
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await AuthService.login(
        email: state.email,
        password: state.password,
      );

      if (result['success']) {
        final UserModel user = result['user'];
        final String token = result['token'];
        final bool isVerifiedSeller = result['isVerifiedSeller'];

        // Optionally save the user/token if needed
        print('User: ${user.fullName}, Token: $token, Verified: $isVerifiedSeller');

        state = state.copyWith(isLoading: false);
        Navigator.pushReplacementNamed(context, '/');
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred. Please try again.',
      );
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModelNotifier, LoginViewModel>(
        (ref) => LoginViewModelNotifier());
