import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.card,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
          ),
        ),
        textTheme: _textTheme(Brightness.light),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFEEEEEE),
          thickness: 1,
          space: 1,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkCard,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A2F0C),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
          ),
        ),
        textTheme: _textTheme(Brightness.dark),
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
          space: 1,
        ),
      );

  static TextTheme _textTheme(Brightness brightness) {
    final baseColor =
        brightness == Brightness.light ? AppColors.textPrimary : Colors.white;
    final secColor = brightness == Brightness.light
        ? AppColors.textSecondary
        : Colors.white70;

    return TextTheme(
      headlineLarge: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w800, color: baseColor),
      headlineMedium: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w700, color: baseColor),
      headlineSmall: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: baseColor),
      titleLarge: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: baseColor),
      titleMedium: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      bodyLarge: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: baseColor),
      bodyMedium: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w400, color: secColor),
      bodySmall: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w400, color: secColor),
    );
  }
}