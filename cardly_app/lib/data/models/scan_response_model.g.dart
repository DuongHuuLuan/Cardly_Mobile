// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResponseModel _$ScanResponseModelFromJson(Map<String, dynamic> json) =>
    ScanResponseModel(
      id: json['id'] as String,
      rawData: json['data'] as Map<String, dynamic>,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ScanResponseModelToJson(ScanResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.rawData,
      'images': instance.images,
    };
