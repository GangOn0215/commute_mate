import 'package:flutter/material.dart';

class PointsShopScreen extends StatelessWidget {
  const PointsShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('포인트 쇼핑')),
      body: Center(child: Text('포인트 쇼핑 화면입니다.')),
    );
  }
}
