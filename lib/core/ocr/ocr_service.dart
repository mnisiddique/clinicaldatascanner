import 'dart:io';
import 'dart:typed_data';

import 'package:clinicaldatascanner/core/injector/module_registry.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

abstract class OCRService {
  Future<String> ocrText(String imagePath);
}

@named
@Injectable(as: OCRService)
class GoogleMLKitImpl implements OCRService {
  @override
  Future<String> ocrText(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final enTextRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await enTextRecognizer.processImage(
      inputImage,
    );

    enTextRecognizer.close();
    return recognizedText.text;
  }
}

// For preprocessing
@named
@Injectable(as: OCRService)
class EasyOCRImpl implements OCRService {
  final Interpreter _detector;
  final Interpreter _recognizer;
  final List<String> _bengaliChars; // Loaded char list
  // Optional: Map<String, double> _bengaliDict; // Load word probs if using dict

  EasyOCRImpl({
    @Named(kEasyOcrDetectorInterpreter) required Interpreter detector,
    @Named(kEasyOcrRecognizerInterpreter) required Interpreter recognizer,
    @Named(kBnChars) required List<String> bengaliChars,
  }) : _detector = detector,
       _recognizer = recognizer,
       _bengaliChars = bengaliChars;

  @override
  Future<String> ocrText(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    return recognizeBengaliText(bytes);
  }

  Future<String> recognizeBengaliText(Uint8List imageBytes) async {
    // Step 1: Preprocess full image for detector (608x608, RGB, float32, 0-1)
    final originalImage = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(originalImage, width: 608, height: 608);
    final detectorInput = _imageToByteListFloat32(resized); // [1, 608, 608, 3]

    // Step 2: CORRECT output buffer for Qualcomm EasyOCR detector
    // Shape: [1, 1, 5000] → flattened 5000 elements
    var detectorOutput = List<double>.filled(5000, 0.0).reshape([1, 1, 5000]);

    // Run detection
    _detector.run(detectorInput, detectorOutput);

    // Step 3: Parse real number of detections + bounding boxes
    // First value = number of valid detections
    final int numDetections = detectorOutput[0][0][0].toInt().clamp(0, 1000);

    String extractedText = '';

    for (int i = 0; i < numDetections; i++) {
      // Each detection uses 8 values starting at index 5 + i*8
      final int baseIdx = 5 + i * 8;

      final double conf =
          detectorOutput[0][0][baseIdx +
              4]; // confidence is 5th value in the 8-tuple

      if (conf < 0.5) continue; // confidence threshold

      // Coordinates are normalized [0-1] → scale to original image size
      final double x1 = detectorOutput[0][0][baseIdx + 0] * originalImage.width;
      final double y1 =
          detectorOutput[0][0][baseIdx + 1] * originalImage.height;
      final double x2 = detectorOutput[0][0][baseIdx + 2] * originalImage.width;
      final double y2 =
          detectorOutput[0][0][baseIdx + 3] * originalImage.height;

      // Crop the detected text region
      final cropBytes = _cropImageFromCoords(
        imageBytes,
        x1.toInt(),
        y1.toInt(),
        (x2 - x1).toInt(),
        (y2 - y1).toInt(),
      );

      if (cropBytes.isEmpty) continue;

      // Step 4: Prepare crop for recognizer (32x128 grayscale)
      final cropInput = _preprocessCrop(img.decodeImage(cropBytes)!);

      // Step 5: Recognizer output buffer (adjust num_chars if you expanded the char list)
      final int numChars = _bengaliChars.length;
      var recognizerOutput = List.filled(
        1 * 32 * 128 * numChars,
        0.0,
      ).reshape([1, 32, 128, numChars]);

      _recognizer.run(cropInput, recognizerOutput);

      // Step 6: Decode Bengali text
      final String recognized = _decodeBengali(recognizerOutput[0]);
      if (recognized.trim().isNotEmpty) {
        extractedText += '$recognized ';
      }
    }

    return extractedText.trim();
  }

  Uint8List _cropImageFromCoords(Uint8List bytes, int x, int y, int w, int h) {
    try {
      final image = img.decodeImage(bytes)!;
      final cropped = img.copyCrop(
        image,
        x: x.clamp(0, image.width - 1),
        y: y.clamp(0, image.height - 1),
        width: w.clamp(1, image.width - x),
        height: h.clamp(1, image.height - y),
      );
      return Uint8List.fromList(img.encodePng(cropped));
    } catch (e) {
      return Uint8List(0);
    }
  }

  // Helper: Image to float32 input for detector
  Float32List _imageToByteListFloat32(img.Image image) {
    var convertedBytes = Float32List(1 * 608 * 608 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (int i = 0; i < 608 * 608; i++) {
      var pixel = image.getPixel(i % 608, i ~/ 608);
      buffer[pixelIndex++] = (pixel.r / 255.0);
      buffer[pixelIndex++] = (pixel.g / 255.0);
      buffer[pixelIndex++] = (pixel.b / 255.0);
    }
    return convertedBytes;
  }

  // Preprocess crop for recognizer: Grayscale, resize 32x128, normalize
  Float32List _preprocessCrop(img.Image crop) {
    crop = img.grayscale(crop);
    crop = img.copyResize(crop, width: 128, height: 32);
    var convertedBytes = Float32List(1 * 32 * 128 * 1); // Grayscale
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (int i = 0; i < 32 * 128; i++) {
      buffer[pixelIndex++] =
          (crop.getPixel(i % 128, i ~/ 128).r /
          255.0); // Use red channel for grayscale
    }
    return convertedBytes;
  }

  // Decode logits to Bengali text (simplified CTC; use a lib like ctcdecode for prod)
  String _decodeBengali(List<List<List<double>>> logits) {
    // logits shape: [height=32, width=128, num_chars]
    StringBuffer result = StringBuffer();
    int lastCharIdx = -1;

    for (int h = 0; h < logits.length; h++) {
      int maxIdx = 0;
      double maxVal = -double.infinity;

      for (int c = 0; c < logits[h][0].length; c++) {
        final val = logits[h].expand((x) => x).toList()[c]; // flatten width dim
        if (val > maxVal) {
          maxVal = val;
          maxIdx = c;
        }
      }

      // Skip blank (usually index 0) and avoid duplicates
      if (maxIdx > 0 && maxIdx != lastCharIdx) {
        result.write(_bengaliChars[maxIdx]);
        lastCharIdx = maxIdx;
      }
    }

    return result.toString();
  }
}
