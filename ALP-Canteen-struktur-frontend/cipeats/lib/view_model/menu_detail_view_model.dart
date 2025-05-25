import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

final menuDetailProvider = StateProvider<List<MenuItem>>((ref) {
  return [
    MenuItem(
      name: 'Nasi goreng',
      imageUrl: 'assets/images/Nasi_Goreng.png',
      price: 12000,
      vendor: 'Chick on Cup',
      description: 'Terbuat dari nasi yang digoreng bareng bumbu seperti bawang, kecap, dan kadang ditambah sambal...',
      available: true,
    ),
    // Tambahkan item lain kalau perlu
  ];
});