import 'package:flutter/material.dart';

class KakaoLogoutButton extends StatefulWidget {
  final VoidCallback onKakaoLogout;
  const KakaoLogoutButton({super.key, required this.onKakaoLogout});

  @override
  State<KakaoLogoutButton> createState() => _KakaoLogoutButtonState();
}

class _KakaoLogoutButtonState extends State<KakaoLogoutButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onKakaoLogout,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFE003B), // 카카오 노란색
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 12,
        ),
      ),
      child: Text('카카오 로그아웃'),
    );
  }
}