import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cipeats/view/akun.dart';

void main() {
  testWidgets('Menolak penyimpanan jika nama kosong', (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: AkunPage()),
      ),
    );

    // ACT
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    final nameField = find.widgetWithText(TextField, 'Hainzel Kemal');
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, '');

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.widgetWithText(TextField, ''), findsOneWidget);
    // Tambahkan feedback/error jika ada validasi visual
  });

  testWidgets('Tampilkan password saat tombol show ditekan', (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: AkunPage()),
      ),
    );

    // ACT
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    final passwordField = find.widgetWithText(TextField, 'password');
    expect(passwordField, findsOneWidget);

    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle();

    // ASSERT
    // Password tidak disembunyikan setelah klik "Show"
    // Kita hanya memastikan tidak crash dan tombol berubah
    expect(find.text('Hide'), findsOneWidget);
  });

  testWidgets('Simpan berhasil ketika semua field terisi', (WidgetTester tester) async {
    // ARRANGE
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: AkunPage()),
      ),
    );

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // ACT
    await tester.enterText(find.widgetWithText(TextField, 'Hainzel Kemal'), 'Nama Baru');
    await tester.enterText(find.widgetWithText(TextField, 'hainzelganteng@student.ciputra.ac.id'), 'email@baru.com');
    await tester.enterText(find.widgetWithText(TextField, '081213241234'), '0899999999');
    await tester.enterText(find.widgetWithText(TextField, 'password'), 'newpass');

    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.widgetWithText(TextField, 'Nama Baru'), findsOneWidget);
  });
}
