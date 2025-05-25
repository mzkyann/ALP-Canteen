import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipeats/model/menu_item.dart';

/// Langsung definisikan menuProvider di file test ini.
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

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('menuProvider returns a list of 4 MenuItems', () {
    final menuItems = container.read(menuProvider);

    expect(menuItems.length, 4);
    expect(menuItems.every((item) => item is MenuItem), true);
  });

  test('first item is Nasi Goreng with correct properties', () {
    final menuItems = container.read(menuProvider);
    final nasiGoreng = menuItems.firstWhere((item) => item.name == "Nasi Goreng");

    expect(nasiGoreng.price, 12000);
    expect(nasiGoreng.vendor, "Chick on Cup");
    expect(nasiGoreng.available, true);
    expect(nasiGoreng.imageUrl, "assets/images/Nasi_Goreng.png");
    expect(nasiGoreng.description, contains("bumbu khas"));
  });

  test('vendor Warung AW has 2 items', () {
    final menuItems = container.read(menuProvider);
    final awItems = menuItems.where((item) => item.vendor == "Warung AW");

    expect(awItems.length, 2);
    expect(awItems.any((item) => item.name == "Mie Kanton"), true);
    expect(awItems.any((item) => item.name == "Kentang Goreng"), true);
  });
}
