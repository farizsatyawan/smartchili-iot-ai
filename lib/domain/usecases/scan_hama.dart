import '../entities/hama_result.dart';
import '../repositories/ai_repository.dart';

class ScanHama {
  final AIRepository repository;

  ScanHama(this.repository);

  Future<HamaResult> call(String imagePath) =>
      repository.analyzeLeaf(imagePath);
}