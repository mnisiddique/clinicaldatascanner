import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';
// import 'package:image/image.dart' as img;

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

@named
@Injectable(as: OCRService)
class TessaractImpl implements OCRService {
  @override
  Future<String> ocrText(String imagePath) async {
    String text = await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'ben+eng',
      args: {"psm": "4", "preserve_interword_spaces": "1"},
    );
    return text;
  }
}

@named
@Injectable(as: OCRService)
class TessaractBenOnlyImpl implements OCRService {
  @override
  Future<String> ocrText(String imagePath) async {
    String text = await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'ben',
      args: {"psm": "1", "preserve_interword_spaces": "1"},
    );
    return text;
  }
}
