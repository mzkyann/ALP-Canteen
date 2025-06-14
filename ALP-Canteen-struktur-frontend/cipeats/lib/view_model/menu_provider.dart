import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

final menuProvider = Provider<List<MenuItem>>((ref) {
  return [
    MenuItem(
      name: "Nasi Goreng",
      imageUrl: "assets/nasi_goreng.jpg",
      price: 12000,
      vendor: "Kantin A",
      description: "Nasi goreng dengan telur ceplok.",
      available: true,
    ),
    MenuItem(
      name: "Mie Ayam",
      imageUrl: "assets/mie_ayam.jpg",
      price: 15000,
      vendor: "Kantin B",
      description: "Mie ayam dengan topping ayam manis.",
      available: false,
    ),
    MenuItem(
      name: "Nasi Campur",
      imageUrl: "assets/nasi_campur.jpg",
      price: 15000,
      vendor: "Kantin C",
      description: "Nasi campur lengkap dengan lauk pauk.",
      available: true,
    ),
  ];
});