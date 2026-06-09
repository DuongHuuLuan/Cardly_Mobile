import 'package:equatable/equatable.dart';

class VerifyOtpResult extends Equatable {
  final String message;

  const VerifyOtpResult({required this.message});

  @override
  List<Object?> get props => [message];
}
