import 'package:cardly_app/data/models/auth/forgot_password_response.dart';
import 'package:cardly_app/data/models/auth/reset_password_response.dart';
import 'package:cardly_app/data/models/auth/verify_otp_response.dart';
import 'package:cardly_app/domain/Entities/forgot-password/forgot_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/verify_otp_result.dart';

class ForgotPasswordMapper {
  static ForgotPasswordResult toForgotPasswordResult(
    ForgotPasswordResponse response,
  ) {
    return ForgotPasswordResult(
      message: response.message,
      nextStep: response.nextStep,
      contact: response.contact,
    );
  }

  static VerifyOtpResult toVerifyOtpResult(VerifyOtpResponse response) {
    return VerifyOtpResult(message: response.message);
  }

  static ResetPasswordResult toResetPasswordResult(
    ResetPasswordResponse response,
  ) {
    return ResetPasswordResult(message: response.message, success: true);
  }
}
