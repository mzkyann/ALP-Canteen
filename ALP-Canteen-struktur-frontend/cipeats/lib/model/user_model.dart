class UserModel {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final bool rememberMe;
  final bool passwordVisible;

  UserModel({
    this.email = '',
    this.password = '',
    this.fullName = '',
    this.phone = '',
    this.rememberMe = false,
    this.passwordVisible = false,
  });

  UserModel copyWith({
    String? email,
    String? password,
    String? fullName,
    String? phone,
    bool? rememberMe,
    bool? passwordVisible,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      rememberMe: rememberMe ?? this.rememberMe,
      passwordVisible: passwordVisible ?? this.passwordVisible,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullName': fullName,
      'phone': phone,
      'rememberMe': rememberMe,
      'passwordVisible': passwordVisible,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      password: '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      rememberMe: json['rememberMe'] ?? false,
      passwordVisible: json['passwordVisible'] ?? false,
    );
  }
}
