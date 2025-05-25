class CheckoutItemModel {
  final String name;
  final double price;
  final int quantity;
  final String imagePath;

  CheckoutItemModel({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });

  int get totalPrice => (price * quantity).toInt();

  CheckoutItemModel copyWith({
    String? name,
    double? price,
    int? quantity,
    String? imagePath,
  }) {
    return CheckoutItemModel(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
