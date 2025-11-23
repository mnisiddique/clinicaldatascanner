import 'package:clinicaldatascanner/core/documant_analyzer/open_ai_service/request/open_ai_request_model.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/open_ai_service/response/open_ai_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part 'open_ai_api_service.g.dart';

@Injectable()
@RestApi(headers: headers, baseUrl: openAIApiUrl)
abstract class OpenAiApiService {
  @factoryMethod
  factory OpenAiApiService(Dio dio) = _OpenAiApiService;

  @POST('/v1/chat/completions')
  Future<OpenAiResponseModel> askChatGpt(@Body() OpenAiRequestModel request);
}

const Map<String, dynamic> headers = {
  'Content-Type': 'application/json',
  'accept': '*/*',
  "Authorization": "Bearer $alebele",
};

const String openAIApiUrl = "https://api.openai.com";

const String alebele = String.fromEnvironment(
  'aelebele',
  defaultValue: '',
);
