import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/menu_service.dart';
import '../model/menu_item.dart';
import 'secure_storage_provider.dart';  // ← Make sure this path is correct

/// Inject the shared SecureStorageService into MenuService
final menuServiceProvider = Provider<MenuService>((ref) {
  final storage = ref.read(secureStorageProvider);
  return MenuService(storage: storage);
});

/// Fetch the menu list using the authenticated MenuService
final menuProvider = FutureProvider<List<MenuItem>>((ref) async {
  final service = ref.read(menuServiceProvider);
  return service.fetchAvailableFoods();
});
