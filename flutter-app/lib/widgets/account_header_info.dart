import 'package:flutter/material.dart';

class AccountHeaderInfo extends StatelessWidget {
  const AccountHeaderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 닉네임
        Text(
          "푸른색 맛 쿠키",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.0,
          ),
          overflow: TextOverflow.ellipsis, // 길면 ... 처리
          maxLines: 1,
        ),
        // 이메일
        Text(
          "dmsqlctnekf@gmail.com",
          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.0),
          overflow: TextOverflow.ellipsis, // 길면 ... 처리
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        // 레벨 표시
        const Text("Lv. 1"),
      ],
    );
  }
}
