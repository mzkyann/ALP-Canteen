import 'package:flutter_riverpod/flutter_riverpod.dart';

// STATE
class LoginViewModel {
  final String email;
  final String password;
  final bool passwordVisible;
  final bool rememberMe;

  LoginViewModel({
    this.email = '',
    this.password = '',
    this.passwordVisible = false,
    this.rememberMe = false,
  });

  LoginViewModel copyWith({
    String? email,
    String? password,
    bool? passwordVisible,
    bool? rememberMe,
  }) {
    return LoginViewModel(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

// CONTROLLER
class LoginViewModelNotifier extends StateNotifier<LoginViewModel> {
  LoginViewModelNotifier() : super(LoginViewModel());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }
}

// PROVIDER
final loginViewModelProvider =
    StateNotifierProvider<LoginViewModelNotifier, LoginViewModel>(
        (ref) => LoginViewModelNotifier());
