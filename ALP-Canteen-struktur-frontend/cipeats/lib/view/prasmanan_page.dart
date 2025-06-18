import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/menu_provider.dart'; // Pastikan path ini benar
import '../widget/menu_card.dart';
import '../model/menu_item.dart'; // Jika MenuCard butuh MenuItem

class PrasmananPage extends ConsumerWidget {
  const PrasmananPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuAsync = ref.watch(menuProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text("Prasmanan"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepOrange, Colors.orange]),
          ),
        ),
      ),
      body: menuAsync.when(
        data: (menu) {
          if (menu.isEmpty) {
            return const Center(child: Text("Belum ada menu tersedia."));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return MenuCard(item: menu[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Gagal memuat menu: $err")),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Tambahkan logika pemesanan di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fitur pesan belum diimplementasikan")),
                  );
                },
                child: const Text("Pesan"),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/keranjang');
              },
            )
          ],
        ),
      ),
    );
  }
}
