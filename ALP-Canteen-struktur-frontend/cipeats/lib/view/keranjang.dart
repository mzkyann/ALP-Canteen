import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/cart_viewmodel.dart';
import '../model/cart_model.dart';

class KeranjangPage extends ConsumerWidget {
  const KeranjangPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    final currencyFormatter = NumberFormat.decimalPattern('id');

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      body: cartItems.isEmpty
          ? const Center(child: Text("Keranjang kamu kosong."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _buildCartItem(context, ref, item);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepOrange, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Rp${currencyFormatter.format(totalPrice)},00",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pesanan diproses")),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Pesan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, WidgetRef ref, CartModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item.imageUrl,
              width: 90,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp${NumberFormat.decimalPattern('id').format(item.price)},00",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        item.vendorImage,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        item.vendorName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 114, 114, 114),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _qtyButton(
                icon: Icons.remove,
                onPressed: () {
                  if (item.quantity <= 1) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Hapus Item"),
                        content: const Text("Yakin ingin menghapus item ini dari keranjang?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeItem(item.id);
                              Navigator.of(ctx).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromARGB(221, 62, 62, 62),
                            ),
                            child: const Text("Hapus"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ref.read(cartProvider.notifier).decreaseQuantity(item.id);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  item.quantity.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              _qtyButton(
                icon: Icons.add,
                onPressed: () {
                  ref.read(cartProvider.notifier).increaseQuantity(item.id);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Icon(icon, size: 16),
      ),
    );
  }
}
