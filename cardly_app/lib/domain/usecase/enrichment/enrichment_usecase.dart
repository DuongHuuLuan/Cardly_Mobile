import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:cardly_app/domain/repositories/enrichment_repository.dart';
import 'package:dartz/dartz.dart';

class EnrichmentUsecase {
  final EnrichmentRepository repository;

  EnrichmentUsecase({required this.repository});

  Future<Either<Failure, EnrichmentEntity>> enrich(
    Map<String, dynamic> data,
  ) async {
    return await repository.enrich(data);
  }
}
