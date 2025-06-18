import '../model/user_model.dart';
import '../service/user_service.dart';

class UserRepository {
  Future<UserModel> getUser() async {
    final json = await UserService.getUser(); // use static call
    return UserModel.fromJson(json);
  }

  Future<void> logout() async {
    await UserService.logout(); // use static call
  }
}
