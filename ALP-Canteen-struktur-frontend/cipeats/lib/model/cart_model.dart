class CartModel {
  final int id;
  final String name;
  final int quantity;
  final int price;

  CartModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}
