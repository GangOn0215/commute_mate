import 'dart:async';

import 'package:commute_mate/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:commute_mate/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // 스플래시 화면 최소 2초 표시
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 자동 로그인 시도
    final userProvider = context.read<UserProvider>();
    final isAutoLoginSuccess = await userProvider.tryAutoLogin();

    if (!mounted) return;

    if (isAutoLoginSuccess) {
      // 자동 로그인 성공 -> 홈 화면으로
      context.go('/home');
    } else {
      // 자동 로그인 실패 또는 저장된 정보 없음 -> 로그인 화면으로
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // 파스텔 크림 배경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 아이콘 (고양이 이모지 예시)
            const Text("🐱", style: TextStyle(fontSize: 64)),
            const SizedBox(height: 20),

            // 환영 문구
            const Text(
              "Welcome to Meow World 🐾",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary, // 진한 차콜
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),
            const Text(
              "Loading...",
              style: TextStyle(fontSize: 16, color: Color(0xFF777777)),
            ),
          ],
        ),
      ),
    );
  }
}
