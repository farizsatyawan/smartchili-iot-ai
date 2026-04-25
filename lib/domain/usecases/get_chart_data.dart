import '../repositories/sensor_repository.dart';

class GetChartData {
  final SensorRepository repository;

  GetChartData(this.repository);

  Future<Map<String, List<double>>> call() =>
      repository.getChartData24Jam();
}