import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';

class FoodService {
  final http.Client client;

  FoodService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchFoods() async {
    final url = Uri.parse('http://10.0.2.2:8000/api');

    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonBody['success'] == true) {
      final foods = (jsonBody['data'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();

      return {
        'success': true,
        'foods': foods,
      };
    } else {
      return {
        'success': false,
        'message': jsonBody['message'] ?? 'Failed to fetch foods',
      };
    }
  }
}
