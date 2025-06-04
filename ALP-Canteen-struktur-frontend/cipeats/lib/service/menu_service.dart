import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';

class MenuService {
  final String baseUrl = "http://10.0.2.2:8000/api"; // Ganti sesuai IP-mu

  Future<List<MenuItem>> fetchAllMenuItems() async {
    final response = await http.get(Uri.parse("$baseUrl/menu_items"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil semua menu");
    }
  }

  Future<List<MenuItem>> fetchVendorMenu(String vendorName) async {
    final response = await http.get(Uri.parse("$baseUrl/menu_items?vendor=$vendorName"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => MenuItem.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil menu vendor $vendorName");
    }
  }
}
