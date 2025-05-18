class UserModel {
  final String email;
  final String password;
  final String fullName;
  final bool rememberMe;
  final bool passwordVisible;

  UserModel({
    this.email = '',
    this.password = '',
    this.fullName = '',
    this.rememberMe = false,
    this.passwordVisible = false,
  });

  UserModel copyWith({
    String? email,
    String? password,
    String? fullName,
    bool? rememberMe,
    bool? passwordVisible,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      rememberMe: rememberMe ?? this.rememberMe,
      passwordVisible: passwordVisible ?? this.passwordVisible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      'rememberMe': rememberMe,
      'passwordVisible': passwordVisible,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
      rememberMe: json['rememberMe'] ?? false,
      passwordVisible: json['passwordVisible'] ?? false,
    );
  }
}
