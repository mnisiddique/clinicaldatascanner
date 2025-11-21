
import 'package:json_annotation/json_annotation.dart';
part 'open_ai_response_model.g.dart';

@JsonSerializable(createToJson: false)
class OpenAiResponseModel {
  final String category;
  final String summary;
  final Map<String, dynamic> structuredData;
  final List<String> rawDetectedTerms;

  OpenAiResponseModel({
    required this.category,
    required this.summary,
    required this.structuredData,
    required this.rawDetectedTerms,
  });

  factory OpenAiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OpenAiResponseModelFromJson(json);
}
  
