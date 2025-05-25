import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipeats/model/menu_item.dart';
import 'package:cipeats/view_model/vendor_menu_view_model.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('vendorMenuProvider returns 8 MenuItems', () {
    final items = container.read(vendorMenuProvider);
    expect(items.length, 8);
    expect(items.every((item) => item is MenuItem), true);
  });

  test('item Nasi Goreng has correct properties', () {
    final items = container.read(vendorMenuProvider);
    final nasiGoreng = items.firstWhere((item) => item.name == "Nasi Goreng");

    expect(nasiGoreng.price, 12000);
    expect(nasiGoreng.vendor, "Chick on Cup");
    expect(nasiGoreng.available, true);
    expect(nasiGoreng.imageUrl, "assets/images/Nasi_Goreng.png");
    expect(nasiGoreng.description.contains("bumbu spesial"), true);
  });

  test('number of unavailable items is correct', () {
    final items = container.read(vendorMenuProvider);
    final unavailableItems = items.where((item) => item.available == false);

    expect(unavailableItems.length, 3);
    expect(unavailableItems.any((item) => item.name == "Mie Kanton"), true);
    expect(unavailableItems.any((item) => item.name == "Nasi Gila"), true);
    expect(unavailableItems.any((item) => item.name == "Pisang Goreng"), true);
  });
}
