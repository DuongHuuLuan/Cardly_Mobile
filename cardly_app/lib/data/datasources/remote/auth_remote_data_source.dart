import 'package:cardly_app/data/mappers/forgot_password_mapper.dart';
import 'package:cardly_app/data/models/auth/login_response.dart';
import 'package:cardly_app/data/services/auth_service.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/domain/Entities/forgot-password/forgot_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/reset_password_result.dart';
import 'package:cardly_app/domain/Entities/forgot-password/verify_otp_result.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:cardly_app/domain/entities/forgot-password/resend_otp_result.dart';
import 'package:cardly_app/domain/entities/forgot-password/verify_reset_otp_result.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  final AuthService _authService;
  final bool userMock;
  final _registeredUsers = <String, UserEntity>{};

  AuthRemoteDataSource(this._authService, {this.userMock = true});

  Future<LoginResponse> login(String email, String password) async {
    if (userMock) {
      return LoginResponse(
        accessToken: "mock_access_token_...",
        refreshToken: "mock_refresh_token_...",
        tokenType: "bearer",
        expiresIn: 900,
      );
    }

    try {
      final response = await _authService.login({
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  Future<UserEntity> getProfile() async {
    if (userMock) {
      return UserEntity(
        id: '1',
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
    try {
      final response = await _authService.getProfile();
      return response.data.toEntity();
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException('Failed to load profile: $e');
    }
  }

  Future<void> register(UserEntity user) async {
    if (userMock) {
      if (_registeredUsers.containsKey(user.email)) {
        throw ServerException("This email has already been registered.");
      }

      _registeredUsers[user.email] = user.copyWith(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        accessToken:
            "mock_access_token${DateTime.now().microsecondsSinceEpoch}",
      );
      return;
    }

    try {
      await _authService.register({
        "full_name": user.name,
        "email": user.email,
        "password": user.password,
      });
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'] as Map<String, dynamic>?;
      if (error != null) {
        return error['message'] as String? ?? 'An unexpected error occurred';
      }
    }
    return 'An unexpected error occurred';
  }

  Future<void> logout(String refreshToken) async {
    await _authService.logout({"refresh_token": refreshToken});
  }

  Future<LoginResponse> refreshToken(String refreshToken) async {
    final response = await _authService.refresh({
      "refresh_token": refreshToken,
    });
    return response.data;
  }

  Future<ForgotPasswordResult> forgotPassword(String email) async {
    if (userMock) {
      if (email == "test@gmail.com" || _registeredUsers.containsKey(email)) {
        return ForgotPasswordResult(message: "OTP sent", success: true);
      }
      throw ServerException("This email address has not been registered.");
    }

    try {
      final response = await _authService.forgotPasswordWithEmail({
        "email": email,
      });
      return ForgotPasswordMapper.toForgotPasswordResult(response.data);
      //  return ForgotPasswordResult(
      //   message: response.data.message,
      //   success: response.data.success,
      // );
    } catch (e) {
      throw ServerException("OTP sent via Email failed.: ${e.toString()}");
    }
  }

  Future<VerifyOtpResult> verifyOtp(String email, String otp) async {
    if (userMock) {
      if (otp == "444444") {
        return VerifyOtpResult(message: "OTP verified", success: true);
      }
      throw ServerException("Incorrect OTP code");
    }
    try {
      final response = await _authService.verifyOtp({
        "email": email,
        "otp": otp,
      });
      return ForgotPasswordMapper.toVerifyOtpResult(response.data);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  Future<VerifyResetOtpResult> verifyResetOtp(String email, String otp) async {
    try {
      final response = await _authService.verifyResetOtp({
        "email": email,
        "otp": otp,
      });
      return ForgotPasswordMapper.toVerifyResetOtpResult(response.data);
    } on DioException catch (e) {
      throw ServerException(_extractErrorMessage(e));
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  Future<ResendOtpResult> resenOtp(String email) async {
    try {
      final response = await _authService.resendOtp({"email": email});

      return ForgotPasswordMapper.toResendOtpResult(response.data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ResetPasswordResult> resetPassword(
    String resetToken,
    String newPassword,
  ) async {
    try {
      final response = await _authService.resetPassword({
        "reset_token": resetToken,
        "new_password": newPassword,
      });
      return ForgotPasswordMapper.toResetPasswordResult(response.data);
      // return ResetPasswordResult(message: response.data.message, success: true);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
