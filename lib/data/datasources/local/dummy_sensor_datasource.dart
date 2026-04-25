import 'package:flutter/foundation.dart';
import '../../../core/constants/dummy_data.dart';
import '../../../domain/entities/sensor_data.dart';

/// Dummy datasource — akan diganti FirebaseSensorDatasource nanti
class DummySensorDatasource {
  Future<SensorData> getSensorData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DummyData.sensorData;
  }

  Stream<SensorData> watchSensorData() async* {
    // Simulasi streaming realtime setiap 5 detik
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield DummyData.sensorData;
    }
  }

  Future<Map<String, List<double>>> getChartData24Jam() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'suhu': DummyData.suhuChart,
      'kelembapan_udara': DummyData.kelembapanUdaraChart,
      'kelembapan_tanah': DummyData.kelembapanTanahChart,
    };
  }
}

/// Komentar untuk integrasi Firebase nanti:
///
/// class FirebaseSensorDatasource {
///   final FirebaseDatabase _db = FirebaseDatabase.instance;
///
///   Stream<SensorData> watchSensorData() {
///     return _db.ref('sensor/kebun_01').onValue.map((event) {
///       return SensorModel.fromJson(
///         Map<String, dynamic>.from(event.snapshot.value as Map)
///       );
///     });
///   }
/// }