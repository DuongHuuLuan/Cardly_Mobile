import 'package:cardly_app/data/models/deep_link/deep_link_model.dart';
import 'package:cardly_app/domain/entities/deep_link/deep_link_entity.dart';

class DeepLinkMapper {
  static DeepLinkEntity toEntity(DeepLinkModel model) {
    return DeepLinkEntity(router: model.router, params: model.params);
  }

  static DeepLinkModel toModel(DeepLinkEntity entity) {
    return DeepLinkModel(router: entity.router, params: entity.params);
  }
}
