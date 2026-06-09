import 'dart:convert';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/data/mappers/contact_mapper.dart';
import 'package:cardly_app/data/services/contact_service.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:dio/dio.dart';

class ContactRemoteDataSource {
  final ContactService _contactService;
  final bool userMock;

  ContactRemoteDataSource(this._contactService, {this.userMock = true});

  static const String _mockContactListJson = '''
[
  {
    "id": "contact_1",
    "full_name": "Nguyễn Văn Anh",
    "job_title": "CEO & Founder",
    "company": "TechVina Solutions",
    "phone": "+84 912 345 678",
    "email": "anh.nguyen@techvina.com",
    "website": "https://techvina.com",
    "linkedin": "https://linkedin.com/in/anhnguyen",
    "address": "123 Nguyễn Huệ, Q.1, TP.HCM",
    "created_at": "2026-05-26T10:00:00.000Z"
  },
  {
    "id": "contact_2",
    "full_name": "Trần Thị Bích",
    "job_title": "CTO",
    "company": "DataStream Vietnam",
    "phone": "+84 987 654 321",
    "email": "bich.tran@datastream.vn",
    "website": "https://datastream.vn",
    "linkedin": "https://linkedin.com/in/bichtran",
    "address": "456 Lê Lợi, Q.1, TP.HCM",
    "created_at": "2026-05-25T14:30:00.000Z"
  }
]
''';

  Future<List<BusinessCardEntity>> getContacts() async {
    if (userMock) {
      final list = (jsonDecode(_mockContactListJson) as List<dynamic>)
          .cast<Map<String, dynamic>>();
      return ContactMapper.formJsonList(list);
    }

    try {
      final response = await _contactService.getContacts();
      return ContactMapper.formJsonList(response.data.data!);
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

  Future<void> deleteContact(String id) async {
    if (userMock) {
      return;
    }

    try {
      await _contactService.deleteContact(id);
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
