import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/scanned_document.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCardUsecase {
  final CardRepository repository;

  UpdateCardUsecase({required this.repository});

  Future<Either<Failure, ScannedDocument>> updateCard(
    String id,
    Map<String, dynamic> data,
  ) async {
    return repository.updateCard(id, data);
  }
}
