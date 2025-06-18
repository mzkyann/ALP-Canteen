import 'package:flutter/material.dart';
import '../model/user_model.dart';

class RegisterViewModel extends ChangeNotifier {
  UserModel _user = UserModel.empty();

  UserModel get user => _user;

  void setEmail(String email) {
    _user = _user.copyWith(email: email);
    notifyListeners();
  }

  void setPassword(String password) {
    // Note: password isn't part of UserModel. You may want to store it separately
    // Or modify UserModel to include it.
    notifyListeners();
  }

  void setFullName(String fullName) {
    _user = _user.copyWith(name: fullName);
    notifyListeners();
  }

  void submit() {
    print(_user.toJson());
  }
}
