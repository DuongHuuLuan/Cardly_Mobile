import 'package:cardly_app/data/mappers/user_mapper.dart';
import 'package:cardly_app/data/models/user_model.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<void> saveUser(UserEntity user);
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<UserEntity?> getUser();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  static const String _tokenKey = "access_token";
  static const String _userKey = "current_user";
  static const String _refreshTokenKey = "refresh_token";

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await sharedPreferences.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    final model = UserMapper.toModel(user);
    final json = jsonEncode(model.toJson());
    await sharedPreferences.setString(_userKey, json);
  }

  @override
  Future<String?> getToken() async => sharedPreferences.getString(_tokenKey);

  @override
  Future<String?> getRefreshToken() async =>
      sharedPreferences.getString(_refreshTokenKey);

  @override
  Future<UserEntity?> getUser() async {
    final json = sharedPreferences.getString(_userKey);
    if (json == null) return null;

    final model = UserModel.fromJson(jsonDecode(json));

    return UserMapper.fromModel(model);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_refreshTokenKey);
    await sharedPreferences.remove(_userKey);
  }
}
