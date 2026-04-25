import '../../domain/entities/sensor_data.dart';

/// Model dengan kemampuan serialisasi JSON
/// Siap untuk Firebase RTDB nanti
class SensorModel extends SensorData {
  const SensorModel({
    required super.suhu,
    required super.kelembapanUdara,
    required super.kelembapanTanah,
    required super.statusTanaman,
    required super.lastUpdated,
    required super.isOnline,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) {
    return SensorModel(
      suhu: (json['suhu'] as num).toDouble(),
      kelembapanUdara: (json['kelembapan_udara'] as num).toDouble(),
      kelembapanTanah: (json['kelembapan_tanah'] as num).toDouble(),
      statusTanaman: json['status_tanaman'] as String? ?? 'Tidak diketahui',
      lastUpdated: json['last_updated'] as String? ?? '-',
      isOnline: json['is_online'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'suhu': suhu,
        'kelembapan_udara': kelembapanUdara,
        'kelembapan_tanah': kelembapanTanah,
        'status_tanaman': statusTanaman,
        'last_updated': lastUpdated,
        'is_online': isOnline,
      };

  factory SensorModel.fromEntity(SensorData entity) {
    return SensorModel(
      suhu: entity.suhu,
      kelembapanUdara: entity.kelembapanUdara,
      kelembapanTanah: entity.kelembapanTanah,
      statusTanaman: entity.statusTanaman,
      lastUpdated: entity.lastUpdated,
      isOnline: entity.isOnline,
    );
  }
}