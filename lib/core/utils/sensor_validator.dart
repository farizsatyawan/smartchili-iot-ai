import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SensorThreshold {
  SensorThreshold._();

  // ===== SUHU =====
  static const double maxSuhu = 35.0;
  static const double minSuhu = 15.0;

  // ===== KELEMBAPAN TANAH =====
  static const double minKelembapanTanah = 40.0;
  static const double maxKelembapanTanah = 80.0;

// ===== KELEMBAPAN UDARA =====
static const double rendahKelembapanUdara = 50.0;
static const double tinggiKelembapanUdara = 85.0;

  // ===== ALERT CONFIDENCE (Future AI) =====
  static const double minConfidenceAlert = 0.70;
}

class SensorValidator {
  SensorValidator._();

  // ==============================
  // 🌡 SUHU
  // ==============================
  static String getSuhuStatus(double suhu) {
    if (suhu > SensorThreshold.maxSuhu) {
      return 'Panas';
    }
    if (suhu < SensorThreshold.minSuhu) {
      return 'Dingin';
    }
    return 'Normal';
  }

  static Color getSuhuColor(double suhu) {
    if (suhu > SensorThreshold.maxSuhu) {
      return AppColors.danger;
    }
    if (suhu < SensorThreshold.minSuhu) {
      return AppColors.warning;
    }
    return AppColors.success;
  }

  // ==============================
  // 🌱 KELEMBAPAN TANAH
  // ==============================
  static String getKelembapanTanahStatus(double kelembapan) {
    if (kelembapan < SensorThreshold.minKelembapanTanah) {
      return 'Kering';
    }
    if (kelembapan > SensorThreshold.maxKelembapanTanah) {
      return 'Terlalu Basah';
    }
    return 'Normal';
  }

  static Color getKelembapanTanahColor(double kelembapan) {
    if (kelembapan < SensorThreshold.minKelembapanTanah) {
      return AppColors.danger;
    }
    if (kelembapan > SensorThreshold.maxKelembapanTanah) {
      return AppColors.warning;
    }
    return AppColors.success;
  }

  // ==============================
  // 💧 KELEMBAPAN UDARA
  // ==============================
  static String getKelembapanUdaraStatus(double kelembapan) {
    if (kelembapan < SensorThreshold.rendahKelembapanUdara) {
      return 'Rendah';
    }
    if (kelembapan > SensorThreshold.tinggiKelembapanUdara) {
      return 'Tinggi';
    }
    return 'Normal';
  }

  static Color getKelembapanUdaraColor(double kelembapan) {
    if (kelembapan < SensorThreshold.rendahKelembapanUdara) {
      return AppColors.danger;   // merah
    }
    if (kelembapan > SensorThreshold.tinggiKelembapanUdara) {
      return AppColors.warning;  // kuning
    }
    return AppColors.success;    // hijau
  }

  // ==============================
  // 🚨 ALERT CHECK
  // ==============================
  static bool needsAlert(double suhu, double kelembapanTanah) {
    return suhu > SensorThreshold.maxSuhu ||
        suhu < SensorThreshold.minSuhu ||
        kelembapanTanah < SensorThreshold.minKelembapanTanah ||
        kelembapanTanah > SensorThreshold.maxKelembapanTanah;
  }
}