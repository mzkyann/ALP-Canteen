import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view/home_page.dart';
import 'view/vendor1.dart'; 
import 'view/vendor2.dart'; 
import 'view/menu_detail_page.dart';

void main() {
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),       
        '/vendor1': (context) => const Vendor1Page(), 
        '/vendor2': (context) => const Vendor2Page(), 
        '/detail': (context) => const MenuDetailPage(), 
      },
    );
  }
}
