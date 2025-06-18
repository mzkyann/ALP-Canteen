import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'keranjang.dart';
import 'riwayat.dart';
import 'status.dart';

class PesananPage extends ConsumerStatefulWidget {
  const PesananPage({super.key});

  @override
  ConsumerState<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends ConsumerState<PesananPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: 'Status'),
    Tab(text: 'Keranjang'),
    Tab(text: 'Riwayat'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          'Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: _tabs,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.orange,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          currentIndex: 1,
          backgroundColor: const Color.fromARGB(255, 54, 54, 54),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          selectedIconTheme: const IconThemeData(size: 30),
          unselectedIconTheme: const IconThemeData(size: 26),
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/akun');
            }
            // Jangan push ulang PesananPage karena sudah aktif
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
            BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Pesanan"),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Akun"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          StatusPage(),     // Halaman status pesanan
          KeranjangPage(),  // Menampilkan isi keranjang
          RiwayatPage(),    // Riwayat pesanan
        ],
      ),
    );
  }
}
