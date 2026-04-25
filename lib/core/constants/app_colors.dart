import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);

  // Background
  static const Color background = Color(0xFFF1F8E9);
  static const Color card = Colors.white;

  // Semantic
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFBC02D);
  static const Color danger = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1565C0);

  // Text
  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFFAAAAAA);

  // Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2C2C2C);
  static const Color darkDivider = Color(0xFF3A3A3A);

  // Chart Colors
  static const Color chartSuhu = Color(0xFFE53935);
  static const Color chartKelembapanUdara = Color(0xFF1565C0);
  static const Color chartKelembapanTanah = Color(0xFF558B2F);

  // Gradients
  static const List<Color> gradientPrimary = [primaryDark, primary];
  static const List<Color> gradientSuhu = [Color(0xFFFF6B6B), Color(0xFFFF8E53)];
  static const List<Color> gradientUdara = [Color(0xFF4FC3F7), Color(0xFF0288D1)];
  static const List<Color> gradientTanah = [Color(0xFF81C784), Color(0xFF388E3C)];
  static const List<Color> gradientStatus = [Color(0xFFA5D6A7), Color(0xFF2E7D32)];
}