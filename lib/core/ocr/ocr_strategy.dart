import 'dart:io';

import 'package:clinicaldatascanner/core/ocr/ocr_service.dart';
import 'package:injectable/injectable.dart';
import 'package:image/image.dart' as img;

abstract class OcrStrategy {
  Future<String> ocrText(String imagePath);
}

@Injectable(as: OcrStrategy)
class OcrStrategyImpl implements OcrStrategy {
  final OCRService mlkitService;
  final OCRService tesseractService;

  OcrStrategyImpl({
    @Named.from(GoogleMLKitImpl) required this.mlkitService,
    @Named.from(TessaractImpl) required this.tesseractService,
  });

  img.Image applyThreshold(img.Image image, int threshold) {
    final thr = threshold.clamp(0, 255);

    // getPixel returns a Pixel object in image 4.x
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y); // Pixel

        // Pixel exposes r,g,b,a as numbers (num). Convert to int.
        final int r = (pixel.r).round();
        final int g = (pixel.g).round();
        final int b = (pixel.b).round();

        // Compute luminance (BT.601)
        final int lum = ((0.299 * r) + (0.587 * g) + (0.114 * b)).round();

        if (lum > thr) {
          // white, fully opaque
          image.setPixelRgba(x, y, 255, 255, 255, 255);
        } else {
          // black, fully opaque
          image.setPixelRgba(x, y, 0, 0, 0, 255);
        }
      }
    }

    return image;
  }

  Future<String> preprocessImage(String path) async {
    final bytes = await File(path).readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    // 1. Convert to grayscale
    image = img.grayscale(image!);

    // 2. Increase contrast
    image = img.contrast(image, contrast: 150); // adjust 100–200

    // 3. Apply threshold for better edges
    image = applyThreshold(image, 140); // adjust 120–180

    // Save processed file
    final newPath = path.replaceAll(".jpg", "_processed.jpg");
    File(newPath).writeAsBytesSync(img.encodeJpg(image, quality: 90));

    return newPath;
  }

  @override
  Future<String> ocrText(String imagePath) async {
    // Implement OCR logic here
    final preprocessedPath = await preprocessImage(imagePath);
    final bengaliText = await tesseractService.ocrText(preprocessedPath);
    return bengaliText;
    // final englishText = await mlkitService.ocrText(imagePath);
    // final bengaliText = await tesseractService.ocrText(imagePath);
    // return '$bengaliText\n$englishText';
  }
}
