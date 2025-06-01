import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/bayar_model.dart';

class BayarState {
  final String pin;
  final bool isObscured;
  final BayarModel model;

  BayarState({
    required this.pin,
    required this.isObscured,
    required this.model,
  });

  BayarState copyWith({
    String? pin,
    bool? isObscured,
    BayarModel? model,
  }) {
    return BayarState(
      pin: pin ?? this.pin,
      isObscured: isObscured ?? this.isObscured,
      model: model ?? this.model,
    );
  }
}

class BayarViewModel extends StateNotifier<BayarState> {
  BayarViewModel()
      : super(
          BayarState(
            pin: '',
            isObscured: true,
            model: BayarModel(amount: 15000),
          ),
        );

  void addDigit(String digit) {
    if (state.pin.length >= 4) return;
    state = state.copyWith(pin: state.pin + digit);
  }

  void toggleObscure() {
    state = state.copyWith(isObscured: !state.isObscured);
  }

  void deleteDigit() {
    if (state.pin.isEmpty) return;
    state = state.copyWith(pin: state.pin.substring(0, state.pin.length - 1));
  }

  Future<void> submitPayment() async {
    if (state.pin.length < 4) return;
    print('Submitting payment of Rp. ${state.model.amount}. PIN = ${state.pin}');
  }
}

final bayarViewModelProvider =
    StateNotifierProvider<BayarViewModel, BayarState>((ref) {
  return BayarViewModel();
});
