// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
  Map<String, dynamic> json,
) => ForgotPasswordResponse(
  message: json['message'] as String,
  contact: json['contact'] as String?,
  nextStep: json['nextStep'] as String?,
);

Map<String, dynamic> _$ForgotPasswordResponseToJson(
  ForgotPasswordResponse instance,
) => <String, dynamic>{
  'message': instance.message,
  'nextStep': instance.nextStep,
  'contact': instance.contact,
};
