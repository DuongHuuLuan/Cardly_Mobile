import 'package:cardly_app/data/models/enrichment/enrichment_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'enrichment_service.g.dart';

@RestApi()
abstract class EnrichmentService {
  factory EnrichmentService(Dio dio, {String baseUrl}) = _EnrichmentService;

  @POST('/api/v1/enrichment/')
  Future<HttpResponse<EnrichmentResponseModel>> enrichmentDoc(
    @Body() Map<String, dynamic> body,
  );
}
