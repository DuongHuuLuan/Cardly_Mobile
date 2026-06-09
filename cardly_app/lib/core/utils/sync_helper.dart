import 'package:cardly_app/core/enums/sync_status.dart';
import 'package:cardly_app/data/models/contact/contact_detail_response.dart';
import 'package:cardly_app/domain/Entities/business_card_entity.dart';
import 'package:uuid/uuid.dart';

class SyncHelper {
  static BusinessCardEntity mapDetailToEntity(
    ContactDetailResponse detail, {
    String? localId,
    DateTime? localCreatedAt,
  }) {
    return BusinessCardEntity(
      id: localId ?? const Uuid().v4(),
      processingId: detail.processingId,
      fullName: detail.normalizedFields.name,
      jobTitle: detail.normalizedFields.position,
      company: detail.normalizedFields.company,
      phone: detail.normalizedFields.phones.isNotEmpty
          ? detail.normalizedFields.phones.first
          : null,
      email: detail.normalizedFields.email,
      website: detail.normalizedFields.website,
      address: detail.normalizedFields.address,
      createdAt: localCreatedAt ?? DateTime.tryParse(detail.uploadedAt ?? ''),
      syncStatus: SyncStatus.synced,
    );
  }
}
