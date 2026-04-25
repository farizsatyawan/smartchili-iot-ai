import '../entities/sensor_data.dart';
import '../repositories/sensor_repository.dart';

class GetSensorData {
  final SensorRepository repository;

  GetSensorData(this.repository);

  Future<SensorData> call() => repository.getSensorData();
}