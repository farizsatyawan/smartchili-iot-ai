import '../entities/sensor_data.dart';

/// Abstract interface — implementasi ada di data layer
/// Memudahkan swap: DummyDataSource → FirebaseDataSource
abstract class SensorRepository {
  /// Ambil data sensor sekali (one-shot)
  Future<SensorData> getSensorData();

  /// Stream realtime (akan dipakai saat Firebase terhubung)
  Stream<SensorData> watchSensorData();

  /// Ambil data historis 24 jam untuk chart
  Future<Map<String, List<double>>> getChartData24Jam();
}