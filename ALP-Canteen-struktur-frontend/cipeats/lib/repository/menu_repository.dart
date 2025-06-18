import '../model/menu_item.dart';
import '../service/menu_service.dart';

class MenuRepository {
  final MenuService _menuService;

  MenuRepository(this._menuService);

  Future<List<MenuItem>> getAvailableMenus() {
    return _menuService.fetchAvailableFoods();
  }
}
