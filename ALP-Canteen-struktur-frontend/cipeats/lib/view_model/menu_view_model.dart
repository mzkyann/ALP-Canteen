import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

final menuProvider = Provider<List<MenuItem>>((ref) {
  return [
    MenuItem(
      name: "Nasi Goreng",
      imageUrl: "assets/images/Nasi_Goreng.png",
      price: 12000,
      vendor: "Chick on Cup",
      available: true,
    ),
    MenuItem(
      name: "Mie Kanton",
      imageUrl: "assets/images/Mie_Kanton.png",
      price: 15000,
      vendor: "Warung AW",
      available: true,
    ),
    MenuItem(
      name: "Ayam Geprek",
      imageUrl: "assets/images/Ayam_Geprek.png",
      price: 15000,
      vendor: "Chick on Cup",
      available: true,
    ),
    MenuItem(
      name: "Kentang Goreng",
      imageUrl: "assets/images/Kentang_Goreng.png",
      price: 15000,
      vendor: "Warung AW",
      available: true,
    ),
  ];
});
