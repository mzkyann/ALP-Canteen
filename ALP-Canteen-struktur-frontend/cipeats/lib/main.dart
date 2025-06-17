import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view/splash_screen.dart';
import 'view/loginPage.dart';
import 'view/register_page.dart';
import 'view/home_page.dart';
import 'view/vendor1.dart';
import 'view/vendor2.dart';
import 'view/menu_detail_page.dart';
import 'view/akun.dart';
import 'view/pesanan.dart';
import 'view/checkout.dart';
import 'view/bayar.dart';
import 'view/keranjang.dart';
import 'view/status_page.dart';
import 'view/history_page.dart';
import 'package:cipeats/view/riwayat.dart';
import 'package:intl/date_symbol_data_local.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin UC',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/vendor1': (context) => const Vendor1Page(),
        '/detail': (context) => const MenuDetailPage(),
        '/vendor2': (context) => const Vendor2Page(),
        '/akun': (context) => const AkunPage(),
        '/pesanan': (context) => const PesananPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/bayar': (context) => const BayarPage(),
        '/keranjang': (context) => const KeranjangPage(),
        '/status': (context) => const StatusPage(),
        '/riwayat': (context) => const RiwayatPage(),

      },
    );
  }
}
