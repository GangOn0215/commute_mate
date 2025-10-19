import 'package:flutter/material.dart';

class AccountHeaderIcon extends StatelessWidget {
  const AccountHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // 아이콘과 Column 세로 정렬
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: const Icon(
            Icons.account_circle_sharp,
            size: 84,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
