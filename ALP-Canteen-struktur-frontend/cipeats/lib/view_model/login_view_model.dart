import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/login_model.dart';
import '../service/auth_service_wrapper.dart';
import '../provider/secure_storage_provider.dart';

class LoginViewModelNotifier extends StateNotifier<LoginViewModel> {
  final AuthServiceWrapper authService;
  final Ref ref;

  LoginViewModelNotifier({
    required this.authService,
    required this.ref,
  }) : super(LoginViewModel());

  void setEmail(String email) {
    String? error;
    if (!email.contains('@')) {
      error = 'Email harus mengandung @';
    }

    state = state.copyWith(email: email, emailError: error, errorMessage: null);
  }

  void setPassword(String password) {
    String? error;
    if (password.length < 6) {
      error = 'Password minimal 6 karakter';
    }

    state = state.copyWith(password: password, passwordError: error, errorMessage: null);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<void> login(BuildContext context) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: "Email dan password tidak boleh kosong.");
      return;
    }

    if (state.emailError != null || state.passwordError != null) {
      // Jangan lanjutkan login jika ada error validasi
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      print('🔁 Attempting login...');
      final result = await authService.login(
        email: state.email,
        password: state.password,
      );
      print('✅ API response: $result');

      final success = result['success'] == true || result['status'] == true;

      if (success) {
        final String token = result['token'];
        await ref.read(secureStorageProvider).saveToken(token);
        state = state.copyWith(isLoading: false);

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result['message'] ?? 'Login gagal.',
        );
      }
    } catch (e) {
      print('❌ Login error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan. Silakan coba lagi.',
      );
    }
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModelNotifier, LoginViewModel>(
  (ref) => LoginViewModelNotifier(
    authService: AuthServiceWrapper(),
    ref: ref,
  ),
);
