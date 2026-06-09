import 'package:equatable/equatable.dart';

class ForgotPasswordResult extends Equatable {
  final String message;
  final String? contact;
  final String? nextStep;

  const ForgotPasswordResult({
    required this.message,
    this.contact,
    this.nextStep,
  });

  @override
  List<Object?> get props => [message, contact, nextStep];
}
