import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';

class MenuDetailService {
  final String baseUrl = "http://10.0.2.2:8000/api"; 

  Future<MenuItem> fetchMenuItemDetail(String menuName) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/menu_item_detail?name=$menuName"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MenuItem.fromJson(data);
      } else {
        throw Exception('Gagal mengambil detail menu');
      }
    } catch (e) {
      throw Exception('Error saat fetch menu detail: $e');
    }
  }
}
