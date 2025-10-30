import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaitingCat extends StatelessWidget {
  const WaitingCat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: Lottie.asset('assets/animations/waiting_cat.json'),
        ),
        Text(
          "출근 기다리는중... 😭",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
