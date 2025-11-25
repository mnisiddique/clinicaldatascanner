import 'package:clinicaldatascanner/core/ocr/ocr_service.dart';
import 'package:injectable/injectable.dart';

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

  @override
  Future<String> ocrText(String imagePath) async {
    // Implement OCR logic here
    final englishText = await mlkitService.ocrText(imagePath);
    final bengaliText = await tesseractService.ocrText(imagePath);
    return '$bengaliText\n$englishText';
  }
}
