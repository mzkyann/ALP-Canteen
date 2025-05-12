import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

// Dummy data
final menuProvider = Provider<List<MenuItem>>((ref) {
  return [
    MenuItem(
        name: "Nasi Goreng",
        imageUrl: "https://i.imgur.com/tXqp4IW.png",
        price: 12000,
        vendor: "Chick on Cup",
        available: true),
    MenuItem(
        name: "Mie Kanton",
        imageUrl: "https://i.imgur.com/CxAGZrP.png",
        price: 15000,
        vendor: "Warung AW",
        available: true),
    MenuItem(  
        name: "Ayam Geprek",
        imageUrl: "https://i.imgur.com/x0QFjqI.png",
        price: 15000,
        vendor: "Chick on Cup",
        available: true),
    MenuItem(
        name: "Kentang Goreng Gosong",
        imageUrl: "https://i.imgur.com/K8MlyQw.png",
        price: 15000,
        vendor: "Warung AW",
        available: true),
  ];
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuList = ref.watch(menuProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("Kantin UC", style: TextStyle(color: Colors.white)),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildVendorIcon("https://i.imgur.com/igP1rPz.png", "Chick on Cup"),
                _buildVendorIcon("https://i.imgur.com/KVbNn2O.png", "Warung AW"),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Rekomendasi Harian",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                itemCount: menuList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  final item = menuList[index];
                  return _buildMenuCard(item);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }

  Widget _buildVendorIcon(String imageUrl, String title) {
    return Column(
      children: [
        Image.network(imageUrl, height: 60),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  Widget _buildMenuCard(MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: Image.network(item.imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover)),
              Positioned(
                top: 6,
                left: 6,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 12,
                  child: Image.network(
                    item.vendor == "Chick on Cup"
                        ? "https://i.imgur.com/igP1rPz.png"
                        : "https://i.imgur.com/KVbNn2O.png",
                    height: 16,
                  ),
                ),
              ),
              if (item.available)
                const Positioned(
                  bottom: 6,
                  right: 6,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 6,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Rp ${item.price}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
