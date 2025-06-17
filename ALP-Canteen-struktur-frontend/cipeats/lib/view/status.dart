import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/order_status_model.dart';
import '../view_model/order_status_viewmodel.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderStatusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (orders) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final item = orders[index];
              return _buildStatusCard(item);
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(OrderStatusModel item) {
  Color statusColor;
  if (item.status.toLowerCase() == 'siap') {
    statusColor = Colors.green;
  } else if (item.status.toLowerCase() == 'diantar') {
    statusColor = Colors.yellow.shade700;
  } else {
    statusColor = Colors.deepOrange;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            item.imageUrl,
            width: 90,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Antrian : ${item.queueNumber.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                'Rp${item.price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')},00',
                style: const TextStyle(fontSize: 13),
              ),
              Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      item.vendorLogoUrl,
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item.vendorName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            item.status,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: (item.status.toLowerCase() == 'diantar') ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
}