import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/history_item.dart';

// Simulasi data dummy (bisa kamu ganti jadi fetch API nantinya)
final historyViewModelProvider = StateNotifierProvider<HistoryViewModel, List<HistoryItem>>(
  (ref) => HistoryViewModel(),
);

class HistoryViewModel extends StateNotifier<List<HistoryItem>> {
  HistoryViewModel() : super([]) {
    loadHistory();
  }

  void loadHistory() {
    // Ganti dengan API atau database di sini
    state = [
      HistoryItem(
        name: 'Nasi Goreng',
        imageUrl: 'assets/images/Nasi_Goreng.png',
        price: 15000,
        vendor: 'Warung AW',
        vendorLogo: 'assets/images/WarungAw.png',
        date: DateTime(2025, 4, 18),
      ),
      HistoryItem(
        name: 'Kentang Goreng',
        imageUrl: 'assets/images/Kentang_Goreng.png',
        price: 13000,
        vendor: 'Warung AW',
        vendorLogo: 'assets/images/WarungAw.png',
        date: DateTime(2025, 4, 18),
      ),
      HistoryItem(
        name: 'Nasi Goreng',
        imageUrl: 'assets/images/Nasi_Goreng.png',
        price: 15000,
        vendor: 'Warung AW',
        vendorLogo: 'assets/images/WarungAw.png',
        date: DateTime(2025, 4, 13),
      ),
    ];
  }
}
