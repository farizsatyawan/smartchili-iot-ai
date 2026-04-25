import 'dart:io';
import 'package:flutter/material.dart';

import '../../domain/entities/hama_result.dart';
import '../../data/datasources/local/tflite_ai_datasource.dart';

enum ScanStatus { idle, analyzing, result, error }

class ScanProvider extends ChangeNotifier {
  ScanStatus _status = ScanStatus.idle;
  HamaResult? _result;
  String _errorMessage = '';

  // 🔥 NEW: simpan path gambar
  String? _imagePath;

  final TfliteAiDatasource _ai = TfliteAiDatasource();

  // ================== GETTERS ==================
  ScanStatus get status => _status;
  HamaResult? get result => _result;
  String? get imagePath => _imagePath; // 🔥 NEW

  bool get isIdle => _status == ScanStatus.idle;
  bool get isAnalyzing => _status == ScanStatus.analyzing;
  bool get hasResult => _status == ScanStatus.result;
  bool get hasError => _status == ScanStatus.error;
  String get errorMessage => _errorMessage;

  // ================== INIT MODEL ==================
  Future<void> init() async {
    try {
      await _ai.loadModel();
      print("✅ TFLite model loaded");
    } catch (e) {
      _status = ScanStatus.error;
      _errorMessage = "Gagal load model: $e";
      notifyListeners();
    }
  }

  // ================== ANALYZE IMAGE ==================
  Future<void> analyzeImage(
    String? imagePath, {
    String? suhu,
    String? kelembapan,
  }) async {
    try {
      _status = ScanStatus.analyzing;
      _result = null;

      // 🔥 simpan image path untuk preview
      _imagePath = imagePath;

      notifyListeners();

      if (imagePath == null) {
        throw Exception("Image tidak ditemukan");
      }

      final file = File(imagePath);

      // 🔥 1. CNN
      final result = await _ai.predict(file);

      final kondisiDaun =
          result['label'].toLowerCase().trim();

      final confidence = result['confidence'];

      print("🧠 Hasil CNN: $kondisiDaun");
      print("📊 Confidence: $confidence");

      // 🔥 2. kondisi lingkungan
      final finalSuhu = suhu ?? "normal";
      final finalKelembapan = kelembapan ?? "sedang";

      print("🌡️ Suhu: $finalSuhu | 💧 Kelembapan: $finalKelembapan");

      // 🔥 3. rule-based
      final key = "${kondisiDaun}_${finalSuhu}_${finalKelembapan}";
      print("🔑 Rule Key: $key");

      final rule = RandomForestRules.rules[key];

      if (rule == null) {
        print("⚠️ Rule tidak ditemukan untuk key: $key");
      }

      final jenisHama = rule?['hama'] ?? 'tidak_diketahui';
      final mitigasi = rule?['mitigasi'] ?? 'Tidak ada rekomendasi';

      print("🐛 Hama: $jenisHama");
      print("💊 Mitigasi: $mitigasi");

      // 🔥 4. mapping ke entity
      _result = HamaResult(
        kondisiDaun: kondisiDaun,
        jenisHama: jenisHama,
        confidence: confidence,
        levelRisiko: _mapRisk(jenisHama),
        mitigasi: mitigasi,
        analyzedAt: DateTime.now(),
      );

      _status = ScanStatus.result;
      notifyListeners();
    } catch (e) {
      _status = ScanStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ================== RISK ==================
  RisikoLevel _mapRisk(String hama) {
    switch (hama) {
      case "trips":
      case "cercospora":
        return RisikoLevel.high;
      case "tungau":
        return RisikoLevel.medium;
      case "kekurangan_nutrisi":
        return RisikoLevel.low;
      default:
        return RisikoLevel.low;
    }
  }

  // ================== RESET ==================
  void reset() {
    _status = ScanStatus.idle;
    _result = null;
    _errorMessage = '';
    _imagePath = null; // 🔥 reset preview juga
    notifyListeners();
  }
}