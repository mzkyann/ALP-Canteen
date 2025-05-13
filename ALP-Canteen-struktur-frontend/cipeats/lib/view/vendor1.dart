import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/vendor_menu_view_model.dart';
import '../model/menu_item.dart';
import '../view_model/menu_detail_view_model.dart';
import 'menu_detail_page.dart';

class Vendor1Page extends ConsumerWidget {
  const Vendor1Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(vendorMenuProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                Image.asset('assets/images/ChickonCup.png', height: 100),
                const Text(
                  "Chick on Cup",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 2),
                const SizedBox(height: 10),

                // Grid Menu yang responsif
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      itemCount: menuItems.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisExtent: 180,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final item = menuItems[index];

                        return GestureDetector(
                          onTap: () {
                            ref.read(menuDetailProvider.notifier).state = item;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const MenuDetailPage()),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      child: Image.asset(
                                        item.imageUrl,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (!item.available)
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(10)),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text("Habis",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Rp ${item.price}",
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.circle,
                                          color: item.available
                                              ? Colors.green
                                              : Colors.red,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Tombol Back elegan (mengambang)
            Positioned(
              top: 16,
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
      ),

      // Bottom Navigation Bar
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
