import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/menu_provider.dart';
import '../model/menu_item.dart';

class Vendor2Page extends ConsumerWidget {
  const Vendor2Page({super.key});

  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final menuAsync = ref.watch(menuByVendorProvider('WarungAw'));

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: menuAsync.maybeWhen(
        data: (m) => m.isNotEmpty
            ? BottomNavigationBar(
                backgroundColor: Colors.black87,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
                  BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
                ],
              )
            : const SizedBox.shrink(),
        orElse: () => const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: menuAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
          data: (menus) => _buildContent(c, menus, 'WarungAw'),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext c, List<MenuItem> menus, String vendorName) =>
      Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(c),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 1,
                    ),
                  ),
                ),
                Text(
                  "Kantin UC",
                  style: TextStyle(
                    fontSize: MediaQuery.of(c).size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Image.asset('assets/images/WarungAw.png', width: 100, height: 100),
            const SizedBox(height: 8),
            Text(
              'Vendor: $vendorName',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (menus.isEmpty) ...[
              const SizedBox(height: 20),
              const Text("Belum ada menu tersedia."),
            ] else ...[
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menus.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75),
                itemBuilder: (_, i) => _buildCard(menus[i]),
              ),
            ],
            const SizedBox(height: 100),
          ]),
        ),
      );

  Widget _buildCard(MenuItem item) => Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(item.imageUrl, height: 100, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Rp ${item.price}"),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: item.available ? Colors.green : Colors.red),
                  ),
                ),
              ]),
            ),
          ),
        ]),
      );
}
