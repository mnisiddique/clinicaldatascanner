import 'dart:io';

import 'package:injectable/injectable.dart';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

@Injectable()
class ImageProcessor {
  Future<img.Image?> toGrayScale(String imagePath) async {
    final original = await img.decodeImageFile(imagePath);
    if (original == null) return null;

    // Target max size for processing (example: 1500px)
    const maxSide = 1500;

    // Determine scale factor
    final scale = (original.width > original.height)
        ? original.width / maxSide
        : original.height / maxSide;

    // If image already small, skip resizing
    img.Image resizedImage;
    if (scale > 1) {
      resizedImage = img.copyResize(
        original,
        width: (original.width / scale).round(),
        height: (original.height / scale).round(),
      );
    } else {
      resizedImage = original;
    }

    // Convert to grayscale
    final grayscale = img.grayscale(resizedImage);
    return grayscale;
  }

  img.Image threshold(img.Image input, {int threshold = 200}) {
    final output = img.Image.from(input);

    for (int y = 0; y < input.height; y++) {
      for (int x = 0; x < input.width; x++) {
        final lum = img.getLuminance(input.getPixel(x, y)).toInt();
        if (lum > threshold) {
          output.setPixel(x, y, img.ColorRgb8(255, 255, 255)); // white
        } else {
          output.setPixel(x, y, img.ColorRgb8(0, 0, 0)); // black
        }
      }
    }
    return output;
  }

  Future<img.Image?> removeBg(String imagePath) async {
    // 1️⃣ Convert to grayscale with resizing
    final grayScale = await toGrayScale(imagePath);
    if (grayScale == null) return null;

    // 2️⃣ Option A: Fast threshold (very fast, good for printed text)
    final mask = threshold(grayScale, threshold: 200); // white bg
    final fastOutput = img.Image.from(mask);

    return fastOutput;
  }

  Future<String> saveImageToFile(img.Image image, String dirPath) async {
    // Encode the image as PNG (you can use JpegEncoder as well)
    final pngBytes = img.encodePng(image);
    final cacheDir = await getTemporaryDirectory(); // app cache directory

    final filePath =
        '${cacheDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(pngBytes);

    return file.path; // return final saved file path
  }
}
