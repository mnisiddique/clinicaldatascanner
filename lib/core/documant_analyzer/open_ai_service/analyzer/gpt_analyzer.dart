import 'package:clinicaldatascanner/core/documant_analyzer/document_analyzer.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/open_ai_service/api_service/open_ai_api_service.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/open_ai_service/request/open_ai_request_model.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/open_ai_service/response/open_ai_response_model.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: DocumentAnalyzer<OpenAiResponseModel>)
class ChatGPTAnalyzer implements DocumentAnalyzer<OpenAiResponseModel> {
  final OpenAiApiService openAiApiService;

  ChatGPTAnalyzer({required this.openAiApiService});
  @override
  Future<OpenAiResponseModel> analyze(String ocrText) async {
    final request = OpenAiRequestModel(
      model: _kGPT3TURBO,
      messages: [
        MessageModel(role: _kSystem, content: _kPrompt),
        MessageModel(role: _kUser, content: ocrText),
      ],
    );
    return await openAiApiService.askChatGpt(request);
  }
}

// const String _kGPT40MINI = "gpt-4o-mini";
const String _kGPT3TURBO = "gpt-3.5-turbo";
const String _kSystem = "system";
const String _kUser = "user";
const String _kPrompt = """
You are a medical document nalyzer.

Task:
1. Determine whether the input text belongs to any medical domain:
   - prescription
   - lab test report
   - discharge summary
   - diagnostic report
   - radiology report
   - medical invoice
   - hospital admission paper
   - doctor notes
   - not medical

2. If the text is medical, extract structured data:
   - patient info (name, age, gender, ID)
   - doctor info (name, registration number)
   - hospital/clinic info
   - diagnosis
   - symptoms
   - medicines (name, dose, frequency, duration)
   - lab test names
   - lab test values with units and reference ranges
   - date
   - any other medically relevant info

3. If text is not medical, return: "Not a medical document."

4. Output JSON with fields:
{
  "category": "",
  "summary": "",
  "structured_data": { ... },
  "raw_detected_terms": []
}

Ensure you never hallucinate missing values. If something doesn't exist, use null.
""";
