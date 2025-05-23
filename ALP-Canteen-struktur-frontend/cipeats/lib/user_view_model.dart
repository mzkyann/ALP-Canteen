import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../view/akun.dart';

class UserViewModel extends StateNotifier<UserModel> {
  UserViewModel()
      : super(UserModel(
          fullName: 'Hainzel Kemal',
          email: 'hainzelganteng@student.ciputra.ac.id',
          phone: '081213241234',
          password: 'password',
        ));

  void updateName(String name) => state = UserModel(
      fullName: name,
      email: state.email,
      phone: state.phone,
      password: state.password);

  void updateEmail(String email) => state = UserModel(
      fullName: state.fullName,
      email: email,
      phone: state.phone,
      password: state.password);

  void updatePhone(String phone) => state = UserModel(
      fullName: state.fullName,
      email: state.email,
      phone: phone,
      password: state.password);

  void updatePassword(String password) => state = UserModel(
      fullName: state.fullName,
      email: state.email,
      phone: state.phone,
      password: password);
}

final userProvider = StateNotifierProvider<UserViewModel, UserModel>((ref) {
  return UserViewModel();
});