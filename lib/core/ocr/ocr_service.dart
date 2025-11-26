import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:injectable/injectable.dart';

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
    return await FlutterTesseractOcr.extractText(
      imagePath,
      language: 'ben+eng', // use multiple languages
      args: {"preserve_interword_spaces": "1"},
    );
  }
}
