import 'menu_item.dart';

class OrderHistoryModel {
  final String orderId;
  final String date;
  final int total;
  final List<MenuItem> items;

  OrderHistoryModel({
    required this.orderId,
    required this.date,
    required this.total,
    required this.items,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      orderId: json['order_id'],
      date: json['date'],
      total: json['total'],
      items: (json['items'] as List)
          .map((itemJson) => MenuItem.fromJson(itemJson))
          .toList(),
    );
  }
}
