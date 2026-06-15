import 'package:cardly_app/data/models/base_response.dart';
import 'package:cardly_app/data/models/ocr/ocr_response_model.dart';
import 'package:cardly_app/data/models/ocr/upload_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'card_service.g.dart';

@RestApi()
abstract class CardService {
  factory CardService(Dio dio, {String baseUrl}) = _CardService;

  @MultiPart()
  @POST('/api/v1/documents')
  Future<HttpResponse<UploadResponseModel>> uploadCard(
    @Part(name: "file") MultipartFile file,
    @Part(name: "file2") MultipartFile? file2,
  );

  @POST('/api/v1/ocr/pipeline/{processingId}')
  Future<HttpResponse<OcrResponseModel>> getOcr(
    @Path('processingId') String processingId,
  );

  @PUT('/cards/{id}')
  Future<HttpResponse<BaseResponse<OcrResponseModel>>> updateCard(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );
}
