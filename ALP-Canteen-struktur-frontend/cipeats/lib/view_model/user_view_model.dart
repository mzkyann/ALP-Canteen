import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/user_model.dart';
import '../../view/akun.dart';

class UserViewModel extends StateNotifier<UserModel> {
  UserViewModel()
      : super(UserModel(
          fullName: 'Hainzel Kemal',
          email: 'hainzelganteng@student.ciputra.ac.id',
          phone: '081213241234',
          password: 'password',
        ));

  void updateName(String name) => state = state.copyWith(fullName: name);
  void updateEmail(String email) => state = state.copyWith(email: email);
  void updatePhone(String phone) => state = state.copyWith(phone: phone);
  void updatePassword(String password) => state = state.copyWith(password: password);
}

final userProvider = StateNotifierProvider<UserViewModel, UserModel>((ref) {
  return UserViewModel();
});