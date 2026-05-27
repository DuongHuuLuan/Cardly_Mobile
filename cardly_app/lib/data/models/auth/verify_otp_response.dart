import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

@JsonSerializable()
class VerifyOtpResponse extends Equatable {
  final String message;

  const VerifyOtpResponse({required this.message});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);

  @override
  List<Object?> get props => [message];
}
