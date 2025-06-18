import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';

class MenuService {
  Future<List<MenuItem>> fetchAvailableFoods() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/foods/public');
    
    developer.log("📡 Calling API: $url", name: 'MenuService');
    print("📡 Calling API: $url"); // ← Visible in terminal

    try {
      final response = await http.get(url);

      developer.log("✅ Status: ${response.statusCode}", name: 'MenuService');
      developer.log("📦 Body: ${response.body}", name: 'MenuService');

      print("✅ Status: ${response.statusCode}");
      print("📦 Body: ${response.body}"); // ← Show full raw response in terminal

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final List data = decoded is List
            ? decoded
            : (decoded['foods'] ?? decoded['data'] ?? []);

        return data.map((json) => MenuItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch available foods');
      }
    } catch (e) {
      developer.log("🔥 Exception: $e", name: 'MenuService', level: 1000);
      print("🔥 Exception: $e"); // ← Show exception in terminal
      rethrow;
    }
  }
}
