import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/local/deep_link_local_data_source.dart';
import 'package:cardly_app/domain/entities/deep_link/deep_link_entity.dart';
import 'package:cardly_app/domain/repositories/deep_link_repository.dart';
import 'package:dartz/dartz.dart';

class DeepLinkRepositoryImpl implements DeepLinkRepository {
  final DeepLinkLocalDataSource localDataSource;

  DeepLinkRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, DeepLinkEntity?>> getPendingDeepLink() async {
    try {
      final entity = await localDataSource.getPendingDeepLink();
      return Right(entity);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setPendingDeepLink(DeepLinkEntity link) async {
    try {
      await localDataSource.savePendingDeepLink(link);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearPendingDeepLink() async {
    try {
      await localDataSource.clearPendingDeepLink();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  void setPendingDeepLinkSync(DeepLinkEntity link) {
    localDataSource.savePendingDeepLinkSync(link);
  }

  @override
  DeepLinkEntity? getPendingDeepLinkSync() {
    return localDataSource.getPendingDeepLinkSync();
  }
}
