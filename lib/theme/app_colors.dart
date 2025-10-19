import 'package:flutter/material.dart';

class AppColors {
  // 기본 배경 (보노보노 느낌 파스텔 톤)
  static const background = Color(0xFFECEFF1); // 거의 화이트에 가까운 밝은 회색

  // 주요 포인트 컬러 (보노보노 톤 블루 & 민트)
  static const primary = Color(0xFF8EC5FC); // 파스텔 블루
  static const secondary = Color(0xFFA8E6CF); // 파스텔 민트

  // 텍스트 컬러
  static const textPrimary = Color(0xFF2C2C2C); // 진한 회색
  static const textSecondary = Color(0xFF6E6E6E); // 중간 회색
  static const textHint = Color(0xFF9E9E9E); // 힌트/비활성

  // 회색 계열 (UI 요소 단계별)
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey400 = Color(0xFFBDBDBD);
  static const grey500 = Color(0xFF9E9E9E);
  static const grey600 = Color(0xFF757575);
  static const grey700 = Color(0xFF616161);
  static const grey800 = Color(0xFF424242);
  static const grey900 = Color(0xFF212121);

  // 네비게이션 (아이콘/탭)
  static const navSelected = Color(0xFF8EC5FC); // 파스텔 블루
  static const navUnselected = Color(0xFF9E9E9E); // 중간 회색

  // 상태/알림 컬러
  static const success = Color(0xFF80CBC4); // 파스텔 민트/초록
  static const warning = Color(0xFFFFF59D); // 파스텔 노랑
  static const error = Color(0xFFFF8A80); // 파스텔 레드
  static const info = Color(0xFF81D4FA); // 파스텔 하늘색

  // 버튼 (보노보노 톤, 배경과 자연스럽게 어울리도록)
  static const buttonPrimaryBg = Color(0xFFB3E5FC); // 파스텔 하늘색
  static const buttonPrimaryText = textPrimary;

  static const buttonSecondaryBg = Color(0xFFE1F5FE); // 배경과 비슷한 연한 블루
  static const buttonSecondaryText = textPrimary;

  static const buttonDisabledBg = grey200;
  static const buttonDisabledText = grey500;
}
