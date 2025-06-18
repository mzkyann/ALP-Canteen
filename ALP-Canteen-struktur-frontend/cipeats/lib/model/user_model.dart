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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      isVerified: json['is_verified'] == true,
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: 0,
      name: '',
      email: '',
      role: 'user',
      isVerified: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'is_verified': isVerified,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
