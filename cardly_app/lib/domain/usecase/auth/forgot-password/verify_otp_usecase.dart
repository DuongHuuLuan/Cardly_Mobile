import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/forgot-password/verify_otp_result.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;
  VerifyOtpUsecase({required this.repository});

  Future<Either<Failure, VerifyOtpResult>> call(
    String email,
    String otp,
  ) async {
    return await repository.verifyOtp(email, otp);
  }
}
