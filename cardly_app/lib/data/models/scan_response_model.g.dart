// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResponseModel _$ScanResponseModelFromJson(Map<String, dynamic> json) =>
    ScanResponseModel(
      type: json['type'] as String,
      id: json['id'] as String,
      data: json['data'] as Map<String, dynamic>,
      backImages: (json['backImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      frontImages: (json['frontImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ScanResponseModelToJson(ScanResponseModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'data': instance.data,
      'frontImages': instance.frontImages,
      'backImages': instance.backImages,
    };
