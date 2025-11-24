
import 'package:clinicaldatascanner/core/documant_analyzer/gemni_service/request/gemni_request_model.dart';
import 'package:clinicaldatascanner/core/documant_analyzer/gemni_service/response/gemni_response_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'gemni_api_service.g.dart';

@Injectable()
@RestApi(headers: headers, baseUrl: _gemniApiUrl)
abstract class GemniApiService {
  @factoryMethod
  factory GemniApiService(Dio dio) = _GemniApiService;

  @POST('/v1beta/models/gemini-2.5-pro:generateContent')
  Future<GemniApiResponse> askGemni(@Body() GemniRequestModel request, @Query('key') String apiKey);
}

const Map<String, dynamic> headers = {
  'Content-Type': 'application/json',
  'accept': '*/*',
};

const String _gemniApiUrl = "https://generativelanguage.googleapis.com";
