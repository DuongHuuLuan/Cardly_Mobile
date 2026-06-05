import 'dart:convert';
import 'package:cardly_app/data/mappers/ocr_mapper.dart';
import 'package:cardly_app/data/mappers/scanned_document_mapper.dart';
import 'package:cardly_app/data/models/ocr_response_model.dart';
import 'package:cardly_app/data/models/scan_response_model.dart';
import 'package:cardly_app/data/services/card_service.dart';
import 'package:cardly_app/core/error/exceptions.dart';
import 'package:cardly_app/domain/Entities/scanned_document.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/upload_response_model.dart';

class CardRemoteDataSource {
  final CardService _cardService;
  final bool userMock;

  CardRemoteDataSource(this._cardService, {this.userMock = true});

  static const String _mockUploadJson = '''
  {
    "processing_id": "PRC-20260604-MOCK01",
    "files": [
      {
        "original_filename": "card.jpg",
        "file_url": "https://storage.googleapis.com/cardly-images-bucket/mock/card.jpg"
      }
    ],
    "status": "completed",
    "uploaded_at": "2026-06-04T00:36:07+0000"
  }
  ''';

  static const String _mockOcrJson = '''
  {
    "name": "Le Thi Lam Tuyen",
    "phones": ["+84888494588"],
    "email": "tuyenltl2@fe.edu.vn",
    "company": "FPT University Can Tho Campus",
    "position": "Head of Corporate Relations Department",
    "address": "600 Nguyen Van Cu St. An Binh Ward, Ninh Kieu Dist. Cantho",
    "website": "https://cantho.fpt.edu.vn",
    "social_profiles": [],
    "detected_languages": ["vi", "en"],
    "confidence_score": 0.9537,
    "field_scores": []
  }
  ''';

  Future<List<ScannedDocument>> scanCard(List<String> imagePaths) async {
    if (userMock) {
      await Future.delayed(const Duration(seconds: 1));
      final uploadMap = jsonDecode(_mockUploadJson) as Map<String, dynamic>;
      final upload = UploadResponseModel.fromJson(uploadMap);
      final ocrMap = jsonDecode(_mockOcrJson) as Map<String, dynamic>;
      final ocr = OcrResponseModel.fromJson(ocrMap);
      return [OcrMapper.fromResponse(upload: upload, ocr: ocr)];
    }

    try {
      final files = await Future.wait(
        imagePaths.map(
          (p) => MultipartFile.fromFile(
            p,
            filename: p.split(RegExp(r'[/\\]')).last,
          ),
        ),
      );
      final uploadRes = await _cardService.uploadCard(
        files.first,
        files.length > 1 ? files[1] : null,
      );
      final uploadData = uploadRes.data;

      // Poll OCR với logging
      final ocrData = await _pollOcr(uploadData.processingId);
      return [OcrMapper.fromResponse(upload: uploadData, ocr: ocrData)];
    } on DioException catch (e) {
      String msg = e.message ?? "Network error";
      if (e.response?.data is Map) {
        final error = (e.response!.data as Map)['error'] as Map?;
        if (error?['message'] != null) msg = error!['message'] as String;
      }
      throw ServerException(msg);
    } on FormatException catch (e) {
      throw ServerException('Invalid response: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<OcrResponseModel> _pollOcr(String processingId) async {
    await Future.delayed(const Duration(seconds: 5));
    const maxRetries = 60;
    for (int i = 0; i < maxRetries; i++) {
      try {
        final ocrRes = await _cardService.getOcr(processingId);
        final ocrData = ocrRes.data;
        if (ocrData.confidenceScore != null) {
          return ocrData;
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 404 ||
            e.response?.statusCode == 409 ||
            e.response?.statusCode == 425) {
          // continue
        } else {
          rethrow;
        }
      } catch (e) {}
      await Future.delayed(const Duration(seconds: 2));
    }
    throw const ServerException("OCR processing timeout after 180s");
  }

  Future<ScannedDocument> updateCard(
    String id,
    Map<String, dynamic> data,
  ) async {
    if (userMock) {
      final map = jsonDecode(_mockOcrJson) as Map<String, dynamic>;
      final ocr = OcrResponseModel.fromJson(map);
      return OcrMapper.fromResponse(
        upload: UploadResponseModel(
          processingId: id,
          files: const [],
          status: "completed",
          uploadedAt: DateTime.now().toIso8601String(),
        ),
        ocr: ocr,
      );
    }

    try {
      final response = await _cardService.updateCard(id, data);
      final result = response.response.data;
      if (result == null) throw const ServerException("Update failed");

      return OcrMapper.fromResponse(
        upload: UploadResponseModel(
          processingId: id,
          files: const [],
          status: "completed",
          uploadedAt: DateTime.now().toIso8601String(),
        ),
        ocr: result,
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Network error");
    }
  }
}
