import '../../../core/constants/dummy_data.dart';
import '../../../domain/entities/hama_result.dart';

/// Dummy AI datasource
/// Nanti akan diganti TFLiteAIDatasource
class DummyAIDatasource {
  Future<HamaResult> analyzeLeaf(String imagePath) async {
    // Simulasi waktu inferensi model AI
    await Future.delayed(const Duration(seconds: 2));
    return DummyData.hamaResult;
  }
}

/// Komentar integrasi TFLite nanti:
///
/// class TFLiteAIDatasource {
///   late Interpreter _cnnInterpreter;
///   late Interpreter _rfInterpreter;
///
///   Future<void> loadModels() async {
///     _cnnInterpreter = await Interpreter.fromAsset('models/cnn_leaf.tflite');
///     _rfInterpreter = await Interpreter.fromAsset('models/rf_hama.tflite');
///   }
///
///   Future<HamaResult> analyzeLeaf(String imagePath) async {
///     // 1. CNN → klasifikasi daun
///     final leafCondition = await _runCNN(imagePath);
///     // 2. Random Forest → prediksi hama
///     final hamaResult = await _runRandomForest(leafCondition, sensorData);
///     return hamaResult;
///   }
/// }