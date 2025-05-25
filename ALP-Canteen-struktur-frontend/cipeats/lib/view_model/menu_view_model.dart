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
      description:
          "Nasi goreng dengan bumbu khas, bisa ditambah topping seperti ayam, telur, sosis, dan kerupuk.",
    ),
    MenuItem(
      name: "Mie Kanton",
      imageUrl: "assets/images/Mie_Kanton.png",
      price: 15000,
      vendor: "Warung AW",
      available: true,
      description:
          "Mie khas Kanton dengan saus spesial, sayuran segar, dan pilihan topping ayam atau sapi.",
    ),
    MenuItem(
      name: "Ayam Geprek",
      imageUrl: "assets/images/Ayam_Geprek.png",
      price: 15000,
      vendor: "Chick on Cup",
      available: true,
      description:
          "Ayam goreng tepung digeprek dengan sambal pedas, cocok untuk pecinta rasa nendang.",
    ),
    MenuItem(
      name: "Kentang Goreng",
      imageUrl: "assets/images/Kentang_Goreng.png",
      price: 15000,
      vendor: "Warung AW",
      available: true,
      description:
          "Kentang goreng renyah dengan bumbu asin gurih, cocok untuk camilan atau teman makan.",
    ),
  ];
});
