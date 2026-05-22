import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/data/datasources/remote/card_remote_data_source.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/enums/document_type.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:dartz/dartz.dart';

class CardRepositoryImpl implements CardRepository {
  final CardRemoteDataSource remoteDataSource;

  CardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ScannedDocument>>> scanCard(
    DocumentType documentType,
    List<String> imagePaths,
  ) async {
    try {
      final docs = await remoteDataSource.scanCard(documentType, imagePaths);
      return Right(docs);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Exception, ScannedDocument>> updateScand(
    String id,
    Map<String, dynamic> data,
    DocumentType type,
  ) async {
    try {
      final doc = await remoteDataSource.updateScand(id, data, type);
      return Right(doc);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
