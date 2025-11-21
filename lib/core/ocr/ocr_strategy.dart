import 'package:clinicaldatascanner/core/ocr/ocr_service.dart';
import 'package:injectable/injectable.dart';

abstract class OcrStrategy {
  Future<String> ocrText(String imagePath);
}

@Injectable(as: OcrStrategy)
class OcrStrategyImpl implements OcrStrategy {
  final OCRService mlkitService;

  OcrStrategyImpl({@Named.from(GoogleMLKitImpl) required this.mlkitService});

  @override
  Future<String> ocrText(String imagePath) async {
    // Implement OCR logic here
    return mlkitService.ocrText(imagePath);
  }
}
