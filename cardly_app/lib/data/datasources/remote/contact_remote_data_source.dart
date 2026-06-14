import 'dart:convert';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/data/mappers/contact_mapper.dart';
import 'package:cardly_app/data/models/contact/contact_detail_response.dart';
import 'package:cardly_app/data/models/contact/contact_list_response.dart';
import 'package:cardly_app/data/services/contact_service.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:dio/dio.dart';

class ContactRemoteDataSource {
  final ContactService _contactService;
  final bool userMock;

  ContactRemoteDataSource(this._contactService, {this.userMock = true});

  static const String _mockContactListJson = '''
{
  "items": [
    {
      "processing_id": "proc_1",
      "status": "completed",
      "uploaded_at": "2026-05-26T10:00:00.000Z",
      "file_urls": []
    },
    {
      "processing_id": "proc_2",
      "status": "completed",
      "uploaded_at": "2026-05-25T14:30:00.000Z",
      "file_urls": []
    }
  ],
  "total": "2",
  "skip": "0",
  "limit": "20"
}
''';

  Future<ContactListResponse> getContacts(int skip, int limit) async {
    if (userMock) {
      return ContactListResponse.fromJson(
        jsonDecode(_mockContactListJson) as Map<String, dynamic>,
      );
    }

    try {
      final response = await _contactService.getContacts(skip, limit);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } on FormatException catch (e) {
      throw ServerException('Invalid response: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<BusinessCardEntity> saveContact(BusinessCardEntity contact) async {
    if (userMock) {
      final now = DateTime.now();
      return contact.copyWith(
        id: 'contact_${now.millisecondsSinceEpoch}',
        createdAt: now,
      );
    }

    try {
      final response = await _contactService.saveContact(
        ContactMapper.toJson(contact),
      );
      final data = response.data.data;
      if (data == null) throw ServerException("Empty response");
      return ContactMapper.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } on FormatException catch (e) {
      throw ServerException('Invalid response: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteContact(String processingId) async {
    try {
      await _contactService.deleteContact(processingId);
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ContactDetailResponse> getContactDetail(String processingId) async {
    try {
      final response = await _contactService.getContactDetail(processingId);
      return response.data;
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } on FormatException catch (e) {
      throw ServerException('Invalid response: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<BusinessCardEntity> updateContact(BusinessCardEntity contact) async {
    if (userMock) {
      return contact;
    }

    try {
      final response = await _contactService.saveContact(
        ContactMapper.toJson(contact),
      );
      final data = response.data.data;
      if (data == null) throw ServerException("Empty response");
      return ContactMapper.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } on FormatException catch (e) {
      throw ServerException('Invalid response: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
