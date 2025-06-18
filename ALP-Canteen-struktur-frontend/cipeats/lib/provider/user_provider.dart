import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/user_view_model.dart';

// Example User model (adjust fields as needed)
class User {
  String fullName;
  String email;
  String phone;
  String password;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  User copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? password,
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}

// Example UserNotifier (adjust logic as needed)
class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(User(
          fullName: 'Nama Pengguna',
          email: 'email@contoh.com',
          phone: '08123456789',
          password: 'password',
        ));

  void updateName(String name) {
    state = state.copyWith(fullName: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});