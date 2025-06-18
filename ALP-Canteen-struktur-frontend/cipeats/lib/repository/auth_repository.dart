import '../service/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<Map<String, dynamic>> register(String email, String password, String name) {
    return _authService.register(email: email, password: password, name: name);
  }
}
 