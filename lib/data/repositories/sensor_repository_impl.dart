import '../../domain/entities/sensor_data.dart';
import '../../domain/repositories/sensor_repository.dart';
import '../datasources/local/dummy_sensor_datasource.dart';

class SensorRepositoryImpl implements SensorRepository {
  final DummySensorDatasource _datasource;

  SensorRepositoryImpl({DummySensorDatasource? datasource})
      : _datasource = datasource ?? DummySensorDatasource();

  @override
  Future<SensorData> getSensorData() => _datasource.getSensorData();

  @override
  Stream<SensorData> watchSensorData() => _datasource.watchSensorData();

  @override
  Future<Map<String, List<double>>> getChartData24Jam() =>
      _datasource.getChartData24Jam();
}