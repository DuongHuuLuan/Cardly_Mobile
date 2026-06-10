import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/forgot-password/verify_reset_otp_result.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyResetOtpUsecase {
  final AuthRepository repository;

  VerifyResetOtpUsecase({required this.repository});

  Future<Either<Failure, VerifyResetOtpResult>> call(
    String email,
    String otp,
  ) async {
    return await repository.verifyResetOtp(email, otp);
  }
}
