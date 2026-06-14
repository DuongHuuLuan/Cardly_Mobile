import 'package:cardly_app/data/models/auth/forgot_password_response.dart';
import 'package:cardly_app/data/models/auth/login_response.dart';
import 'package:cardly_app/data/models/auth/register_response.dart';
import 'package:cardly_app/data/models/auth/resend_otp_response.dart';
import 'package:cardly_app/data/models/auth/reset_password_response.dart';
import 'package:cardly_app/data/models/auth/verify_otp_response.dart';
import 'package:cardly_app/data/models/auth/verify_reset_otp_response.dart';
import 'package:cardly_app/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/api/v1/auth/login')
  Future<HttpResponse<LoginResponse>> login(@Body() Map<String, dynamic> body);

  @POST('/api/v1/auth/register')
  Future<HttpResponse<RegisterResponse>> register(
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/auth/refresh')
  Future<HttpResponse<LoginResponse>> refresh(
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/auth/logout')
  Future<HttpResponse<RegisterResponse>> logout(
    @Body() Map<String, dynamic> body,
  );

  @GET('/api/v1/auth/me')
  Future<HttpResponse<UserModel>> getProfile();

  @POST("/api/v1/auth/forgot-password")
  Future<HttpResponse<ForgotPasswordResponse>> forgotPasswordWithEmail(
    @Body() Map<String, dynamic> body,
  );

  @POST("/api/v1/auth/verify-otp")
  Future<HttpResponse<VerifyOtpResponse>> verifyOtp(
    @Body() Map<String, dynamic> body,
  );

  @POST("/api/v1/auth/resend-otp")
  Future<HttpResponse<ResendOtpResponse>> resendOtp(
    @Body() Map<String, dynamic> body,
  );

  @POST("/api/v1/auth/verify-reset-otp")
  Future<HttpResponse<VerifyResetOtpResponse>> verifyResetOtp(
    @Body() Map<String, dynamic> body,
  );

  @POST("/api/v1/auth/reset-password")
  Future<HttpResponse<ResetPasswordResponse>> resetPassword(
    @Body() Map<String, dynamic> body,
  );
}
