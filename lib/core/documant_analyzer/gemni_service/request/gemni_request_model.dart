import 'package:json_annotation/json_annotation.dart';

part 'gemni_request_model.g.dart';

@JsonSerializable(createFactory: false)
class GemniRequestModel {
  final List<Content> contents;

  GemniRequestModel({required this.contents});

  factory GemniRequestModel.fromOcrText(String ocrText) {
    return GemniRequestModel(
      contents: [
        Content(parts: [Part(text: getPromptTemplate(ocrText))]),
      ],
    );
  }

  Map<String, dynamic> toJson() => _$GemniRequestModelToJson(this);
}

@JsonSerializable(createFactory: false)
class Content {
  final List<Part> parts;

  Content({required this.parts});

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable(createFactory: false)
class Part {
  final String text;

  Part({required this.text});

  Map<String, dynamic> toJson() => _$PartToJson(this);
}

 String getPromptTemplate (String ocrText) => "You are a strict classifier. Analyze the following OCR jumbled text and determine if it is related to a medical or health document. If medical, classify into one: Prescription, LabReport, DiagnosticReport, HospitalForm, or OtherMedical. Then create a one-line summary. Respond ONLY with a pure JSON object.Do NOT use code blocks.Do NOT use backticks.Do NOT add explanation, comments, or extra text.Return ONLY this exact JSON format::\n\n{ \"isMedicalRecord\": true/false, \"type\": \"Prescription/LabReport/etc\", \"oneLineSummary\": \"...\" }\n\nOCR_TEXT:\n$ocrText";