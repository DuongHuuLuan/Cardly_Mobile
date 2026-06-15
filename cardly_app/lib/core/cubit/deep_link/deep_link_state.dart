import 'package:cardly_app/domain/entities/deep_link/deep_link_entity.dart';

abstract class DeepLinkState {}

class DeepLinkInitial extends DeepLinkState {}

class DeepLinkDetected extends DeepLinkState {
  final DeepLinkEntity link;
  DeepLinkDetected(this.link);
}
