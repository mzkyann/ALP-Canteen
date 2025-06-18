class CartModel {
  final int id;
  final String name;
  final String imageUrl;
  final int quantity;
  final int totalPrice;

  CartModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: json['total_price'] ?? 0,
    );
  }
}
