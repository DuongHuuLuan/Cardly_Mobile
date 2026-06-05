import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/local/card_local_data_source.dart';
import 'package:cardly_app/data/datasources/remote/card_remote_data_source.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:dartz/dartz.dart';

class CardRepositoryImpl implements CardRepository {
  final CardRemoteDataSource remoteDataSource;
  final CardLocalDataSource localDataSource;

  CardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ScannedDocument>>> scanCard(
    List<String> imagePaths,
  ) async {
    try {
      final results = await remoteDataSource.scanCard(imagePaths);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ScannedDocument>> updateCard(
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await remoteDataSource.updateCard(id, data);
      await localDataSource.saveScannedDocument(result);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
