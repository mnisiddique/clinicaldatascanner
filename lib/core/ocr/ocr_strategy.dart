import 'package:clinicaldatascanner/core/image_preprocessor/image_processor.dart';
import 'package:clinicaldatascanner/core/ocr/ocr_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img show Image;
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

enum OcrEngine { mlKit, tessaract, combined }

abstract class OcrStrategy {
  Future<OcrResult> ocrText(
    String imagePath, [
    OcrEngine strategy = OcrEngine.combined,
  ]);
}

// const String _kDirPath = 'dirPath';
const String _kImagePath = 'imagePath';

class OcrResult {
  final String text;
  final String image;

  OcrResult({required this.text, required this.image});
}

@Injectable(as: OcrStrategy)
class OcrStrategyImpl implements OcrStrategy {
  final OCRService mlkitService;
  final OCRService tessaractOcrService;
  final OCRService tessaractBenOcrService;
  final ImageProcessor imageProcessor;

  OcrStrategyImpl({
    @Named.from(GoogleMLKitImpl) required this.mlkitService,
    @Named.from(TessaractImpl) required this.tessaractOcrService,
    @Named.from(TessaractBenOnlyImpl) required this.tessaractBenOcrService,
    required this.imageProcessor,
  });

  Future<img.Image> computeOcr(Map<String, String> params) async {
    final processedImage = await imageProcessor.removeBg(params[_kImagePath]!);
    if (processedImage == null) {
      throw Exception('Image processing failed');
    }
    return processedImage;
  }

  @override
  Future<OcrResult> ocrText(
    String imagePath, [
    OcrEngine strategy = OcrEngine.combined,
  ]) async {
    switch (strategy) {
      case OcrEngine.mlKit:
        final text = await mlkitService.ocrText(imagePath);
        return OcrResult(text: text, image: imagePath);
      case OcrEngine.tessaract:
        final processedImage = await compute(computeOcr, {
          _kImagePath: imagePath,
        });
        final dirPath = (await getTemporaryDirectory()).path;
        final processedImagePath = await imageProcessor.saveImageToFile(
          processedImage,
          dirPath,
        );

        final text = await tessaractOcrService.ocrText(processedImagePath);
        return OcrResult(text: text, image: processedImagePath);
      case OcrEngine.combined:
        final processedImage = await compute(computeOcr, {
          _kImagePath: imagePath,
        });
        final dirPath = (await getTemporaryDirectory()).path;
        final processedImagePath = await imageProcessor.saveImageToFile(
          processedImage,
          dirPath,
        );
        final result = await Future.wait([
          tessaractBenOcrService.ocrText(processedImagePath),
          mlkitService.ocrText(imagePath),
        ]);

        return OcrResult(
          text: '${result[0]}\n${result[1]}',
          image: processedImagePath,
        );
        
    }

    // final englishText = await mlkitService.ocrText(imagePath);
    // final bengaliText = await easyOcrService.ocrText(imagePath);
    // return '$bengaliText\n$englishText';
  }
}
