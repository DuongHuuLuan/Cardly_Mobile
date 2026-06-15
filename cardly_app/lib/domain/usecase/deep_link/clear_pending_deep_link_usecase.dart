import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/repositories/deep_link_repository.dart';
import 'package:dartz/dartz.dart';

class ClearPendingDeepLinkUsecase {
  final DeepLinkRepository repository;
  ClearPendingDeepLinkUsecase({required this.repository});
  Future<Either<Failure, void>> call() => repository.clearPendingDeepLink();
}
