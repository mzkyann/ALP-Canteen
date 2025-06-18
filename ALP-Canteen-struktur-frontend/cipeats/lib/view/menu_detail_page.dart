import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

class MenuDetailPage extends ConsumerWidget {
  const MenuDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MenuItem item = ModalRoute.of(context)!.settings.arguments as MenuItem;

    final TextEditingController catatanController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Kantin UC',
            style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: screenWidth * 0.5,
                    ),
                  ),
                  if (item.availability)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text("Ready",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(item.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Text("Rp. ${item.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 12),
              Text(item.description,
                  style: const TextStyle(fontSize: 14, height: 1.4)),
              const SizedBox(height: 16),
              TextField(
                controller: catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Catatan: (contoh: lebih banyak kecap)",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle pemesanan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Pesan",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shopping_cart, color: Colors.white),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            top: 16 + MediaQuery.of(context).padding.top,
            left: 16,
            child: ClipOval(
              child: Material(
                color: Colors.white.withOpacity(0.8),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
        selectedItemColor: Colors.grey[800],
        unselectedItemColor: Colors.grey[400],
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        showSelectedLabels: true,
      ),
    );
  }
}
