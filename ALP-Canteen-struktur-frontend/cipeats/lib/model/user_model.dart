class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      isVerified: json['is_verified'] == true,
    );
  }
}
