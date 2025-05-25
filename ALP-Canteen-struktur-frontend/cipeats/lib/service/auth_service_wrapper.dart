import 'auth_service.dart';

class AuthServiceWrapper {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return AuthService().login(email: email, password: password);
  }
}
