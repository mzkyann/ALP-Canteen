import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';
import 'menu_provider.dart'; // Assuming this gives you full menu list

final vendorMenuProvider = Provider.family<List<MenuItem>, int>((ref, vendorId) {
  final allMenu = ref.watch(menuProvider).maybeWhen(
    data: (items) => items,
    orElse: () => [],
  );

  return allMenu.where((item) => item.user.id == vendorId).toList().cast<MenuItem>();
});
