import 'package:equatable/equatable.dart';

class VerifyOtpResult extends Equatable {
  final bool success;
  final String message;

  const VerifyOtpResult({required this.success, required this.message});

  @override
  List<Object?> get props => [success, message];
}
