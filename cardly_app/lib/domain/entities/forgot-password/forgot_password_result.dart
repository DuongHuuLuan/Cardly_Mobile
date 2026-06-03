import 'package:equatable/equatable.dart';

class ForgotPasswordResult extends Equatable {
  final bool success;
  final String message;

  const ForgotPasswordResult({required this.success, required this.message});

  @override
  List<Object?> get props => [success, message];
}
