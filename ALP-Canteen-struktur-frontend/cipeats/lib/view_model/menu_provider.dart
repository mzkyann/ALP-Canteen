import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';
import '../service/menu_service.dart';
import '../repository/menu_repository.dart';

// ✅ Provide the repository
final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository(MenuService());
});

// ✅ Provide the FutureProvider for menus
final menuProvider = FutureProvider<List<MenuItem>>((ref) {
  final repository = ref.watch(menuRepositoryProvider);
  return repository.getAvailableMenus();
});
