
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class ImageTextScanner {
  Future<String> scanImageFromText(String imagePath);
}

class GoogleMLKitScanner implements ImageTextScanner {
  @override
  Future<String> scanImageFromText(String imagePath) async {
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

ImageTextScanner get mlkitScanner => GoogleMLKitScanner();
