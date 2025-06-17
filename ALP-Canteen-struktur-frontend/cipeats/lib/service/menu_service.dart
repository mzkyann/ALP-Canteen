import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';

class MenuService {
  final String baseUrl = "http://10.0.2.2:8000/api";

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

  Future<List<MenuItem>> fetchMenu() async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi fetch
    return [
      MenuItem(
        name: 'Ayam Popcorn',
        imageUrl: 'https://i.imgur.com/WvEu0Sb.jpeg',
        price: 6000,
        available: true,
        description: 'Ayam goreng tepung krispi',
        vendor: 'Vendor A',
      ),
      MenuItem(
        name: 'Pallumara Ikan Bolu',
        imageUrl: 'https://i.imgur.com/Y2o5Dyk.jpeg',
        price: 6000,
        available: true,
        description: 'Sup asam khas Bugis Makassar',
        vendor: 'Vendor A',
      ),
      MenuItem(
        name: 'Ayam Bumbu Bali',
        imageUrl: 'https://i.imgur.com/7VcmkFh.jpeg',
        price: 6000,
        available: true,
        description: 'Ayam dengan bumbu khas Bali',
        vendor: 'Vendor A',
      ),
      MenuItem(
        name: 'Bakwan Sayur',
        imageUrl: 'https://i.imgur.com/CeOS02p.jpeg',
        price: 1500,
        available: true,
        description: 'Gorengan sayur renyah',
        vendor: 'Vendor A',
      ),
      MenuItem(
        name: 'Perkedel Jagung',
        imageUrl: 'https://i.imgur.com/kw7RRG3.jpeg',
        price: 1000,
        available: true,
        description: 'Jagung pipil goreng',
        vendor: 'Vendor A',
      ),
      MenuItem(
        name: 'Tempe',
        imageUrl: 'https://i.imgur.com/FYkBh3B.jpeg',
        price: 1000,
        available: true,
        description: 'Tempe goreng',
        vendor: 'Vendor A',
      ),
      MenuItem(
        name: 'Ayam Taichan',
        imageUrl: 'https://i.imgur.com/yF4L6Vy.jpeg',
        price: 12000,
        available: true,
        description: 'Ayam panggang sambal pedas',
        vendor: 'Vendor B',
      ),
      MenuItem(
        name: 'Ayam Chili Padi',
        imageUrl: 'https://i.imgur.com/s9xtQd6.jpeg',
        price: 12000,
        available: true,
        description: 'Ayam pedas khas Malaysia',
        vendor: 'Vendor B',
      ),
    ];
  }
}
