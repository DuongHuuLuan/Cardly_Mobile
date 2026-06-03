import 'package:equatable/equatable.dart';

class ResendOtpResult extends Equatable {
  final String message;
  final bool success;

  const ResendOtpResult({required this.message, required this.success});

  @override
  List<Object?> get props => [message, success];
}
