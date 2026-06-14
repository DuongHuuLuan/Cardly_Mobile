import 'package:cardly_app/data/models/user_model.dart';
import 'package:cardly_app/domain/entities/user_entity.dart';

class UserMapper {
  static UserEntity fromModel(UserModel model) => model.toEntity();

  static UserModel toModel(UserEntity entity) => UserModel(
    id: entity.id,
    accessToken: entity.accessToken,
    name: entity.name,
    email: entity.email,
    phone: entity.phone,
    password: entity.password,
    avatar: entity.avatar,
    position: entity.position,
    company: entity.company,
    address: entity.address,
    website: entity.website,
    linkedIn: entity.linkedIn,
    cardUrl: entity.cardUrl,
    bio: entity.bio,
  );
}
