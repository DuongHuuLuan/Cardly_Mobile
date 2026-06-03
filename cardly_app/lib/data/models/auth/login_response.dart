import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  @JsonKey(name: "token_type")
  final String tokenType;

  @JsonKey(name: "expires_in")
  final int expiresIn;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
