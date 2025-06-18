import 'user_model.dart';

class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? estimatedTime;
  final String image;
  final bool availability;
  final UserModel user;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedTime,
    required this.image,
    required this.availability,
    required this.user,
    required this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      estimatedTime: json['estimated_time'],
      image: 'http://127.0.0.1:8000/storage/' + json['image'], // ✅ Full URL
      availability: json['availability'] == 1,
      user: UserModel.fromJson(json['user']),
      imageUrl: json['image_url'] ?? '', // Provide a default or parse as needed
    );
  }
}
