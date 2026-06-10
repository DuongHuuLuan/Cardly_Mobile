import 'package:cardly_app/core/error/failures.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class EnrichmentRepository {
  Future<Either<Failure, EnrichmentEntity>> enrich(Map<String, dynamic> data);
}
