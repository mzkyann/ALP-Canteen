import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

final vendorMenuProvider = Provider<List<MenuItem>>((ref) {
  return [
    MenuItem(name: "Prasmanan", imageUrl: "assets/images/Prasmanan.png", price: 0, vendor: "Chick on Cup", available: true),
    MenuItem(name: "Nasi Goreng", imageUrl: "assets/images/Nasi_Goreng.png", price: 12000, vendor: "Chick on Cup", available: true),
    MenuItem(name: "Ayam Geprek", imageUrl: "assets/images/Ayam_Geprek.png", price: 15000, vendor: "Chick on Cup", available: true),
    MenuItem(name: "Mie Kanton", imageUrl: "assets/images/Mie_Kanton.png", price: 14000, vendor: "Chick on Cup", available: false),
    MenuItem(name: "Kentang Goreng", imageUrl: "assets/images/Kentang_Goreng.png", price: 13000, vendor: "Chick on Cup", available: true),
    MenuItem(name: "Nasi Gila", imageUrl: "assets/images/Nasi_Gila.png", price: 15000, vendor: "Chick on Cup", available: false),
    MenuItem(name: "Bakara Goreng", imageUrl: "assets/images/Bakara_Goreng.png", price: 15000, vendor: "Chick on Cup", available: true),
    MenuItem(name: "Pisang Goreng", imageUrl: "assets/images/Pisang_Goreng.png", price: 14000, vendor: "Chick on Cup", available: false),
  ];
});
