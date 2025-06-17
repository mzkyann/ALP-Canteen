import 'package:flutter/material.dart';
import '../model/menu_item.dart';

class MenuCard extends StatefulWidget {
  final MenuItem item;

  const MenuCard({super.key, required this.item});

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  int quantity = 0;

  void increment() => setState(() => quantity++);
  void decrement() => setState(() {
    if (quantity > 0) quantity--;
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(widget.item.imageUrl, width: 120, height: 120, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(widget.item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text("Rp ${widget.item.price.toStringAsFixed(0)}"),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: decrement),
              Text('$quantity'),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: increment),
            ],
          ),
        ],
      ),
    );
  }
}
