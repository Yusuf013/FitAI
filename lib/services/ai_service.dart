import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class AIService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model/model.tflite');

    print("INPUT SHAPE: ${_interpreter.getInputTensor(0).shape}");
    print("INPUT TYPE: ${_interpreter.getInputTensor(0).type}");
  }

  Future<Map<String, dynamic>> predict(String imagePath) async {
    // FOTO INLADEN
    final imageBytes = await File(imagePath).readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    // MODEL VERWACHT 244x244
    const int inputSize = 244;

    final resized = img.copyResize(image!, width: inputSize, height: inputSize);

    // CHW TENSOR MAKEN
    // shape → [1, 3, 244, 244]
    List<List<List<List<double>>>> input = [
      List.generate(
        3,
        (_) => List.generate(inputSize, (_) => List.filled(inputSize, 0.0)),
      ),
    ];

    for (int c = 0; c < 3; c++) {
      for (int y = 0; y < inputSize; y++) {
        for (int x = 0; x < inputSize; x++) {
          final pixel = resized.getPixel(x, y);

          if (c == 0) input[0][0][y][x] = pixel.r / 255.0; // R
          if (c == 1) input[0][1][y][x] = pixel.g / 255.0; // G
          if (c == 2) input[0][2][y][x] = pixel.b / 255.0; // B
        }
      }
    }

    // OUTPUT BUFFER (bij jou 6 classes)
    var output = List.filled(6, 0.0).reshape([1, 6]);

    // INFERENTIE DRAAIEN
    _interpreter.run(input, output);

    // BESTE SCORE BEREKENEN
    double maxConfidence = -1;
    int bestIndex = -1;

    for (int i = 0; i < 6; i++) {
      if (output[0][i] > maxConfidence) {
        maxConfidence = output[0][i];
        bestIndex = i;
      }
    }

    List<String> labels = [
      'Cable fy',
      'Incline benchpress',
      'Machine pulldown',
      'Pull ups',
      'Romanian deadlift',
      'Squats',
    ];

    return {"label": labels[bestIndex], "confidence": maxConfidence};
  }
}
