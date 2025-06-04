import 'package:cipeats/service/menu_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';


final menuServiceProvider = Provider<MenuService>((ref) => MenuService());

final menuProvider = FutureProvider<List<MenuItem>>((ref) async {
  final service = ref.watch(menuServiceProvider);
  return service.fetchAllMenuItems();
});

final vendorMenuProvider = FutureProvider.family<List<MenuItem>, String>((ref, vendorName) async {
  final service = ref.watch(menuServiceProvider);
  return service.fetchVendorMenu(vendorName);
});

