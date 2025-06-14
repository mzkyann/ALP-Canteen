import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

class CartViewModel extends StateNotifier<List<MenuItem>> {
  CartViewModel() : super([]);

  void addToCart(MenuItem item) {
    if (item.available) {
      state = [...state, item];
    }
  }

  void removeFromCart(MenuItem item) {
    state = state.where((i) => i != item).toList();
  }

  void clearCart() {
    state = [];
  }

  List<MenuItem> get availableItems => state.where((item) => item.available).toList();

  int get totalPrice => state.fold(0, (sum, item) => sum + item.price);
}

final cartProvider = StateNotifierProvider<CartViewModel, List<MenuItem>>((ref) => CartViewModel());
final totalPriceProvider = Provider<int>((ref) => ref.watch(cartProvider.notifier).totalPrice);
