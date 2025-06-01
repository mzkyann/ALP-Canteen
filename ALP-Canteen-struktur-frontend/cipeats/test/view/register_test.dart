import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipeats/view/register_page.dart';

void main() {
  testWidgets('RegisterPage UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: RegisterPage(),
        ),
      ),
    );

    // Cek apakah logo muncul
    expect(find.byType(Image), findsOneWidget);

    // Cek input field email dan password
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Nama Lengkap'), findsOneWidget);

    // Cek tombol view
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    // Cek tombol register
    expect(find.widgetWithText(ElevatedButton, 'Register'), findsOneWidget);

    // Cek kembali
    expect(find.text('Kembali ke halaman login'), findsOneWidget);
  });
}
