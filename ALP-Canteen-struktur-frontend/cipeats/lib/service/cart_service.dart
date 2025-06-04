import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cart_model.dart';

class CartService {
  final http.Client client;

  CartService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> getCart({required String token}) async {
    final url = Uri.parse('http://10.0.2.2:8000/api');

    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonBody['success'] == true) {
      final cartItems = (jsonBody['data'] as List)
          .map((item) => CartModel.fromJson(item))
          .toList();

      return {
        'success': true,
        'items': cartItems,
      };
    } else {
      return {
        'success': false,
        'message': jsonBody['message'] ?? 'Failed to fetch cart',
      };
    }
  }

  Future<Map<String, dynamic>> addToCart({
    required String token,
    required int foodId,
    required int quantity,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8000/api');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'food_id': foodId, 'quantity': quantity}),
    );

    final jsonBody = jsonDecode(response.body);

    return {
      'success': jsonBody['success'] ?? false,
      'message': jsonBody['message'] ?? 'Unknown error',
    };
  }
}
