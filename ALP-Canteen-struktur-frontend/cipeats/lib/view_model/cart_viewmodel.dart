import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/cart_model.dart';

class CartViewModel extends StateNotifier<List<CartModel>> {
  CartViewModel() : super(_dummyData);

  // Data dummy sementara
  static final List<CartModel> _dummyData = [
    CartModel(
      id: 1,
      name: "Nasi Goreng Spesial",
      quantity: 2,
      price: 18000,
      imageUrl: "assets/images/Nasi_Goreng.png",
      vendorImage: 'assets/images/ChickonCup.png',
      vendorName: 'Chick On Cup',
    ),
    CartModel(
      id: 2,
      name: "Mie Kanton",
      quantity: 1,
      price: 15000,
      imageUrl: "assets/images/Mie_Kanton.png",
      vendorImage: 'assets/images/ChickonCup.png',
      vendorName: 'Chick On Cup',
    ),
  ];

  void addToCart(CartModel item) {
    final index = state.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      // Tambah quantity jika sudah ada
      final updatedItem = state[index].copyWith(
        quantity: state[index].quantity + 1,
      );
      state = [...state]..[index] = updatedItem;
    } else {
      // Tambah baru
      state = [...state, item];
    }
  }

void removeItem(int id) {
  state = state.where((item) => item.id != id).toList();
}


  void increaseQuantity(int id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
  }

  void decreaseQuantity(int id) {
    state = state.map((item) {
      if (item.id == id && item.quantity > 1) {
        return item.copyWith(quantity: item.quantity - 1);
      }
      return item;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  int get totalPrice =>
      state.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

// Provider
final cartProvider = StateNotifierProvider<CartViewModel, List<CartModel>>(
  (ref) => CartViewModel(),
);

final totalPriceProvider = Provider<int>(
  (ref) => ref.watch(cartProvider.notifier).totalPrice,
);
