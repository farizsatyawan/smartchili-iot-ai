import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class TfliteAiDatasource {
  late Interpreter _interpreter;

  // 🔹 Label sesuai dataset kamu
  final List<String> labels = ['bercak', 'keriting', 'menguning'];

  /// 🔥 Load model
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
    print('✅ Model loaded');
  }

  /// 🔥 Prediksi gambar (UPDATED: pakai confidence)
  Future<Map<String, dynamic>> predict(File imageFile) async {
    // 1. Baca image
    final bytes = await imageFile.readAsBytes();
    img.Image? oriImage = img.decodeImage(bytes);

    if (oriImage == null) {
      throw Exception("Gagal membaca gambar");
    }

    // 2. Resize ke 150x150
    img.Image resized = img.copyResize(oriImage, width: 150, height: 150);

    // 3. Convert ke tensor
    var input = List.generate(
      1,
      (_) => List.generate(
        150,
        (y) => List.generate(
          150,
          (x) {
            final pixel = resized.getPixel(x, y);

            final r = pixel.r / 255.0;
            final g = pixel.g / 255.0;
            final b = pixel.b / 255.0;

            return [r, g, b];
          },
        ),
      ),
    );

    // 4. Output tensor
    var output = List.filled(3, 0.0).reshape([1, 3]);

    // 5. Run inference
    _interpreter.run(input, output);

    // 6. Ambil hasil
    List<double> result = output[0];

    int maxIndex = 0;
    double maxValue = result[0];

    for (int i = 1; i < result.length; i++) {
      if (result[i] > maxValue) {
        maxValue = result[i];
        maxIndex = i;
      }
    }

    print("🔍 Output: $result");
    print("🏷️ Label: ${labels[maxIndex]}");
    print("📊 Confidence: $maxValue");

    // 🔥 RETURN BARU
    return {
      "label": labels[maxIndex],
      "confidence": maxValue, // 0.0 - 1.0
    };
  }
}