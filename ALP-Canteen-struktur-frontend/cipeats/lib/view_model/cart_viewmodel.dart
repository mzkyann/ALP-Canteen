import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

final cartProvider = StateNotifierProvider<CartViewModel, List<MenuItem>>((ref) {
  return CartViewModel();
});

final totalPriceProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.price);
});

class CartViewModel extends StateNotifier<List<MenuItem>> {
  CartViewModel() : super([]);

  void addToCart(MenuItem item) {
    state = [...state, item];
  }

  void removeFromCart(MenuItem item) {
    state = state.where((element) => element != item).toList();
  }

  void clearCart() {
    state = [];
  }
}
