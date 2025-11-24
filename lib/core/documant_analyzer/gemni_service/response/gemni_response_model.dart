import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'gemni_response_model.g.dart';

@JsonSerializable(createToJson: false)
class GemniApiResponse {
  final List<Candidate>? candidates;
  final UsageMetadata? usageMetadata;
  final String? modelVersion;
  final String? responseId;

  GemniApiResponse({
    this.candidates,
    this.usageMetadata,
    this.modelVersion,
    this.responseId,
  });

  factory GemniApiResponse.fromJson(Map<String, dynamic> json) =>
      _$GemniApiResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class Candidate {
  final Content? content;
  final String? finishReason;
  final int? index;

  Candidate({this.content, this.finishReason, this.index});

  factory Candidate.fromJson(Map<String, dynamic> json) =>
      _$CandidateFromJson(json);
}

@JsonSerializable(createToJson: false)
class Content {
  final List<Part>? parts;
  final String? role;

  Content({this.parts, this.role});

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}

@JsonSerializable(createToJson: false)
class Part {
  final String? text;

  Part({this.text});

  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
}

@JsonSerializable(createToJson: false)
class UsageMetadata {
  final int? promptTokenCount;
  final int? candidatesTokenCount;
  final int? totalTokenCount;

  UsageMetadata({
    this.promptTokenCount,
    this.candidatesTokenCount,
    this.totalTokenCount,
  });

  factory UsageMetadata.fromJson(Map<String, dynamic> json) =>
      _$UsageMetadataFromJson(json);
}

@JsonSerializable(createToJson: false)
class GemniResponseModel {
  final String oneLineSummary;
  final String type;
  final bool isMedicalRecord;

  GemniResponseModel({
    required this.oneLineSummary,
    required this.type,
    required this.isMedicalRecord,
  });

  factory GemniResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GemniResponseModelFromJson(json);

  factory GemniResponseModel.fromRawResponse(GemniApiResponse response) {
    final part = response.candidates?.first.content?.parts?.first.text ?? '';
    final model = GemniResponseModel.fromJson(jsonDecode(part));
    return model;
  }
}
