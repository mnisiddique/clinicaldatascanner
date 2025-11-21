abstract class DocumentAnalyzer {
  Future<String> analyze(String scannedText);
}

class ChatGPTAnalyzer implements DocumentAnalyzer {
  @override
  Future<String> analyze(String scannedText) async {
    // Implement the logic to call ChatGPT API and extract data
    // For demonstration, returning a dummy response
    return "Extracted Data from ChatGPT for: $scannedText";
  }
}
