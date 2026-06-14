import 'package:cardly_app/data/models/ocr_response_model.dart';
import 'package:cardly_app/data/models/upload_response_model.dart';
import 'package:cardly_app/domain/entities/business_card_entity.dart';
import 'package:cardly_app/domain/entities/scanned_document.dart';

class OcrMapper {
  static BusinessCardDocument fromResponse({
    required UploadResponseModel upload,
    required OcrResponseModel ocr,
  }) {
    return BusinessCardDocument(
      id: upload.processingId,
      images: upload.files.map((f) => f.fileUrl).toList(),
      card: BusinessCardEntity(
        id: upload.processingId,
        processingId: upload.processingId,
        fullName: ocr.name,
        jobTitle: ocr.position,
        company: ocr.company,
        phone: ocr.phones?.isNotEmpty == true ? ocr.phones!.first : null,
        email: ocr.email,
        website: ocr.website,
        address: ocr.address,
        keywords: ocr.detectedLanguages,
      ),
    );
  }
}
