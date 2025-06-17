// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../view_model/menu_provider.dart';
// import '../widget/tab_bar_header.dart';

// class StatusPage extends ConsumerWidget {
//   const StatusPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final menuItems = ref.watch(menuProvider);
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.deepOrange, Colors.orangeAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         title: const Text(
//           'Activity',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           TabBarHeader(
//             activeIndex: 0,
//             onTabSelected: (index) {
//               switch (index) {
//                 case 0:
//                   Navigator.pushReplacementNamed(context, '/status');
//                   break;
//                 case 1:
//                   Navigator.pushReplacementNamed(context, '/keranjang');
//                   break;
//                 case 2:
//                   Navigator.pushReplacementNamed(context, '/history');
//                   break;
//               }
//             },
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: menuItems.length,
//               itemBuilder: (context, index) {
//                 final item = menuItems[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.black12),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         offset: Offset(0, 2),
//                       )
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(
//                           item.imageUrl,
//                           width: size.width * 0.2,
//                           height: size.width * 0.2,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               item.name,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text("Antrian : 0${index + 2}"),
//                             Text("Rp${item.price},00"),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: item.available ? Colors.green : Colors.orange,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           item.available ? 'Siap' : '15 menit',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           )
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 1, // Ganti sesuai tab aktif, misalnya 1 untuk status
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushReplacementNamed(context, '/home');
//               break;
//             case 1:
//               Navigator.pushReplacementNamed(context, '/status');
//               break;
//             case 2:
//               Navigator.pushReplacementNamed(context, '/akun');
//               break;
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
//           BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Pesanan"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
//         ],
//       ),
//     );
//   }
// }
