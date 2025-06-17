import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/checkout_item_model.dart';
import '../view_model/checkout_view_model.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutProvider);
    final vm = ref.read(checkoutProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
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
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
                label: const Text('Back', style: TextStyle(color: Colors.black)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Metode Pengantaran
            const Text('Metode Pengantaran'),
            RadioListTile(
              title: const Text('Ambil Mandiri'),
              value: DeliveryMethod.pickup,
              groupValue: state.deliveryMethod,
              onChanged: (val) => vm.toggleDeliveryMethod(val!),
            ),
            RadioListTile(
              title: const Text('Diantar'),
              value: DeliveryMethod.delivered,
              groupValue: state.deliveryMethod,
              onChanged: (val) => vm.toggleDeliveryMethod(val!),
            ),

            // Lokasi hanya muncul jika 'Diantar' dipilih
            if (state.deliveryMethod == DeliveryMethod.delivered) ...[
              const SizedBox(height: 16),
              const Text('Lokasi'),
              DropdownButton<String>(
                value: state.location.isEmpty ? null : state.location,
                hint: const Text('Pilih lantai'),
                isExpanded: true,
                items: [
                  'Basement',
                  'Lantai 1',
                  'Lantai 2',
                  'Lantai 3',
                  'Lantai 4',
                  'Lantai 5',
                  'Lantai 6',
                ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => vm.setLocation(val!),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: state.locationDetail),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Detail lokasi...',
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Waktu Pengantaran
            const Text('Waktu Pengantaran'),
            RadioListTile(
              title: const Text('Sekarang'),
              value: DeliveryTime.now,
              groupValue: state.deliveryTime,
              onChanged: (val) => vm.toggleDeliveryTime(val!),
            ),
            RadioListTile(
              title: const Text('Terjadwal'),
              value: DeliveryTime.scheduled,
              groupValue: state.deliveryTime,
              onChanged: (val) => vm.toggleDeliveryTime(val!),
            ),

            if (state.deliveryTime == DeliveryTime.scheduled)
              Row(
                children: [
                  const Text('Waktu: '),
                  TextButton(
                    child: Text('${state.scheduledTime.format(context)}'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          DateTime initialDateTime = DateTime(
                            0,
                            0,
                            0,
                            state.scheduledTime.hour,
                            state.scheduledTime.minute,
                          );
                          DateTime selectedDateTime = initialDateTime;

                          return Container(
                            padding: const EdgeInsets.all(16),
                            height: 300,
                            child: Column(
                              children: [
                                const Text(
                                  'Pilih Waktu (08:00 - 17:00)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                TimePickerSpinner(
                                  is24HourMode: true,
                                  normalTextStyle: const TextStyle(fontSize: 18, color: Colors.grey),
                                  highlightedTextStyle: const TextStyle(fontSize: 24, color: Colors.blue),
                                  time: initialDateTime,
                                  spacing: 30,
                                  itemHeight: 40,
                                  isForce2Digits: true,
                                  onTimeChange: (DateTime time) {
                                    selectedDateTime = time;
                                  },
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    final selectedTime = TimeOfDay(
                                      hour: selectedDateTime.hour,
                                      minute: selectedDateTime.minute,
                                    );
                                    if (selectedTime.hour >= 8 && selectedTime.hour <= 17) {
                                      vm.setScheduledTime(selectedTime);
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Pilih waktu antara jam 08:00 hingga 17:00'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Simpan'),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),

            const SizedBox(height: 16),

            // Metode Pembayaran
            const Text('Metode Pembayaran'),
            DropdownButton<PaymentMethod>(
              value: state.paymentMethod,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: PaymentMethod.cash, child: Text('Cash')),
                DropdownMenuItem(value: PaymentMethod.qris, child: Text('QRIS')),
              ],
              onChanged: (val) => vm.setPaymentMethod(val!),
            ),

            const SizedBox(height: 16),

            // Card Pesanan (ListView)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    height: 100,
                    child: Row(
                      children: [
                        Image.asset(item.imagePath, width: 70, height: 80),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('Rp.${item.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    if (item.quantity == 1) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Hapus Item'),
                                          content: const Text('Apakah Anda yakin ingin menghapus item ini dari pesanan?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final updatedItems = [...state.items]..removeAt(index);
                                                vm.setItems(updatedItems);
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      final updatedItems = [...state.items];
                                      updatedItems[index] = item.copyWith(quantity: item.quantity - 1);
                                      vm.setItems(updatedItems);
                                    }
                                  },
                                ),
                                Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    final updatedItems = [...state.items];
                                    updatedItems[index] = item.copyWith(quantity: item.quantity + 1);
                                    vm.setItems(updatedItems);
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            const Text('Tulis Catatan (opsional)'),
            TextField(
              maxLines: 3,
              controller: TextEditingController(text: state.note),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tuliskan Catatan....'
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.deepOrange, Colors.orange],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Biaya Admin: Rp. ${state.adminFee}', style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('Total Pembayaran: Rp. ${state.totalPrice}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black),
              ),
              child: const Text('Beli', style: TextStyle(color: Colors.black)),
              onPressed: state.items.isEmpty ? null : () {
                Navigator.pushNamed(context, '/bayar');
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
