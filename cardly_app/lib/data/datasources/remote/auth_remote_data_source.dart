import 'package:cardly_app/data/mappers/user_mapper.dart';
import 'package:cardly_app/data/models/user_model.dart';
import 'package:cardly_app/data/services/auth_service.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';

class AuthRemoteDataSource {
  final AuthService _authService;
  final bool userMock;

  AuthRemoteDataSource(this._authService, {this.userMock = true});

  Future<UserEntity> login(String email, String password) async {
    if (userMock) {
      if (email == "test@gmail.com" && password == "123456") {
        return UserEntity(
          id: 1,
          accessToken: "mock_access_token_abc123",
          name: "Test",
          email: "test@gmail.com",
          phone: "+84 123 456 789",
          password: "123456",
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
}
