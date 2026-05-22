import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/enums/document_type.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCardUsecase {
  CardRepository repository;

  UpdateCardUsecase({required this.repository});

  Future<Either<Exception, ScannedDocument>> updateScand(
    String id,
    Map<String, dynamic> data,
    DocumentType type,
  ) async {
    return repository.updateScand(id, data, type);
  }
}
