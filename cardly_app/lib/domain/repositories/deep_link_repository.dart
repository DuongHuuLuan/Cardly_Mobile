import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/deep_link/deep_link_entity.dart';
import 'package:dartz/dartz.dart';

abstract class DeepLinkRepository {
  Future<Either<Failure, DeepLinkEntity?>> getPendingDeepLink();
  Future<Either<Failure, void>> setPendingDeepLink(DeepLinkEntity link);
  Future<Either<Failure, void>> clearPendingDeepLink();

  void setPendingDeepLinkSync(DeepLinkEntity link);
  DeepLinkEntity? getPendingDeepLinkSync();
}
