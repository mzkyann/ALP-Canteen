import '../model/menu_item.dart';

class DashboardLocalService {
  final List<MenuItem> menuList;

  DashboardLocalService(this.menuList);

  Map<String, dynamic> getDashboardData() {
    final totalMenu = menuList.length;
    final totalVendor = menuList.map((e) => e.vendor).toSet().length;
    final menuTersedia = menuList.where((e) => e.available).length;
    final menuTermahal = menuList.reduce((a, b) => a.price > b.price ? a : b);

    final menuPerVendor = <String, int>{};
    for (var item in menuList) {
      menuPerVendor[item.vendor] = (menuPerVendor[item.vendor] ?? 0) + 1;
    }

    return {
      "total_menu": totalMenu,
      "total_vendor": totalVendor,
      "menu_tersedia": menuTersedia,
      "menu_termahal": {
        "name": menuTermahal.name,
        "price": menuTermahal.price,
      },
      "menu_per_vendor": menuPerVendor,
    };
  }
}
