import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    fontFamily: "Jua",
    scaffoldBackgroundColor: AppColors.background,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      shadowColor: AppColors.grey300,
      elevation: 2,
      centerTitle: true,
      titleTextStyle: AppTextStyles.appBarTitle,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    textTheme: const TextTheme(bodyMedium: AppTextStyles.body),
  );
}
