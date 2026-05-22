import 'package:cardly_app/data/models/user_model.dart';
import 'package:cardly_app/domain/Entities/user.dart';

class UserMapper {
  static UserEntity fromModel(UserModel model) => model.toEntity();

  static UserModel toModel(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        avatar: entity.avatar,
      );
}
