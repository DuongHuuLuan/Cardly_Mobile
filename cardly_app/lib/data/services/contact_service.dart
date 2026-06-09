import 'package:cardly_app/data/models/base_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'contact_service.g.dart';

@RestApi()
abstract class ContactService {
  factory ContactService(Dio dio, {String baseUrl}) = _ContactService;

  @GET('/contacts')
  Future<HttpResponse<BaseResponse<List<Map<String, dynamic>>>>> getContacts();

  @POST('/contacts')
  Future<HttpResponse<BaseResponse<Map<String, dynamic>>>> saveContact(
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/contacts/{id}')
  Future<HttpResponse<BaseResponse<Map<String, dynamic>>>> deleteContact(
    @Path('id') String id,
  );
}
