import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/login_view_model.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(loginViewModelProvider);
    final notifier = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 255, 79, 15), Color.fromARGB(255, 255, 164, 54)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', height: 120),
                const SizedBox(height: 32),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: const Color.fromARGB(255, 153, 153, 153)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: notifier.setEmail,
                  ),
                ),
                const SizedBox(height: 26),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TextField(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    obscureText: !vm.passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: const Color.fromARGB(255, 153, 153, 153)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          vm.passwordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: notifier.togglePasswordVisibility,
                      ),
                    ),
                    onChanged: notifier.setPassword,
                  ),

                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: vm.rememberMe,
                      onChanged: (value) {
                        notifier.setRememberMe(value ?? false);
                      },
                    ),
                    const Text("Ingat saya"),
                  ],
                ),
                const SizedBox(height: 26),


                if (vm.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: vm.isLoading
                        ? null
                        : () => notifier.login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: vm.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
