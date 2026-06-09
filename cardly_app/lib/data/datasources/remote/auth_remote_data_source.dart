import 'package:cardly_app/data/mappers/forgot_password_mapper.dart';
import 'package:cardly_app/data/mappers/user_mapper.dart';
import 'package:cardly_app/data/services/auth_service.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/domain/Entities/forgot-password/forgot_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/verify_otp_result.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';

class AuthRemoteDataSource {
  final AuthService _authService;
  final bool userMock;

  AuthRemoteDataSource(this._authService, {this.userMock = true});

  Future<UserEntity> login(String email, String password) async {
    if (userMock) {
      if (email != "test@gmail.com") {
        throw ServerException("Incorrect Email");
      }
      if (password != "123456") {
        throw ServerException("Incorrect Password");
      }
      if (email == "test@gmail.com" && password == "123456") {
        return UserEntity(
          id: 1,
          accessToken: "mock_access_token_abc123",
          name: "Test",
          email: "test@gmail.com",
          phone: "+84 123 456 789",
          password: "123456",
          position: "Software Engineer",
          company: "Cardly Inc.",
          address: "123 Nguyễn Huệ, Q.1, TP.HCM",
          website: "https://cardly.ai",
          linkedIn: "https://linkedin.com/in/cardly",
          cardUrl: "https://cardly.ai/u/test",
          bio: "Chuyên gia giải pháp danh thiếp số",
        );
      }
      throw ServerException("Invalid email or password");
    }
    try {
      final response = await _authService.login({
        'email': email,
        'password': password,
      });
      return UserMapper.fromModel(response.data.data!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserEntity> register(UserEntity user) async {
    try {
      final response = await _authService.register({
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "password": user.password,
        "avatar": user.avatar,
      });
      return UserMapper.fromModel(response.data.data!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ForgotPasswordResult> forgotPassword(String email) async {
    if (userMock) {
      if (email == "test@gmail.com") {
        return ForgotPasswordResult(message: "OTP sent", contact: email);
      }
      throw ServerException("This email address has not been registered.");
    }

    try {
      final response = await _authService.forgotPasswordWithEmail({
        "email": email,
      });
      return ForgotPasswordMapper.toForgotPasswordResult(response.data.data!);
    } catch (e) {
      throw ServerException("OTP sent via Email failed.: ${e.toString()}");
    }
  }

  Future<VerifyOtpResult> verifyOtp(String email, String otp) async {
    if (userMock) {
      if (otp == "444444") {
        return VerifyOtpResult(message: "OTP verified");
      }
      throw ServerException("Incorrect OTP code");
    }
    try {
      final response = await _authService.verifyOtp({
        "email": email,
        "otp": otp,
      });

      return ForgotPasswordMapper.toVerifyOtpResult(response.data.data!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ResetPasswordResult> resetPassword(
    String email,
    String newPassword,
  ) async {
    if (userMock) {
      if (email == "test@gmail.com") {
        return ResetPasswordResult(
          message: "Password reset successfully",
          success: true,
        );
      }
      throw ServerException("Reset password failed");
    }
    try {
      final response = await _authService.resetPasswordByEmail({
        "email": email,
        "new_password": newPassword,
      });
      return ForgotPasswordMapper.toResetPasswordResult(response.data.data!);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
