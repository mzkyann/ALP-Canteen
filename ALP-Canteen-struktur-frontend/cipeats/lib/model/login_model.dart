class LoginViewModel {
  final String email;
  final String password;
  final bool passwordVisible;
  final bool rememberMe;
  final bool isLoading;
  final String? errorMessage;

  LoginViewModel({
    this.email = '',
    this.password = '',
    this.passwordVisible = false,
    this.rememberMe = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginViewModel copyWith({
    String? email,
    String? password,
    bool? passwordVisible,
    bool? rememberMe,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginViewModel(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}