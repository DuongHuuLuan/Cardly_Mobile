import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/remote/enrichment_remote_data_source.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:cardly_app/domain/repositories/enrichment_repository.dart';
import 'package:dartz/dartz.dart';

class EnrichmentRepositoryImpl implements EnrichmentRepository {
  final EnrichmentRemoteDataSource remoteDataSource;

  EnrichmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, EnrichmentEntity>> enrich(
    Map<String, dynamic> data,
  ) async {
    try {
      final enrich = await remoteDataSource.enrich(data);
      return Right(enrich);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
