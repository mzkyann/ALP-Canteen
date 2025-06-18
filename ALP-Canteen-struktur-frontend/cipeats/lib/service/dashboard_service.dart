import 'dart:convert';
import 'package:http/http.dart' as http;


class DashboardService {
  final String baseUrl;



  DashboardService({required this.baseUrl});

  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/dashboard'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal memuat data dashboard');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
