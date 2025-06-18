import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipeats/model/user_model.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel.empty());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  // Add updatePhone() only if phone is added to UserModel
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});
