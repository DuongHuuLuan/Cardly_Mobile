import 'package:cardly_app/data/models/auth/forgot_password_response.dart';
import 'package:cardly_app/data/models/auth/resend_otp_response.dart';
import 'package:cardly_app/data/models/auth/reset_password_response.dart';
import 'package:cardly_app/data/models/auth/verify_otp_response.dart';
import 'package:cardly_app/data/models/auth/verify_reset_otp_response.dart';
import 'package:cardly_app/domain/entities/forgot-password/forgot_password_result.dart';
import 'package:cardly_app/domain/entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/entities/forgot-password/verify_otp_result.dart';
import 'package:cardly_app/domain/entities/forgot-password/resend_otp_result.dart';
import 'package:cardly_app/domain/entities/forgot-password/verify_reset_otp_result.dart';

class ForgotPasswordMapper {
  static ForgotPasswordResult toForgotPasswordResult(
    ForgotPasswordResponse response,
  ) {
    return ForgotPasswordResult(
      success: response.success,
      message: response.message,
    );
  }

  static VerifyOtpResult toVerifyOtpResult(VerifyOtpResponse response) {
    return VerifyOtpResult(
      success: response.success,
      message: response.message,
    );
  }

  static VerifyResetOtpResult toVerifyResetOtpResult(
    VerifyResetOtpResponse response,
  ) {
    return VerifyResetOtpResult(
      reset_token: response.reset_token,
      expires_in: response.expires_in,
    );
  }

  static ResendOtpResult toResendOtpResult(ResendOtpResponse response) {
    return ResendOtpResult(
      message: response.message,
      success: response.success,
    );
  }

  static ResetPasswordResult toResetPasswordResult(
    ResetPasswordResponse response,
  ) {
    return ResetPasswordResult(
      message: response.message,
      success: response.success,
    );
  }
}
