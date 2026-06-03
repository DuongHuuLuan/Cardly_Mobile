import 'package:cardly_app/domain/Entities/forgot-password/forgot_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/verify_otp_result.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/auth_tokens.dart';
import 'package:cardly_app/domain/entities/forgot-password/resend_otp_result.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthTokens>> login(String email, String password);
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, void>> register(UserEntity user);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, String>> refreshToken();

  //forgot-password
  Future<Either<Failure, ForgotPasswordResult>> forgotPassword(String email);
  Future<Either<Failure, VerifyOtpResult>> verifyOtp(String email, String otp);
  Future<Either<Failure, ResendOtpResult>> resendOtp(String email);
  Future<Either<Failure, ResetPasswordResult>> resetPassword(
    String email,
    String otp,
    String newPassword,
  );
}
