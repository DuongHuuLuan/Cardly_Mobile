import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/Entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;
  ResetPasswordUsecase({required this.repository});
  Future<Either<Failure, ResetPasswordResult>> call(
    String email,
    String newPassword,
  ) async {
    return await repository.resetPassword(email, newPassword);
  }
}
