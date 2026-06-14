import 'package:cardly_app/data/models/scan_response_model.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/scanned_document.dart';

class ScannedDocumentMapper {
  static ScannedDocument fromResponse(ScanResponseModel response) {
    final data = response.rawData;
    return BusinessCardDocument(
      id: response.id,
      images: response.images,
      card: BusinessCardEntity(
        id: response.id,
        fullName: data['full_name'] as String?,
        jobTitle: data['job_title'] as String?,
        company: data['company'] as String?,
        phone: data['phone'] as String?,
        email: data['email'] as String?,
        website: data['website'] as String?,
        linkedIn: data['linkedin'] as String?,
        facebook: data['facebook'] as String?,
        address: data['address'] as String?,
        qrCodeContent: data['qr_code'] as String?,
        brief: data['brief'] as String?,
        keywords: (data['keywords'] as List?)?.cast<String>(),
        highlights: (data['highlights'] as List?)?.cast<String>(),
        createdAt: data['created_at'] != null
            ? DateTime.tryParse(data['created_at'] as String)
            : null,
      ),
    );
  }
}
