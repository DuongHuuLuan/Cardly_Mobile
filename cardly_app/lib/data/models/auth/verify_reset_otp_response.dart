import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_reset_otp_response.g.dart';

@JsonSerializable()
class VerifyResetOtpResponse extends Equatable {
  final String reset_token;
  @JsonKey(defaultValue: '')
  final String expires_in;

  const VerifyResetOtpResponse({
    required this.reset_token,
    required this.expires_in,
  });

  factory VerifyResetOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyResetOtpResponseToJson(this);

  @override
  List<Object?> get props => [reset_token, expires_in];
}
