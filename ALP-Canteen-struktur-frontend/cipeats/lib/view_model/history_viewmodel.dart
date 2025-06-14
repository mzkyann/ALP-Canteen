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
        imageUrl: 'https://example.com/nasgor.jpg',
        price: 15000,
        vendor: 'Kantin UC',
      ),
      HistoryItem(
        name: 'Mie Ayam',
        imageUrl: 'https://example.com/mieayam.jpg',
        price: 13000,
        vendor: 'Kantin A',
      ),
    ];
  }
}
