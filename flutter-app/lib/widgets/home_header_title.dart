import 'package:flutter/material.dart';

class HomeHeaderTitle extends StatelessWidget {
  const HomeHeaderTitle({super.key});

  @override
  Widget build(BuildContext context) {
    String two(int n) => n.toString().padLeft(2, '0');
    final today = DateTime.now();
    final formatted = "${today.year}-${two(today.month)}-${two(today.day)}";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 48),
          Text(formatted, style: TextStyle(fontSize: 24)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz_outlined, size: 28),
          ),
        ],
      ),
    );
  }
}
