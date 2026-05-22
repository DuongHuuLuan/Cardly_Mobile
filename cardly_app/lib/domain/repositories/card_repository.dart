import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/enums/document_type.dart';
import 'package:dartz/dartz.dart';

abstract class CardRepository {
  Future<Either<Failure, List<ScannedDocument>>> scanCard(
    DocumentType documentType,
    List<String> imagePaths,
  );
  Future<Either<Exception, ScannedDocument>> updateScand(
    String id,
    Map<String, dynamic> data,
    DocumentType type,
  );
}
