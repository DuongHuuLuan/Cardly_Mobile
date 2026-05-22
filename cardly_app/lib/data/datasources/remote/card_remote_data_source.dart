import 'dart:convert';
import 'package:cardly_app/data/mappers/scanned_document_mapper.dart';
import 'package:cardly_app/data/models/scan_response_model.dart';
import 'package:cardly_app/data/services/card_service.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:cardly_app/domain/enums/document_type.dart';
import 'package:dio/dio.dart';

class CardRemoteDataSource {
  final CardService _cardService;
  final bool userMock;

  CardRemoteDataSource(this._cardService, {this.userMock = true});

  static const String _mockPassportJson = '''
{
  "type": "passport",
  "id": "PAS001",
  "data": {
    "australian_passport_first_name": "John",
    "australian_passport_middle_name": "William",
    "australian_passport_last_name": "Smith",
    "australian_passport_number": "RA0123456",
    "australian_passport_date_of_birth": "15/01/1990",
    "australian_passport_date_of_issue": "01/05/2020",
    "australian_passport_expiry_date": "01/05/2030",
    "australian_passport_nationality": "AUSTRALIAN",
    "australian_passport_gender": "M",
    "australian_passport_place_of_birth": "CANBERRA"
  },
  "front_images": ["https://example.com/passport_front.jpg"],
  "back_images": ["https://example.com/passport_back.jpg"]
}
''';

  static const String _mockDriverLicenceJson = '''
{
  "type": "driverLicence",
  "id": "DL001",
  "data": {
    "australian_driver_license_first_name": "Jane",
    "australian_driver_license_middle_name": "Marie",
    "australian_driver_license_last_name": "Doe",
    "australian_driver_license_address": "42 Example Street, Sydney NSW 2000",
    "australian_driver_license_licence_number": "987654321",
    "australian_driver_license_state": "NSW",
    "australian_driver_license_card_number": "D9999999",
    "australian_driver_license_class": "CAR",
    "australian_driver_license_expiry_date": "15/03/2028",
    "australian_driver_license_dob": "22/08/1992"
  },
  "front_images": ["https://example.com/dl_front.jpg"],
  "back_images": ["https://example.com/dl_back.jpg"]
}
''';

  static const String _mockMedicareJson = '''
{
  "type": "medicareCard",
  "id": "MED001",
  "data": {
    "medicare_card_number": "1234 56789 1",
    "medicare_card_first_name": "Emily",
    "medicare_card_middle_name": "Rose",
    "medicare_card_last_name": "Johnson",
    "medicare_card_expiry_date": "08/2016",
    "medicare_card_position": "1"
  },
  "front_images": ["https://example.com/medicare_front.jpg"],
  "back_images": []
}
''';

  Future<List<ScannedDocument>> scanCard(
    DocumentType documentType,
    List<String> imagePaths,
  ) async {
    if (userMock) {
      final mockJson = _getMockJson(documentType);
      final map = jsonDecode(mockJson) as Map<String, dynamic>;
      final model = ScanResponseModel.fromJson(map);
      return [model].map((m) => ScannedDocumentMapper.fromResponse(m)).toList();
    }

    try {
      final response = await _cardService.scanCard({
        "image_paths": imagePaths,
        "document_type": documentType.name,
      });
      return [ScannedDocumentMapper.fromResponse(response.data)];
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } on FormatException catch (e) {
      throw ServerException('Invalid response: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ScannedDocument> updateScand(
    String id,
    Map<String, dynamic> data,
    DocumentType type,
  ) async {
    if (userMock) {
      final mockJson = _getMockJson(type);
      final map = jsonDecode(mockJson) as Map<String, dynamic>;
      map['data'] = data;
      final model = ScanResponseModel.fromJson(map);
      return ScannedDocumentMapper.fromResponse(model);
    }

    try {
      final response = await _cardService.updateCard(id, data);
      return ScannedDocumentMapper.fromResponse(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network errror");
    }
  }

  String _getMockJson(DocumentType type) {
    switch (type) {
      case DocumentType.passport:
        return _mockPassportJson;
      case DocumentType.driverLicence:
        return _mockDriverLicenceJson;
      case DocumentType.medicareCard:
        return _mockMedicareJson;
    }
  }
}
