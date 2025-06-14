import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../view_model/history_viewmodel.dart';
import '../widget/tab_bar_header.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(historyViewModelProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: screenHeight * 0.05, left: screenWidth * 0.05),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF512F), Color(0xFFFD9644)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Activity',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.05),
            child: TabBarHeader(
              activeIndex: 2, // 2 = Riwayat
              onTabSelected: (index) {
                if (index == 0) {
                  Navigator.pushNamed(context, '/status');
                } else if (index == 1) {
                  Navigator.pushNamed(context, '/keranjang');
                }
              },
            ),
          ),
        ),
      ),
      body: historyItems.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat pembelian.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: item.imageUrl != null
                        ? Image.network(
                            item.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.fastfood, size: 40),
                    title: Text(item.name ?? 'Tanpa nama'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Harga: Rp ${NumberFormat("#,###", "id_ID").format(item.price ?? 0)}',
                        ),
                        Text('Vendor: ${item.vendor ?? 'Tidak diketahui'}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
