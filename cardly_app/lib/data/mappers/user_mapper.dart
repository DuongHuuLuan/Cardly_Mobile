import 'package:cardly_app/data/models/user_model.dart';
import 'package:cardly_app/domain/Entities/user_entity.dart';

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
  );
}
