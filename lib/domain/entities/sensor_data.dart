/// Pure Dart entity — tidak bergantung pada Flutter/Firebase
class SensorData {
  final double suhu;
  final double kelembapanUdara;
  final double kelembapanTanah;
  final String statusTanaman;
  final String lastUpdated;
  final bool isOnline;

  const SensorData({
    required this.suhu,
    required this.kelembapanUdara,
    required this.kelembapanTanah,
    required this.statusTanaman,
    required this.lastUpdated,
    required this.isOnline,
  });

  SensorData copyWith({
    double? suhu,
    double? kelembapanUdara,
    double? kelembapanTanah,
    String? statusTanaman,
    String? lastUpdated,
    bool? isOnline,
  }) {
    return SensorData(
      suhu: suhu ?? this.suhu,
      kelembapanUdara: kelembapanUdara ?? this.kelembapanUdara,
      kelembapanTanah: kelembapanTanah ?? this.kelembapanTanah,
      statusTanaman: statusTanaman ?? this.statusTanaman,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  String toString() => 'SensorData(suhu: $suhu, '
      'kelembapanUdara: $kelembapanUdara, '
      'kelembapanTanah: $kelembapanTanah, '
      'status: $statusTanaman)';
}