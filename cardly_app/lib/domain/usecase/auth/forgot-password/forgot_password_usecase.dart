import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/forgot-password/forgot_password_result.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUsecase {
  final AuthRepository repository;

  ForgotPasswordUsecase({required this.repository});

  Future<Either<Failure, ForgotPasswordResult>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}
