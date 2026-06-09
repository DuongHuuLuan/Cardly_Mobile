import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:dartz/dartz.dart';

abstract class CardRepository {
  Future<Either<Failure, List<ScannedDocument>>> scanCard(
    List<String> imagePaths,
  );
  Future<Either<Failure, ScannedDocument>> updateCard(
    String id,
    Map<String, dynamic> data,
  );
}
