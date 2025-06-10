import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/menu_view_model.dart';
import '../model/menu_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuList = ref.watch(menuProvider);

    Widget getImage(String imageUrl) {
      if (imageUrl.startsWith('assets/')) {
        return Image.asset(
          imageUrl,
          height: 100,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
          imageUrl,
          height: 100,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Kantin UC',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          // Vendor logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/vendor1');
                },
                child: Column(
                  children: [
                    Image.asset('assets/images/ChickonCup.png', width: 120),
                    const SizedBox(height: 4),
                    const Text("Chick on Cup"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/vendor2');
                },
                child: Column(
                  children: [
                    Image.asset('assets/images/WarungAw.png', width: 120),
                    const SizedBox(height: 4),
                    const Text("Warung AW"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Rekomendasi Harian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          // ✅ GridView yang sudah diubah agar responsif seperti Vendor1
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: menuList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 180,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final item = menuList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: item,
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
                            child: getImage(item.imageUrl),
                          ),
                          Positioned(
                            top: 4,
                            left: 4,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                item.vendor == "Chick on Cup"
                                    ? 'assets/images/ChickonCup.png'
                                    : 'assets/images/WarungAw.png',
                              ),
                              radius: 12,
                            ),
                          ),
                          if (!item.available)
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Habis",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text("Rp ${item.price}",
                                style: const TextStyle(color: Colors.grey)),
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

          const SizedBox(height: 16),
        ],
      ),
        bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          currentIndex: 2, // Set this dynamically based on current page
          backgroundColor: const Color.fromARGB(255, 54, 54, 54),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedIconTheme: const IconThemeData(size: 30),
          unselectedIconTheme: const IconThemeData(size: 26),
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/keranjang');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/akun');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
            BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Pesanan"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Akun"),
          ],
        ),
      ),
    );
  }
}
