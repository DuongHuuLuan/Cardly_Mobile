import 'package:json_annotation/json_annotation.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int id;
  @JsonKey(name: "access_token")
  final String? accessToken;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? password;

  const UserModel({
    required this.id,
    this.accessToken,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
    id: id,
    accessToken: accessToken,
    name: name,
    email: email,
    phone: phone,
    password: password!,
    avatar: avatar,
  );
}
