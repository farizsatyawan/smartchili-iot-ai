import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../domain/entities/sensor_data.dart';

enum SensorStatus { initial, loading, loaded, error }

class SensorProvider extends ChangeNotifier {
  final DatabaseReference _sensorRef =
      FirebaseDatabase.instance.ref("sensor");

  SensorStatus _status = SensorStatus.initial;
  SensorData? _sensorData;

  final Map<String, List<double>> _chartData = {
    'suhu': [],
    'kelembapan_udara': [],
    'kelembapan_tanah': [],
  };

  int _selectedChart = 0;
  String _errorMessage = '';

  // ================= GETTERS =================

  SensorStatus get status => _status;
  SensorData? get sensorData => _sensorData;
  Map<String, List<double>> get chartData => _chartData;
  int get selectedChart => _selectedChart;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == SensorStatus.loading;
  bool get hasData => _sensorData != null;

  List<double> get currentChartData {
    switch (_selectedChart) {
      case 1:
        return _chartData['kelembapan_udara'] ?? [];
      case 2:
        return _chartData['kelembapan_tanah'] ?? [];
      default:
        return _chartData['suhu'] ?? [];
    }
  }

  // ================= CONSTRUCTOR =================

  SensorProvider() {
    _startListening();
  }

  // ================= LISTEN FIREBASE =================

  void _startListening() {
    _status = SensorStatus.loading;
    notifyListeners();

    _sensorRef.onValue.listen((event) {
      final map = event.snapshot.value as Map?;

      if (map == null) return;

      final suhu = (map['temperature'] ?? 0).toDouble();
      final hum = (map['humidity'] ?? 0).toDouble();
      final rawSoil = (map['soil'] ?? 0).toDouble();
      final pump = map['pump_status'] ?? false;

      // 🔥 KONVERSI RAW SOIL → PERSEN
      double soilPercent = _convertSoilToPercent(rawSoil);

      // Update entity
      _sensorData = SensorData(
        suhu: suhu,
        kelembapanUdara: hum,
        kelembapanTanah: soilPercent,
        statusTanaman: pump ? "Pompa ON" : "Pompa OFF",
        lastUpdated: DateTime.now().toIso8601String(),
        isOnline: true,
      );

      // Update chart (max 24 titik data)
      _addChartData('suhu', suhu);
      _addChartData('kelembapan_udara', hum);
      _addChartData('kelembapan_tanah', soilPercent);

      _status = SensorStatus.loaded;
      notifyListeners();
    }, onError: (error) {
      _status = SensorStatus.error;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }

  // ================= SOIL CONVERTER =================

  double _convertSoilToPercent(double raw) {
    // Kalibrasi sesuai sensor kamu:
    // 1000 = basah (100%)
    // 4000 = kering (0%)

    const double wetValue = 1000;
    const double dryValue = 4000;

    double percent =
        100 - ((raw - wetValue) / (dryValue - wetValue) * 100);

    // Clamp supaya tidak lebih dari 0–100
    return percent.clamp(0, 100);
  }

  // ================= CHART =================

  void _addChartData(String key, double value) {
    final currentList = _chartData[key] ?? [];

    final updatedList = List<double>.from(currentList)..add(value);

    if (updatedList.length > 24) {
      updatedList.removeAt(0);
    }

    _chartData[key] = updatedList;
  }

  void selectChart(int index) {
    _selectedChart = index;
    notifyListeners();
  }
}