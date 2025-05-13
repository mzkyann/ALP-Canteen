import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/menu_item.dart';

class MenuDetailViewModel extends StateNotifier<MenuItem> {
  MenuDetailViewModel()
      : super(MenuItem(
          name: 'Nasi Goreng',
          description:
              'Terbuat dari nasi yang digoreng bareng bumbu seperti bawang, kecap, dan kadang ditambah sambal biar makin nendang. Topping-nya bisa macem-macem—ayam, telur, sosis, atau bahkan kerupuk dan acar biar makin lengkap. Rasanya gurih, sedikit manis, dan bikin nagih, cocok dimakan kapan aja—pagi, siang, atau malam!',
          imageUrl: 'assets/images/Nasi_Goreng.png',
          price: 12000,
          available: true, vendor: '/vendor1',
        ));
}

final menuDetailProvider =
    StateNotifierProvider<MenuDetailViewModel, MenuItem>((ref) {
  return MenuDetailViewModel();
});
