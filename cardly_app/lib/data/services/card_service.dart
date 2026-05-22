import 'package:cardly_app/data/models/scan_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'card_service.g.dart';

@RestApi()
abstract class CardService {
  factory CardService(Dio dio, {String baseUrl}) = _CardService;

  @POST('/cards/scan')
  Future<HttpResponse<ScanResponseModel>> scanCard(
    @Body() Map<String, dynamic> body,
  );

  @PUT('/cards/{id}')
  Future<HttpResponse<ScanResponseModel>> updateCard(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
