import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/repositories/card_repository.dart';
import 'package:dartz/dartz.dart';

class ScanCardUsecase {
  final CardRepository repository;

  ScanCardUsecase({required this.repository});

  Future<Either<Failure, List<ScannedDocument>>> call(
    List<String> imagePaths,
  ) async {
    return await repository.scanCard(imagePaths);
  }
}
