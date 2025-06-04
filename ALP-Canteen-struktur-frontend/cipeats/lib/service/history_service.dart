import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/order_model.dart';

class HistoryService {
  final http.Client client;

  HistoryService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchOrderHistory({
    required String token,
  }) async {
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
      final orders = (jsonBody['data'] as List)
          .map((orderJson) => OrderHistoryModel.fromJson(orderJson))
          .toList();

      return {
        'success': true,
        'orders': orders,
      };
    } else {
      return {
        'success': false,
        'message': jsonBody['message'] ?? 'Failed to fetch history',
      };
    }
  }
}
