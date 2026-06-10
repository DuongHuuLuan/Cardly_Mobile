import 'dart:convert';
import 'package:cardly_app/data/mappers/scanned_document_mapper.dart';
import 'package:cardly_app/data/models/scan_response_model.dart';
import 'package:cardly_app/data/services/card_service.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:dio/dio.dart';

class CardRemoteDataSource {
  final CardService _cardService;
  final bool userMock;

  CardRemoteDataSource(this._cardService, {this.userMock = true});

  static const String _mockBusinessCardJson = '''
{
  "id": "bc_1",
  "images": [],
  "data": {
    "full_name": "Nguyễn Văn Anh",
    "job_title": "CEO & Founder",
    "company": "TechVina Solutions",
    "phone": "+84 912 345 678",
    "email": "anh.nguyen@techvina.com",
    "website": "https://techvina.com",
    "linkedin": "https://linkedin.com/in/anhnguyen",
    "address": "123 Nguyễn Huệ, Q.1, TP.HCM",
    "brief": "Founder of TechVina, an AI startup focusing on Vietnamese NLP.",
    "keywords": ["AI", "NLP", "startup", "Vietnamese tech"],
    "highlights": ["Raised \$2M Series A in 2025", "Team of 50+ engineers"],
    "created_at": "2026-05-26T10:00:00.000Z"
  }
}
''';

  Future<List<ScannedDocument>> scanCard(List<String> imagePaths) async {
    if (userMock) {
      final map = jsonDecode(_mockBusinessCardJson) as Map<String, dynamic>;
      final model = ScanResponseModel.fromJson(map);
      return [ScannedDocumentMapper.fromResponse(model)];
    }

    try {
      final files = await MultipartFile.fromFile(
        imagePaths[0],
        filename: imagePaths[0].split(RegExp(r'[/\\]')).last,
      );
      MultipartFile? file2;
      if (imagePaths.length > 1) {
        file2 = await MultipartFile.fromFile(
          imagePaths[1],
          filename: imagePaths[1].split(RegExp(r'[/\\]')).last,
        );
      }

      final response = await _cardService.scanCard(files, file2);
      return [ScannedDocumentMapper.fromResponse(response.data.data!)];
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    } on FormatException catch (e) {
      throw ServerException('Invalid response: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<ScannedDocument> updateCard(
    String id,
    Map<String, dynamic> data,
  ) async {
    if (userMock) {
      final map = jsonDecode(_mockBusinessCardJson) as Map<String, dynamic>;
      map['data'] = data;
      final model = ScanResponseModel.fromJson(map);
      return ScannedDocumentMapper.fromResponse(model);
    }

    try {
      final response = await _cardService.updateCard(id, data);
      return ScannedDocumentMapper.fromResponse(response.data.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    }
  }
}
