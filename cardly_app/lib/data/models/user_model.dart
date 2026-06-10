import 'package:json_annotation/json_annotation.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: "access_token")
  final String? accessToken;
  @JsonKey(name: "full_name")
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final String? password;
  final String? position;
  final String? company;
  final String? address;
  final String? website;
  @JsonKey(name: "linked_in")
  final String? linkedIn;
  @JsonKey(name: "card_url")
  final String? cardUrl;
  final String? bio;
  @JsonKey(name: "is_active")
  final bool? isActive;

  const UserModel({
    required this.id,
    this.accessToken,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.password,
    this.position,
    this.company,
    this.address,
    this.website,
    this.linkedIn,
    this.cardUrl,
    this.bio,
    this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
    id: id,
    accessToken: accessToken,
    name: name,
    email: email,
    phone: phone ?? '',
    password: password ?? '',
    avatar: avatar,
    position: position,
    company: company,
    address: address,
    website: website,
    linkedIn: linkedIn,
    cardUrl: cardUrl,
    bio: bio,
  );
}
