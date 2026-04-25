import '../../domain/entities/hama_result.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/local/dummy_ai_datasource.dart';

class AIRepositoryImpl implements AIRepository {
  final DummyAIDatasource _datasource;

  AIRepositoryImpl({DummyAIDatasource? datasource})
      : _datasource = datasource ?? DummyAIDatasource();

  @override
  Future<HamaResult> analyzeLeaf(String imagePath) =>
      _datasource.analyzeLeaf(imagePath);
}