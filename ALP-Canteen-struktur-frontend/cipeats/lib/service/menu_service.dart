import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import '../model/menu_item.dart';
import 'secure_storage_service.dart';

class MenuService {
  final SecureStorageService _storage;
  MenuService({SecureStorageService? storage})
      : _storage = storage ?? SecureStorageService();

  Future<List<MenuItem>> fetchAvailableFoods({String? vendor}) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/foods/public');
    final token = await _storage.read(key: 'token');
    final res = await http.get(url, headers: {
      'Authorization': token != null ? 'Bearer $token' : '',
      'Accept': 'application/json',
    });

    if (res.statusCode != 200) {
      throw Exception('Failed: ${res.statusCode}');
    }

    final decoded = json.decode(res.body);
    final List data = decoded is List
        ? decoded
        : (decoded['foods'] ?? decoded['data'] ?? []);

    final list = data.map((e) => MenuItem.fromJson(e)).toList();
    if (vendor != null && vendor.isNotEmpty) {
      return list.where((i) => i.vendor == vendor).toList();
    }
    return list;
  }

  maybeWhen({required Function(dynamic items) data, required List Function() orElse}) {}

  when({required Widget Function(dynamic menu) data, required Center Function() loading, required Center Function(dynamic err, dynamic stack) error}) {}
}
