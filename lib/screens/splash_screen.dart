import 'dart:async';

import 'package:flutter/material.dart';
import 'package:commute_mate/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 2초 후 Home 으로 이동
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/login');
      }
    });
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
