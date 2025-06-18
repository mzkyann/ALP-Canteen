// lib/view_model/splash_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/secure_storage_service.dart';

// State sederhana untuk splash
class SplashState {
  final bool isLoading;
  final bool isAuthenticated;

  const SplashState({
    this.isLoading = true,
    this.isAuthenticated = false,
  });

  SplashState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Provider untuk SecureStorageService (jika belum ada)
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// SplashViewModel
class SplashViewModel extends StateNotifier<SplashState> {
  final Ref ref;

  SplashViewModel(this.ref) : super(const SplashState()) {
    _init();
  }

  Future<void> _init() async {
    // Tetapkan loading = true
    state = state.copyWith(isLoading: true);

    // Baca token
    final token = await ref.read(secureStorageProvider).getToken();

    // Update state sesuai hasil pengecekan
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: token != null,
    );
  }
}

// Provider untuk SplashViewModel
final splashViewModelProvider =
    StateNotifierProvider<SplashViewModel, SplashState>(
  (ref) => SplashViewModel(ref),
);
