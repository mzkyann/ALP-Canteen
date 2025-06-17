import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/menu_provider.dart'; // Ganti sesuai lokasi file menuProvider
import '../widget/menu_card.dart';

class PrasmananPage extends ConsumerWidget {
  const PrasmananPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider);

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
      body: menu.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
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
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Tambahkan aksi ketika tombol "Pesan" ditekan
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
