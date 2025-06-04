import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  final http.Client client;

  OrderService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> placeOrder({
    required String token,
    required List<Map<String, dynamic>> items,
    required String address,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8000/api');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'items': items,
        'address': address,
      }),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonBody['success'] == true) {
      return {
        'success': true,
        'message': jsonBody['message'] ?? 'Order placed successfully',
      };
    } else {
      return {
        'success': false,
        'message': jsonBody['message'] ?? 'Failed to place order',
      };
    }
  }
}
