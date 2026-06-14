import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/deep_link/deep_link_entity.dart';
import 'package:cardly_app/domain/repositories/deep_link_repository.dart';
import 'package:dartz/dartz.dart';

class SavePendingDeepLinkUsecase {
  final DeepLinkRepository repository;
  SavePendingDeepLinkUsecase({required this.repository});
  Future<Either<Failure, void>> call(DeepLinkEntity link) =>
      repository.setPendingDeepLink(link);
}
