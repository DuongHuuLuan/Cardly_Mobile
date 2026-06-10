import 'package:json_annotation/json_annotation.dart';

part 'upload_response_model.g.dart';

@JsonSerializable()
class UploadResponseModel {
  @JsonKey(name: "processing_id")
  final String processingId;
  final List<UploadFileModel> files;
  final String status;
  @JsonKey(name: "uploaded_at")
  final String uploadedAt;

  const UploadResponseModel({
    required this.processingId,
    required this.files,
    required this.status,
    required this.uploadedAt,
  });

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadResponseModelToJson(this);
}

@JsonSerializable()
class UploadFileModel {
  @JsonKey(name: "original_filename")
  final String originalFilename;
  @JsonKey(name: "file_url")
  final String fileUrl;
  const UploadFileModel({
    required this.originalFilename,
    required this.fileUrl,
  });

  factory UploadFileModel.fromJson(Map<String, dynamic> json) =>
      _$UploadFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadFileModelToJson(this);
}
