import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum RisikoLevel { low, medium, high }

extension RisikoLevelExt on RisikoLevel {
  String get label {
    switch (this) {
      case RisikoLevel.low:
        return 'Risiko Rendah';
      case RisikoLevel.medium:
        return 'Risiko Sedang';
      case RisikoLevel.high:
        return 'Risiko Tinggi';
    }
  }

  String get shortLabel {
    switch (this) {
      case RisikoLevel.low:
        return 'Low';
      case RisikoLevel.medium:
        return 'Medium';
      case RisikoLevel.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case RisikoLevel.low:
        return AppColors.success;
      case RisikoLevel.medium:
        return AppColors.warning;
      case RisikoLevel.high:
        return AppColors.danger;
    }
  }

  String get emoji {
    switch (this) {
      case RisikoLevel.low:
        return '✅';
      case RisikoLevel.medium:
        return '⚠️';
      case RisikoLevel.high:
        return '🚨';
    }
  }
}

/// ================== ENTITY (JANGAN DIUBAH) ==================
class HamaResult {
  final String kondisiDaun;
  final String jenisHama;
  final double confidence;
  final RisikoLevel levelRisiko;
  final String mitigasi;
  final DateTime? analyzedAt;

  const HamaResult({
    required this.kondisiDaun,
    required this.jenisHama,
    required this.confidence,
    required this.levelRisiko,
    required this.mitigasi,
    this.analyzedAt,
  });

  bool get isHealthy => kondisiDaun.toLowerCase() == 'sehat';

  @override
  String toString() =>
      'HamaResult(kondisi: $kondisiDaun, hama: $jenisHama, confidence: $confidence%)';
}

/// ================== RULE-BASED RF ==================
class RandomForestRules {
  static const Map<String, Map<String, String>> rules = {

    // ===== KERITING =====
    'keriting_panas_tinggi': {
      'hama': 'trips',
      'mitigasi': 'Semprot insektisida abamektin atau spinosad, pasang perangkap kuning'
    },
    'keriting_panas_sedang': {
      'hama': 'trips',
      'mitigasi': 'Gunakan insektisida nabati (ekstrak bawang putih/neem)'
    },
    'keriting_panas_rendah': {
      'hama': 'tungau',
      'mitigasi': 'Gunakan akarisida ringan dan tingkatkan frekuensi penyiraman'
    },
    'keriting_normal_rendah': {
      'hama': 'tungau',
      'mitigasi': 'Semprot akarisida propargit, jaga kelembapan tanah'
    },
    'keriting_normal_sedang': {
      'hama': 'tungau',
      'mitigasi': 'Gunakan akarisida alami dan pantau suhu lingkungan'
    },
    'keriting_dingin_sedang': {
      'hama': 'tungau',
      'mitigasi': 'Tingkatkan suhu dan ventilasi, semprot belerang mikron'
    },
    'keriting_dingin_tinggi': {
      'hama': 'tungau',
      'mitigasi': 'Kurangi kelembapan, atur pencahayaan'
    },
    'keriting_normal_tinggi': {
      'hama': 'trips',
      'mitigasi': 'Gunakan ekstrak daun mimba dan semprot pagi hari'
    },
    'keriting_dingin_rendah': {
      'hama': 'tungau',
      'mitigasi': 'Gunakan akarisida sulfur dan tingkatkan suhu lingkungan'
    },

    // ===== BERCAK =====
    'bercak_normal_tinggi': {
      'hama': 'cercospora',
      'mitigasi': 'Semprot fungisida mankozeb atau klorotalonil, buang daun terinfeksi'
    },
    'bercak_normal_sedang': {
      'hama': 'cercospora',
      'mitigasi': 'Pantau kelembapan, hindari penyiraman malam hari'
    },
    'bercak_panas_tinggi': {
      'hama': 'cercospora',
      'mitigasi': 'Kurangi kelembapan, tingkatkan sirkulasi udara'
    },
    'bercak_dingin_tinggi': {
      'hama': 'cercospora',
      'mitigasi': 'Gunakan fungisida sistemik, buang daun sakit'
    },
    'bercak_normal_rendah': {
      'hama': 'cercospora',
      'mitigasi': 'Tingkatkan kelembapan, hindari sinar matahari langsung'
    },
    'bercak_panas_sedang': {
      'hama': 'cercospora',
      'mitigasi': 'Kurangi penyiraman, semprot fungisida ringan'
    },
    'bercak_dingin_sedang': {
      'hama': 'cercospora',
      'mitigasi': 'Perbaiki drainase dan sirkulasi udara'
    },
    'bercak_panas_rendah': {
      'hama': 'cercospora',
      'mitigasi': 'Tingkatkan kelembapan dan kurangi penyiraman malam'
    },
    'bercak_dingin_rendah': {
      'hama': 'cercospora',
      'mitigasi': 'Gunakan fungisida preventif dan jaga sirkulasi udara'
    },

    // ===== MENGUNING =====
    'menguning_normal_sedang': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Berikan pupuk NPK seimbang, periksa pH tanah'
    },
    'menguning_dingin_tinggi': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Perbaiki drainase, tambah unsur mikro Fe dan Mg'
    },
    'menguning_panas_sedang': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Tambahkan pupuk daun dan siram teratur'
    },
    'menguning_normal_tinggi': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Kurangi air, tambahkan pupuk mikro'
    },
    'menguning_normal_rendah': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Tingkatkan frekuensi penyiraman, tambah unsur N'
    },
    'menguning_panas_tinggi': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Kurangi paparan panas, siram pagi dan sore'
    },
    'menguning_dingin_sedang': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Gunakan pupuk daun kaya nitrogen'
    },
    'menguning_panas_rendah': {
      'hama': 'kekurangan_nutrisi',
      'mitigasi': 'Gunakan pupuk kalium dan tingkatkan kelembapan'
    },
  };
}