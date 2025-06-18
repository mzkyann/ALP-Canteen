// lib/service/menu_service.dart

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:cipeats/service/secure_storage_service.dart';
import '../service/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';


class MenuService {
  // Secure storage instance to read the token
  final SecureStorageService _storage;
  
  // Add constructor
  MenuService({SecureStorageService? storage}) 
      : _storage = storage ?? SecureStorageService();

  Future<List<MenuItem>> fetchAvailableFoods() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/foods/public');
    developer.log("📡 Calling API: $url", name: 'MenuService');

    // Read the token from secure storage
    final token = await _storage.read(key: 'token');
    developer.log("🔑 Using token: ${token ?? "<none>"}", name: 'MenuService');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
          'Accept': 'application/json',
        },
      );

      developer.log("✅ Status: ${response.statusCode}", name: 'MenuService');
      developer.log("📦 Body: ${response.body}", name: 'MenuService');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final List data = decoded is List
            ? decoded
            : (decoded['foods'] ?? decoded['data'] ?? []);

        return data.map((json) => MenuItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch available foods: ${response.statusCode}');
      }
    } catch (e) {
      developer.log("🔥 Exception: $e", name: 'MenuService', level: 1000);
      rethrow;
    }
  }
}
