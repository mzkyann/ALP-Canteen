class MenuItem {
  final String name;
  final String imageUrl;
  final int price;
  final String vendor;
  final String description;
  final bool available;

  MenuItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.vendor,
    required this.description,
    required this.available,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      vendor: json['vendor'],
      description: json['description'],
      available: json['available'],
    );
  }
}