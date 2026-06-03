import 'package:equatable/equatable.dart';

class ResetPasswordResult extends Equatable {
  final String message;
  final bool success;

  const ResetPasswordResult({required this.message, required this.success});

  @override
  List<Object?> get props => [message, success];
}
