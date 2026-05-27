import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response.g.dart';

@JsonSerializable()
class ForgotPasswordResponse extends Equatable {
  final String message;
  final String? nextStep;
  final String? contact;

  const ForgotPasswordResponse({
    required this.message,
    this.contact,
    this.nextStep,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordResponseToJson(this);

  @override
  List<Object?> get props => [message, contact, nextStep];
}
