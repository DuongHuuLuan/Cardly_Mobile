import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/data/mappers/enrichment/enrichment_mapper.dart';
import 'package:cardly_app/data/services/enrichment_service.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';
import 'package:dio/dio.dart';

class EnrichmentRemoteDataSource {
  final EnrichmentService _enrichmentService;
  final userMock;

  EnrichmentRemoteDataSource(this._enrichmentService, {this.userMock = true});

  Future<EnrichmentEntity> enrich(Map<String, dynamic> data) async {
    if (userMock) {
      return EnrichmentEntity(
        professionalBrief:
            "Experienced professional with expertise in ${data['position'] ?? 'their field'} at ${data['company'] ?? 'a leading organization'}.",
        keywords: ["leadership", "innovation", "strategy"],
        highlights: ["Over 10 years of experience", "Proven track record"],
        generationStatus: "SUCCESS",
      );
    }

    try {
      final response = await _enrichmentService.enrichmentDoc(data);
      return EnrichmentMapper.toEntity(response.data);
    } on DioException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }
}
