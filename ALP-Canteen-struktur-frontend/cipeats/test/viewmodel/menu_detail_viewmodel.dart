import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipeats/model/menu_item.dart';
import 'package:cipeats/view_model/menu_detail_view_model.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state contains correct MenuItem details', () {
    // Act
    final item = container.read(menuDetailProvider);

    // Assert
    expect(item.name, 'Nasi Goreng');
    expect(item.price, 12000);
    expect(item.imageUrl, 'assets/images/Nasi_Goreng.png');
    expect(item.available, true);
    expect(item.vendor, '/vendor1');
    expect(item.description, contains('nasi yang digoreng'));
  });

  test('menuDetailProvider returns MenuItem instance', () {
    // Act
    final item = container.read(menuDetailProvider);

    // Assert
    expect(item, isA<MenuItem>());
  });
}
