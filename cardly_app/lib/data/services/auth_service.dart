import 'package:cardly_app/data/models/auth/forgot_password_response.dart';
import 'package:cardly_app/data/models/auth/reset_password_response.dart';
import 'package:cardly_app/data/models/auth/verify_otp_response.dart';
import 'package:cardly_app/data/models/base_response.dart';
import 'package:cardly_app/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/auth/login')
  Future<HttpResponse<BaseResponse<UserModel>>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST('/auth/register')
  Future<HttpResponse<BaseResponse<UserModel>>> register(
    @Body() Map<String, dynamic> body,
  );

  @POST("/auth/forgot-password/email")
  Future<HttpResponse<BaseResponse<ForgotPasswordResponse>>>
  forgotPasswordWithEmail(@Body() Map<String, dynamic> body);

  @POST("/auth/verify-otp")
  Future<HttpResponse<BaseResponse<VerifyOtpResponse>>> verifyOtp(
    @Body() Map<String, dynamic> body,
  );

  @POST("/auth/resetPassword/email")
  Future<HttpResponse<BaseResponse<ResetPasswordResponse>>>
  resetPasswordByEmail(@Body() Map<String, dynamic> body);
}
