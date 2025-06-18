import 'package:cipeats/model/user_model.dart';

class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? estimatedTime;
  final bool availability;
  final String imageUrl;
  final UserModel user;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.estimatedTime,
    required this.availability,
    required this.imageUrl,
    required this.user,
  });

factory MenuItem.fromJson(Map<String, dynamic> json) {
  final String fullImageUrl = 'http://127.0.0.1:8000/storage/${json['image']}';

  return MenuItem(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: double.tryParse(json['price'].toString()) ?? 0,
    estimatedTime: json['estimated_time'],
    availability: json['availability'] == 1,
    user: UserModel.fromJson(json['user']),
    imageUrl: fullImageUrl, // ✅ Correct field
  );
}

  get available => null;

  get vendor => null;


}
