class LoginViewModel {
  final String email;
  final String password;
  final bool passwordVisible;
  final bool rememberMe;
  final bool isLoading;
  final String? errorMessage;

  const LoginViewModel({
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
    bool resetError = false,
  }) {
    return LoginViewModel(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: resetError ? null : errorMessage ?? this.errorMessage,
    );
  }

  /// Optional: helper to reset state after logout
  factory LoginViewModel.initial() => const LoginViewModel();

  @override
  String toString() {
    return 'LoginViewModel(email: $email, password: $password, '
        'visible: $passwordVisible, rememberMe: $rememberMe, '
        'loading: $isLoading, error: $errorMessage)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginViewModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          passwordVisible == other.passwordVisible &&
          rememberMe == other.rememberMe &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      passwordVisible.hashCode ^
      rememberMe.hashCode ^
      isLoading.hashCode ^
      errorMessage.hashCode;
}
