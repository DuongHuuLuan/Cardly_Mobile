import 'package:json_annotation/json_annotation.dart';

part 'scan_response_model.g.dart';

@JsonSerializable()
class ScanResponseModel {
  final String type;
  final String id;
  final Map<String, dynamic> data;
  final List<String>? frontImages;
  final List<String>? backImages;

  const ScanResponseModel({
    required this.type,
    required this.id,
    required this.data,
    this.backImages,
    this.frontImages,
  });

  factory ScanResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ScanResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResponseModelToJson(this);
}
