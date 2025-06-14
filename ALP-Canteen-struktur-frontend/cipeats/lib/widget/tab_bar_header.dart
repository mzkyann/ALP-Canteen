import 'package:flutter/material.dart';

class TabBarHeader extends StatelessWidget {
  final int activeIndex;

  const TabBarHeader({super.key, required this.activeIndex, required Null Function(dynamic index) onTabSelected});

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ["Status", "Keranjang", "Riwayat"];
    List<String> routes = ["/status", "/keranjang", "/riwayat"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(tabs.length, (index) {
        return GestureDetector(
          onTap: () {
            if (activeIndex != index) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontWeight: activeIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              if (activeIndex == index)
                Container(
                  height: 2,
                  width: 40,
                  color: Colors.orange,
                ),
            ],
          ),
        );
      }),
    );
  }
}
