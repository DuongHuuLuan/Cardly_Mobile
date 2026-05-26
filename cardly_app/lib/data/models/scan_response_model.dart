import 'package:json_annotation/json_annotation.dart';

part 'scan_response_model.g.dart';

@JsonSerializable()
class ScanResponseModel {
  final String id;
  @JsonKey(name: "data")
  final Map<String, dynamic> rawData;
  @JsonKey(name: "images")
  final List<String> images;

  const ScanResponseModel({
    required this.id,
    required this.rawData,
    this.images = const [],
  });

  factory ScanResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ScanResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResponseModelToJson(this);
}
