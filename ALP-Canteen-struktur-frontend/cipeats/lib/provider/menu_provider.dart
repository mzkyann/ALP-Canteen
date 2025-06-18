import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/menu_service.dart';
import '../model/menu_item.dart';

// Service provider for MenuService
final menuServiceProvider = Provider((ref) => MenuService());

// FutureProvider to fetch the actual menu list from API
final menuProvider = FutureProvider<List<MenuItem>>((ref) async {
  final service = ref.read(menuServiceProvider);
  return await service.fetchAvailableFoods();
});
