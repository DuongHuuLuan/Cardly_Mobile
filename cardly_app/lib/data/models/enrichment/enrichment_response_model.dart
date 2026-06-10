import 'package:json_annotation/json_annotation.dart';

part 'enrichment_response_model.g.dart';

@JsonSerializable()
class EnrichmentResponseModel {
  @JsonKey(name: "professional_brief")
  final String? professionalBrief;
  final List<String>? keywords;
  final List<String>? highlights;
  @JsonKey(name: "generation_status")
  final String? generationStatus;

  const EnrichmentResponseModel({
    this.professionalBrief,
    this.keywords,
    this.highlights,
    this.generationStatus,
  });

  factory EnrichmentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EnrichmentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnrichmentResponseModelToJson(this);
}
