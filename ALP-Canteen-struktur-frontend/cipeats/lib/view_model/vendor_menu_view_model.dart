import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

final vendorMenuProvider = Provider<List<MenuItem>>((ref) {
  return [
    MenuItem(
      name: "Prasmanan",
      imageUrl: "assets/images/Prasmanan.png",
      price: 0,
      vendor: "Chick on Cup",
      available: true,
      description: "Pilihan lauk dan nasi bisa ambil sendiri sesuai selera. Cocok untuk porsi besar.",
    ),
    MenuItem(
      name: "Nasi Goreng",
      imageUrl: "assets/images/Nasi_Goreng.png",
      price: 12000,
      vendor: "Chick on Cup",
      available: true,
      description: "Nasi goreng khas dengan bumbu spesial dan topping sesuai selera.",
    ),
    MenuItem(
      name: "Ayam Geprek",
      imageUrl: "assets/images/Ayam_Geprek.png",
      price: 15000,
      vendor: "Chick on Cup",
      available: true,
      description: "Ayam goreng tepung digeprek dengan sambal pedas. Favorit pecinta pedas.",
    ),
    MenuItem(
      name: "Mie Kanton",
      imageUrl: "assets/images/Mie_Kanton.png",
      price: 14000,
      vendor: "Chick on Cup",
      available: false,
      description: "Mie lembut khas Kanton dengan kuah gurih dan topping pilihan.",
    ),
    MenuItem(
      name: "Kentang Goreng",
      imageUrl: "assets/images/Kentang_Goreng.png",
      price: 13000,
      vendor: "Chick on Cup",
      available: true,
      description: "Kentang goreng renyah cocok untuk camilan atau pelengkap.",
    ),
    MenuItem(
      name: "Nasi Gila",
      imageUrl: "assets/images/Nasi_Gila.png",
      price: 15000,
      vendor: "Chick on Cup",
      available: false,
      description: "Nasi goreng super pedas dengan berbagai topping daging dan sayuran.",
    ),
    MenuItem(
      name: "Bakara Goreng",
      imageUrl: "assets/images/Bakara_Goreng.png",
      price: 15000,
      vendor: "Chick on Cup",
      available: true,
      description: "Bakara gurih digoreng dengan bumbu rahasia, garing di luar lembut di dalam.",
    ),
    MenuItem(
      name: "Pisang Goreng",
      imageUrl: "assets/images/Pisang_Goreng.png",
      price: 14000,
      vendor: "Chick on Cup",
      available: false,
      description: "Pisang matang digoreng dengan tepung krispi. Cocok untuk pencuci mulut.",
    ),
  ];
});
