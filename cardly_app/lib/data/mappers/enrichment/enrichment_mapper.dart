import 'package:cardly_app/data/models/enrichment/enrichment_response_model.dart';
import 'package:cardly_app/domain/entities/enrichment/enrichment_entity.dart';

class EnrichmentMapper {
  static EnrichmentEntity toEntity(EnrichmentResponseModel response) {
    return EnrichmentEntity(
      professionalBrief: response.professionalBrief ?? '',
      keywords: response.keywords ?? [],
      highlights: response.highlights ?? [],
      generationStatus: response.generationStatus ?? '',
    );
  }
}
