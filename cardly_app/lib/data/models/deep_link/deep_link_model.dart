import 'package:json_annotation/json_annotation.dart';

part 'deep_link_model.g.dart';

@JsonSerializable()
class DeepLinkModel {
  final String router;
  final Map<String, String> params;

  const DeepLinkModel({required this.router, required this.params});

  factory DeepLinkModel.fromJson(Map<String, dynamic> json) =>
      _$DeepLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeepLinkModelToJson(this);
}
