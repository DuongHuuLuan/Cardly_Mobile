import 'package:cardly_app/data/models/base_response.dart';
import 'package:cardly_app/data/models/scan_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'card_service.g.dart';

@RestApi()
abstract class CardService {
  factory CardService(Dio dio, {String baseUrl}) = _CardService;

  @MultiPart()
  @POST('/cards/scan')
  Future<HttpResponse<BaseResponse<ScanResponseModel>>> scanCard(
    @Part(name: "images") List<MultipartFile> images,
  );

  @PUT('/cards/{id}')
  Future<HttpResponse<BaseResponse<ScanResponseModel>>> updateCard(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
