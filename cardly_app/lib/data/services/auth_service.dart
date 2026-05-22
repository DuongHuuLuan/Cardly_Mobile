import 'package:cardly_app/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/auth/login')
  Future<HttpResponse<UserModel>> login(@Body() Map<String, dynamic> body);

  @POST('/auth/register')
  Future<HttpResponse<UserModel>> register(@Body() Map<String, dynamic> body);
}
