import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/menu_service.dart';
import '../model/menu_item.dart';
import 'secure_storage_provider.dart';

final menuServiceProvider = Provider<MenuService>((ref) {
  final storage = ref.read(secureStorageProvider);
  return MenuService(storage: storage);
});

final menuByVendorProvider =
    FutureProvider.family<List<MenuItem>, String>((ref, vendor) async {
  final svc = ref.read(menuServiceProvider);
  return svc.fetchAvailableFoods(vendor: vendor);
});
