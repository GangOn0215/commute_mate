import 'package:flutter/material.dart';

class KakaoLoginButton extends StatefulWidget {
  final VoidCallback onLoginButtonPressed;  // 여기에 저장!
  const KakaoLoginButton({super.key, required this.onLoginButtonPressed});

  @override
  State<KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton> {
  

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onLoginButtonPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFEE500), // 카카오 노란색
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 12,
        ),
      ),
      child: const Text('카카오로 로그인'),
    );
  }
}