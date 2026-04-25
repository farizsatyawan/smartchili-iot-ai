import '../../domain/entities/hama_result.dart';

class HamaResultModel extends HamaResult {
  const HamaResultModel({
    required super.kondisiDaun,
    required super.jenisHama,
    required super.confidence,
    required super.levelRisiko,
    required super.mitigasi,
    super.analyzedAt,
  });

  factory HamaResultModel.fromJson(Map<String, dynamic> json) {
    return HamaResultModel(
      kondisiDaun: json['kondisi_daun'] as String,
      jenisHama: json['jenis_hama'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      levelRisiko: _parseRisiko(json['level_risiko'] as String),
      mitigasi: json['mitigasi'] as String,
      analyzedAt: json['analyzed_at'] != null
          ? DateTime.parse(json['analyzed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'kondisi_daun': kondisiDaun,
        'jenis_hama': jenisHama,
        'confidence': confidence,
        'level_risiko': levelRisiko.shortLabel,
        'mitigasi': mitigasi,
        'analyzed_at': analyzedAt?.toIso8601String(),
      };

  static RisikoLevel _parseRisiko(String value) {
    switch (value.toLowerCase()) {
      case 'high':
        return RisikoLevel.high;
      case 'medium':
        return RisikoLevel.medium;
      default:
        return RisikoLevel.low;
    }
  }
}