import 'package:cardly_app/data/models/base_response.dart';
import 'package:cardly_app/data/models/contact/contact_detail_response.dart';
import 'package:cardly_app/data/models/contact/contact_list_response.dart';
import 'package:cardly_app/data/models/contact/delete_contact_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'contact_service.g.dart';

@RestApi()
abstract class ContactService {
  factory ContactService(Dio dio, {String baseUrl}) = _ContactService;

  @GET('/api/v1/documents')
  Future<HttpResponse<ContactListResponse>> getContacts(
    @Query('skip') int skip,
    @Query('limit') int limit,
  );

  @GET('/api/v1/documents/{processingId}')
  Future<HttpResponse<ContactDetailResponse>> getContactDetail(
    @Path('processingId') String processingId,
  );

  @POST('/contacts')
  Future<HttpResponse<BaseResponse<Map<String, dynamic>>>> saveContact(
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/api/v1/documents/{doc_id}')
  Future<HttpResponse<DeleteContactResponse>> deleteContact(
    @Path('doc_id') String docId,
  );
}
