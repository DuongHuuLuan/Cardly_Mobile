import 'package:cardly_app/data/models/user_model.dart';
import 'package:cardly_app/data/services/auth_service.dart';
import 'package:cardly_app/core/error/exceptions.dart';

class AuthRemoteDataSource {
  final AuthService _authService;
  final bool userMock;

  AuthRemoteDataSource(this._authService, {this.userMock = true});

  Future<UserModel> login(String email, String password) async {
    if (userMock) {
      if (email == "test@gmail.com" && password == "123456") {
        return const UserModel(
          id: 1,
          name: "Test",
          email: "test@gmail.com",
          phone: "+84 123 456 789",
        );
      }
      throw ServerException("Invalid email or password");
    }
    try {
      final response = await _authService.login({
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel> register(UserModel user) async {
    if (userMock) {
      return user;
    }
    try {
      final response = await _authService.register(user.toJson());
      return response.data;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
