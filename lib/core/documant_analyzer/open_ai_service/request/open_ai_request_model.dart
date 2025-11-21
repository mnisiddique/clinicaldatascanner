import 'package:json_annotation/json_annotation.dart';

part 'open_ai_request_model.g.dart';

@JsonSerializable(createFactory: false)
class OpenAiRequestModel {
  final String model;
  final List<MessageModel> messages;

  OpenAiRequestModel({
    required this.model,
    required this.messages,
  });

  Map<String, dynamic> toJson() => _$OpenAiRequestModelToJson(this);
}

@JsonSerializable(createFactory: false)
class MessageModel {
  final String role;
  final String content;

  MessageModel({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
 
}