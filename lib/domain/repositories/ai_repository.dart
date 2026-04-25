import '../entities/hama_result.dart';

/// Abstract interface untuk AI layer
/// Implementasi: DummyAISource → TFLiteAISource
abstract class AIRepository {
  /// Analisis gambar daun dan kembalikan hasil
  /// [imagePath] → path file gambar
  Future<HamaResult> analyzeLeaf(String imagePath);
}