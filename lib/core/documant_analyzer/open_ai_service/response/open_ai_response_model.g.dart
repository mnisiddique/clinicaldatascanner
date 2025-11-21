// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_ai_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenAiResponseModel _$OpenAiResponseModelFromJson(Map<String, dynamic> json) =>
    OpenAiResponseModel(
      category: json['category'] as String,
      summary: json['summary'] as String,
      structuredData: json['structuredData'] as Map<String, dynamic>,
      rawDetectedTerms: (json['rawDetectedTerms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
