import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/user_view_model.dart' as viewmodel;

class AkunPage extends ConsumerStatefulWidget {
  const AkunPage({super.key});

  @override
  ConsumerState<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends ConsumerState<AkunPage> {
  bool isEditing = false;
  bool showPassword = false;
  bool _initialized = false;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(viewmodel.userProvider.notifier).fetchUser();
    });

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(viewmodel.userProvider);
    final userNotifier = ref.read(viewmodel.userProvider.notifier);

    if (!_initialized && user.id != 0) {
      nameController.text = user.name;
      emailController.text = user.email;
      passwordController.text = user.password ?? '';
      _initialized = true;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          'Akun',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: user.id == 0
          ? const Center(child: CircularProgressIndicator())
          : buildAccountBody(userNotifier),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  Widget buildAccountBody(viewmodel.UserNotifier userNotifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset('assets/images/logo.png', height: 100),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Detail Akun',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isEditing ? Icons.close : Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                            if (!isEditing) showPassword = false;

                            if (isEditing) {
                              nameController.text = ref.read(viewmodel.userProvider).name;
                              emailController.text = ref.read(viewmodel.userProvider).email;
                              passwordController.text = ref.read(viewmodel.userProvider).password ?? '';
                            }
                          });
                        },
                      )
                    ],
                  ),
                ),
                buildInfoField(
                  label: "Nama",
                  controller: nameController,
                  onChanged: userNotifier.updateName,
                ),
                buildInfoField(
                  label: "Email",
                  controller: emailController,
                  onChanged: userNotifier.updateEmail,
                ),
                buildInfoField(
                  label: "Password",
                  controller: passwordController,
                  onChanged: userNotifier.updatePassword,
                  isPassword: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (isEditing)
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  ),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                      showPassword = false;
                    });
                    // TODO: Implement profile update API call here
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
            ),
            onPressed: () async {
              await ref.read(viewmodel.userProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavBar() {
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        currentIndex: 2,
        backgroundColor: const Color.fromARGB(255, 54, 54, 54),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 26),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/pesanan');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/akun');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Akun"),
        ],
      ),
    );
  }

  Widget buildInfoField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: isEditing ? onChanged : null,
                  readOnly: !isEditing,
                  obscureText: isPassword && !showPassword,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (isPassword && isEditing)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  child: Text(
                    showPassword ? 'Hide' : 'Show',
                    style: const TextStyle(color: Colors.deepOrange),
                  ),
                ),
            ],
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
