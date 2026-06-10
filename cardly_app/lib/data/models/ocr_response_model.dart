import 'package:json_annotation/json_annotation.dart';

part 'ocr_response_model.g.dart';

@JsonSerializable()
class OcrResponseModel {
  final String? name;
  final List<String>? phones;
  final String? email;
  final String? company;
  final String? position;
  final String? address;
  final String? website;

  @JsonKey(name: "social_profiles")
  final List<String>? socialProfiles;

  @JsonKey(name: "detected_languages")
  final List<String>? detectedLanguages;

  @JsonKey(name: "confidence_score")
  final double? confidenceScore;

  @JsonKey(name: "field_scores")
  final List<FieldScoreModel>? fieldScores;

  const OcrResponseModel({
    this.name,
    this.phones,
    this.email,
    this.company,
    this.position,
    this.address,
    this.website,
    this.socialProfiles,
    this.detectedLanguages,
    this.confidenceScore,
    this.fieldScores,
  });

  factory OcrResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OcrResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OcrResponseModelToJson(this);
}

@JsonSerializable()
class FieldScoreModel {
  @JsonKey(name: "field_name")
  final String fieldName;

  final dynamic value;

  final double score;

  final String classification;

  @JsonKey(name: "validation_status")
  final String validationStatus;

  @JsonKey(name: "auto_approved")
  final bool autoApproved;

  @JsonKey(name: "requires_manual_review")
  final bool requiresManualReview;

  final String? note;

  const FieldScoreModel({
    required this.fieldName,
    this.value,
    required this.score,
    required this.classification,
    required this.validationStatus,
    required this.autoApproved,
    required this.requiresManualReview,
    this.note,
  });

  factory FieldScoreModel.fromJson(Map<String, dynamic> json) =>
      _$FieldScoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$FieldScoreModelToJson(this);
}
