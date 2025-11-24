import 'package:clinicaldatascanner/core/documant_analyzer/document_analyzer.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/gemni_service/api/gemni_api_service.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/gemni_service/request/gemni_request_model.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/gemni_service/response/gemni_response_model.dart';
import 'package:injectable/injectable.dart';

const String skGemniApiKey = String.fromEnvironment('gemniTrialApiKey');

@Injectable(as: DocumentAnalyzer<GemniResponseModel>)
class GemniAnalyzer implements DocumentAnalyzer<GemniResponseModel> {
  final GemniApiService gemniApiService;
  GemniAnalyzer({required this.gemniApiService});
  @override
  Future<GemniResponseModel> analyze(String ocrText) async {
    final request = GemniRequestModel.fromOcrText(ocrText);
    final response = await gemniApiService.askGemni(request, skGemniApiKey);

    return GemniResponseModel.fromRawResponse(response);
  }
}
