class CartModel {
  final int id;
  final String name;
  final int quantity;
  final int price;
  final String imageUrl;
  final String vendorImage; 
  final String vendorName; 

  CartModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.vendorImage,
    required this.vendorName,
  });

  CartModel copyWith({
    int? id,
    String? name,
    int? quantity,
    int? price,
    String? imageUrl,
    String? vendorImage,
    String? vendorName,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      vendorImage: vendorImage ?? this.vendorImage,
      vendorName: vendorName ?? this.vendorName,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      vendorImage: json['vendorImage'],
      vendorName: json['vendorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'vendorImage': vendorImage,
      'vendorName': vendorName,
    };
  }
}
