import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/cart_service.dart';
import '../model/cart_model.dart';
import 'secure_storage_provider.dart';

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService();
});

final cartProvider = FutureProvider<List<CartModel>>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final token = await storage.read(key: 'token');

  if (token == null) {
    throw Exception("Token tidak ditemukan");
  }

  final cartService = ref.read(cartServiceProvider);
  final result = await cartService.getCart(token: token);

  if (result['success'] == true) {
    return result['items'] as List<CartModel>;
  } else {
    throw Exception(result['message']);
  }
});
