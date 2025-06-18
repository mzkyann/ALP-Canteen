import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';
import '../service/user_service.dart';

/// ViewModel (StateNotifier) for managing authenticated user state
class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel.empty());

  /// Fetch the currently authenticated user from API
  Future<void> fetchUser() async {
    try {
      final data = await UserService.getUser(); // Should return Map<String, dynamic>
      print('✅ [UserNotifier] User fetched: $data'); // Debug output

      state = UserModel.fromJson(data);
    } catch (e) {
      print('❌ [UserNotifier] Failed to fetch user: $e'); // Error log
      reset(); // fallback to empty user
    }
  }

  /// Perform logout and clear user state
  Future<void> logout() async {
    try {
      await UserService.logout(); // API call to /logout
      print('👋 [UserNotifier] User logged out');
      reset();
    } catch (e) {
      print('❌ [UserNotifier] Logout failed: $e'); // Optional error log
    }
  }

  /// Reset user state to empty
  void reset() {
    print('🧼 [UserNotifier] State reset to empty');
    state = UserModel.empty();
  }

  /// Local state updates (used in forms or partial changes)
  void updateName(String name) {
    print('✏️ [UserNotifier] Name updated: $name');
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    print('✏️ [UserNotifier] Email updated: $email');
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    print('✏️ [UserNotifier] Password updated');
    state = state.copyWith(password: password);
  }

  void updateRole(String role) {
    print('✏️ [UserNotifier] Role updated: $role');
    state = state.copyWith(role: role);
  }

  void updateVerificationStatus(bool isVerified) {
    print('✏️ [UserNotifier] Email verification status updated: $isVerified');
    state = state.copyWith(isVerified: isVerified);
  }
}

/// Riverpod provider to expose the ViewModel
final userProvider = StateNotifierProvider<UserNotifier, UserModel>((ref) {
  return UserNotifier();
});
