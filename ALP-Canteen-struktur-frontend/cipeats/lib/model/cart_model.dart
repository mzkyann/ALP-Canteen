class CartModel {
  final int id;
  final String name;
  final int quantity;
  final int price;
  final String imageUrl;

  CartModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  CartModel copyWith({
    int? id,
    String? name,
    int? quantity,
    int? price,
    String? imageUrl,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}
