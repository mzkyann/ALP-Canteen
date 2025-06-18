/// Represents an authenticated user in the app.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final bool isVerified;

  /// Only used locally (e.g., for editing profile form)
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    this.password = '',
  });

  /// Creates a user from API JSON response.
factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['id'] ?? 0, // safely fallback to 0 if null
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: '', // don't store password from server
    role: json['role'] ?? '',
    isVerified: json['email_verified_at'] != null,
  );
}



  /// Returns an "empty" unauthenticated user.
  factory UserModel.empty() {
    return const UserModel(
      id: 0,
      name: '',
      email: '',
      role: 'user',
      isVerified: false,
      password: '',
    );
  }

  /// Converts model to JSON (e.g., for sending to API).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'is_verified': isVerified,
      // ❗️ Intentionally excludes `password` unless explicitly added
    };
  }

  /// Returns a copy of the user with optional updated fields.
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    bool? isVerified,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, role: $role, '
        'isVerified: $isVerified, password: ${password.isNotEmpty ? '***' : ''})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          role == other.role &&
          isVerified == other.isVerified &&
          password == other.password;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      role.hashCode ^
      isVerified.hashCode ^
      password.hashCode;
}
