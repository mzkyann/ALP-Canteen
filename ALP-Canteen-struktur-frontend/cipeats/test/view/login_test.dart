import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cipeats/view/loginPage.dart';

void main() {
  testWidgets('LoginPage UI test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Cek apakah logo muncul
    expect(find.byType(Image), findsOneWidget);

    // Cek input field email dan password
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);

    // Cek tombol view
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    // Cek ingat saya
    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('Ingat saya'), findsOneWidget);

    // Cek tombol login
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    // Cek lupa kata sandi dan sign up
    expect(find.text('Lupa kata sandi?'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
