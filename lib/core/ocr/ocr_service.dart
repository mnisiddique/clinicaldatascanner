import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class OCRService {
  Future<String> ocrText(String imagePath);
}

class GoogleMLKitImpl implements OCRService {
  @override
  Future<String> ocrText(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(
      Uri.parse(imagePath).toFilePath(),
    );
    final enTextRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await enTextRecognizer.processImage(
      inputImage,
    );

    enTextRecognizer.close();
    return recognizedText.text;
  }
}

OCRService get mlkitScanner => GoogleMLKitImpl();
