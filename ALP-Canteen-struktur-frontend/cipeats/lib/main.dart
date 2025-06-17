import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
import 'view/prasmanan_page.dart';
import 'package:cipeats/view/riwayat.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'utils/cache_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi cache
  await CacheHelper.init();

  // Inisialisasi Sentry
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://yourPublicKey@o0.ingest.sentry.io/yourProjectId'; // Ganti DSN ini
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      const ProviderScope(child: MyApp()),
    ),
  );
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
        '/prasmanan': (context) => const PrasmananPage(),

      },
    );
  }
}
