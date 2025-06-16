import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../view_model/history_viewmodel.dart';
import '../model/history_item.dart';

class RiwayatPage extends ConsumerWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyItems = ref.watch(historyViewModelProvider);

    final Map<String, List<HistoryItem>> grouped = {};
    for (var item in historyItems) {
      final formattedDate = item.date != null
          ? DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(item.date!)
          : 'Tanggal tidak diketahui';
      grouped.putIfAbsent(formattedDate, () => []).add(item);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              ...entry.value.map((item) => _OrderCard(item: item)),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final HistoryItem item;

  const _OrderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item.imageUrl ?? '',
                width: 90,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp${NumberFormat('#,###', 'id_ID').format(item.price ?? 0)},00',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (item.vendorLogo != null && item.vendorLogo!.isNotEmpty)
                        Image.asset(
                          item.vendorLogo!,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.storefront, size: 14, color: Colors.black54),
                        )
                      else
                        const Icon(Icons.storefront, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        item.vendor ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.black),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 12),
              ),
              child: const Text("Pesan Lagi"),
            )
          ],
        ),
      ),
    );
  }
}
