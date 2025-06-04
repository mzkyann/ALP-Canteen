import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';
import '../service/menu_detail_service.dart';

// Provider untuk service detail menu
final menuDetailServiceProvider = Provider<MenuDetailService>((ref) {
  return MenuDetailService();
});

// FutureProvider untuk fetch detail menu berdasarkan nama
final menuDetailFutureProvider = FutureProvider.family<MenuItem, String>((ref, String menuName) async {
  final service = ref.read(menuDetailServiceProvider);
  return service.fetchMenuItemDetail(menuName);
});
