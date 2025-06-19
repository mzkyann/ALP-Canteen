// lib/views/bayar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/bayar_viewmodel.dart';

class BayarPage extends ConsumerWidget {
  const BayarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bayarViewModelProvider);
    final vm = ref.read(bayarViewModelProvider.notifier);

    final amountString = state.model.amount
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

 return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),

      body: Column(
        children: [
          const SizedBox(height: 40),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Rp. ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                TextSpan(
                  text: amountString,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Container(
              width: double.infinity,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center the PIN (or dots)
                  Text(
                    state.isObscured
                        ? '•' * state.pin.length
                        : state.pin,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: vm.toggleObscure,
                      child: Icon(
                        state.isObscured
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberRow(context, ['1', '2', '3'], vm),
                  const SizedBox(height: 24),
                  _buildNumberRow(context, ['4', '5', '6'], vm),
                  const SizedBox(height: 24),
                  _buildNumberRow(context, ['7', '8', '9'], vm),
                  const SizedBox(height: 24),
                  _buildNumberRow(context, ['', '0', 'del'], vm),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black87),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: state.pin.length == 4
                  ? () async {
                      await vm.submitPayment();
                      Navigator.pushReplacementNamed(context, '/konfirmasi');
                  }
                  : null,
                child: const Text(
                  'Bayar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildNumberRow(
      BuildContext context, List<String> labels, BayarViewModel vm) {
    const double keySize = 80;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) {
        if (label.isEmpty) {
          return const SizedBox(width: keySize, height: keySize);
        }
        if (label == 'del') {
          return SizedBox(
            width: keySize,
            height: keySize,
            child: Center(
              child: GestureDetector(
                onTap: vm.deleteDigit,
                child: const Icon(
                  Icons.backspace,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            vm.addDigit(label);
          },
          child: Container(
            width: keySize,
            height: keySize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFA726),
                  Color(0xFFFF7043),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
