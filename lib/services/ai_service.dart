import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:onnxruntime/onnxruntime.dart';

class AIService {
  OrtSession? _session;

  // ResNet18 verwacht 224x224
  static const int inputSize = 224;

  // Volgorde moet exact matchen met training
  static const List<String> _ids = [
    'cable_flyes',
    'incline_benchpress',
    'machine_pulldown',
    'pullup',
    'romanian_deadlift',
    'squats',
  ];

  // Mooie namen voor UI (optioneel)
  static const List<String> _labels = [
    'Cable flyes',
    'Incline benchpress',
    'Machine pulldown',
    'Pull up',
    'Romanian deadlift',
    'Squats',
  ];

  Future<void> loadModel() async {
    if (_session != null) return;

    final bytes = await rootBundle.load('assets/model/fitness_resnet18.onnx');
    final options = OrtSessionOptions();

    _session = await OrtSession.fromBuffer(bytes.buffer.asUint8List(), options);
  }

  Future<Map<String, dynamic>> predict(String imagePath) async {
    if (_session == null) {
      throw StateError("Model not loaded. Call loadModel() first.");
    }

    // 1) Decode image
    final imageBytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw StateError("Kon afbeelding niet decoden.");
    }

    // 2) Resize
    final resized = img.copyResize(
      decoded,
      width: inputSize,
      height: inputSize,
    );

    // 3) CHW Float32 tensor [1,3,224,224] met 0..1 scaling
    final input = Float32List(1 * 3 * inputSize * inputSize);
    final planeSize = inputSize * inputSize;

    final offsetR = 0;
    final offsetG = planeSize;
    final offsetB = planeSize * 2;

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        // image v4: gebruik pixel object + r/g/b getters
        final p = resized.getPixel(x, y);
        final idx = y * inputSize + x;

        input[offsetR + idx] = p.r / 255.0;
        input[offsetG + idx] = p.g / 255.0;
        input[offsetB + idx] = p.b / 255.0;
      }
    }

    // 4) Run inference
    final inputTensor = OrtValueTensor.createTensorWithDataList(input, [
      1,
      3,
      inputSize,
      inputSize,
    ]);

    final outputs = _session!.run(OrtRunOptions(), {'input': inputTensor});

    // outputs is List<OrtValue?>, eerste output bevat logits [1,6]
    final out0 = outputs[0];
    if (out0 == null) {
      inputTensor.release();
      throw StateError("ONNX output was null.");
    }

    final raw = out0.value as List; // shape [1,6]
    final logitsList = raw[0] as List; // shape [6]
    final logits = logitsList.map((e) => (e as num).toDouble()).toList();

    // 5) softmax + argmax
    final probs = _softmax(logits);

    int bestIdx = 0;
    double bestProb = probs[0];
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > bestProb) {
        bestProb = probs[i];
        bestIdx = i;
      }
    }

    // cleanup
    inputTensor.release();
    for (final o in outputs) {
      o?.release();
    }

    // Return blijft compatibel met jouw UI:
    // - label (string)
    // - confidence (double 0..1)
    return {
      "label": _ids[bestIdx], // ✅ handig voor assets: assets/images/<id>.png
      "confidence": bestProb,
      "prettyLabel": _labels[bestIdx], // optioneel voor display
    };
  }

  List<double> _softmax(List<double> x) {
    final maxVal = x.reduce(max);
    final exps = x.map((v) => exp(v - maxVal)).toList();
    final sumExp = exps.reduce((a, b) => a + b);
    return exps.map((v) => v / sumExp).toList();
  }
}
