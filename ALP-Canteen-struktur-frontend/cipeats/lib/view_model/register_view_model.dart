import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import '../service/auth_service.dart';

final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, AsyncValue<String?>>((ref) {
  final repository = AuthRepository(AuthService());
  return RegisterViewModel(repository);
});

class RegisterViewModel extends StateNotifier<AsyncValue<String?>> {
  RegisterViewModel(this._repository) : super(const AsyncValue.data(null));

  final AuthRepository _repository;

  String _email = '';
  String _password = '';
  String _fullName = '';

  void setEmail(String value) => _email = value;
  void setPassword(String value) => _password = value;
  void setFullName(String value) => _fullName = value;

  Future<void> submit() async {
    state = const AsyncValue.loading();

    try {
      final result = await _repository.register(_email, _password, _fullName);
      if (result['success'] == true) {
        state = AsyncValue.data(result['message'] ?? 'Registration successful.');
      } else {
        state = AsyncValue.error(result['message'] ?? 'Registration failed.', StackTrace.current);
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
