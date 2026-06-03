import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/forgot-password/resend_otp_result.dart';
import 'package:cardly_app/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ResendOtpUsecase {
  final AuthRepository repository;

  ResendOtpUsecase({required this.repository});

  Future<Either<Failure, ResendOtpResult>> call(String email) async {
    return repository.resendOtp(email);
  }
}
