import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;
  ResetPasswordUsecase({required this.repository});
  Future<Either<Failure, ResetPasswordResult>> call(
    String resetToken,
    String newPassword,
  ) async {
    return await repository.resetPassword(resetToken, newPassword);
  }
}
