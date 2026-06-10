import 'package:equatable/equatable.dart';

class VerifyResetOtpResult extends Equatable {
  final String reset_token;
  final String expires_in;

  const VerifyResetOtpResult({required this.reset_token, this.expires_in = ''});

  @override
  List<Object?> get props => [reset_token, expires_in];
}
