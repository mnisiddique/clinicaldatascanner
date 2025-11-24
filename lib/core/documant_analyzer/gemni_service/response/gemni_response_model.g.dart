// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemni_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GemniApiResponse _$GemniApiResponseFromJson(Map<String, dynamic> json) =>
    GemniApiResponse(
      candidates: (json['candidates'] as List<dynamic>?)
          ?.map((e) => Candidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      usageMetadata: json['usageMetadata'] == null
          ? null
          : UsageMetadata.fromJson(
              json['usageMetadata'] as Map<String, dynamic>,
            ),
      modelVersion: json['modelVersion'] as String?,
      responseId: json['responseId'] as String?,
    );

Candidate _$CandidateFromJson(Map<String, dynamic> json) => Candidate(
  content: json['content'] == null
      ? null
      : Content.fromJson(json['content'] as Map<String, dynamic>),
  finishReason: json['finishReason'] as String?,
  index: (json['index'] as num?)?.toInt(),
);

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
  parts: (json['parts'] as List<dynamic>?)
      ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
      .toList(),
  role: json['role'] as String?,
);

Part _$PartFromJson(Map<String, dynamic> json) =>
    Part(text: json['text'] as String?);

UsageMetadata _$UsageMetadataFromJson(Map<String, dynamic> json) =>
    UsageMetadata(
      promptTokenCount: (json['promptTokenCount'] as num?)?.toInt(),
      candidatesTokenCount: (json['candidatesTokenCount'] as num?)?.toInt(),
      totalTokenCount: (json['totalTokenCount'] as num?)?.toInt(),
    );

GemniResponseModel _$GemniResponseModelFromJson(Map<String, dynamic> json) =>
    GemniResponseModel(
      oneLineSummary: json['oneLineSummary'] as String,
      type: json['type'] as String,
      isMedicalRecord: json['isMedicalRecord'] as bool,
    );
