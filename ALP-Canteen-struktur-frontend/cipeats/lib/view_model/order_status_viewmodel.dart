import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/order_status_model.dart';

final orderStatusProvider = FutureProvider<List<OrderStatusModel>>((ref) async {
  return await ref.read(orderStatusViewModelProvider).fetchOrders();
});

final orderStatusViewModelProvider = Provider((ref) => OrderStatusViewModel());

class OrderStatusViewModel {
  Future<List<OrderStatusModel>> fetchOrders() async {
    return [
      OrderStatusModel(
        id: 1,
        imageUrl: 'assets/images/Nasi_Goreng.png',
        name: 'Nasi Goreng',
        queueNumber: 2,
        price: 12000,
        status: 'Siap',
        vendorName: 'Chick On Cup',
        vendorLogoUrl: 'assets/images/ChickonCup.png',
      ),
      OrderStatusModel(
        id: 2,
        imageUrl: 'assets/images/Mie_Kanton.png',
        name: 'Mie Kanton',
        queueNumber: 5,
        price: 15000,
        status: '15 menit',
        vendorName: 'Chick On Cup',
        vendorLogoUrl: 'assets/images/ChickonCup.png',
      ),
      OrderStatusModel(
        id: 3,
        imageUrl: 'assets/images/Nasi_Gila.png',
        name: 'Nasi Gila',
        queueNumber: 10,
        price: 15000,
        status: 'Diantar',
        vendorName: 'Chick On Cup',
        vendorLogoUrl: 'assets/images/ChickonCup.png',
      ),
    ];
  }
}
