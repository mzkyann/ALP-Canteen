class OrderStatusModel {
  final int id;
  final String imageUrl;
  final String name;
  final int queueNumber;
  final int price;
  final String status;
  final String vendorName;
  final String vendorLogoUrl;

  OrderStatusModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.queueNumber,
    required this.price,
    required this.status,
    required this.vendorName,
    required this.vendorLogoUrl,
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      queueNumber: json['queueNumber'],
      price: json['price'],
      status: json['status'],
      vendorName: json['vendorName'],
      vendorLogoUrl: json['vendorLogoUrl'],
    );
  }
}
