import 'package:cardly_app/domain/Entities/business_card_entity.dart';

class ContactMapper {
  static BusinessCardEntity fromJson(Map<String, dynamic> json) {
    return BusinessCardEntity(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      fullName: json['full_name'] as String?,
      jobTitle: json['job_title'] as String?,
      company: json['company'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      linkedIn: json['linkedin'] as String?,
      facebook: json['facebook'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      brief: json['brief'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)?.cast<String>(),
      highlights: (json['highlights'] as List<dynamic>?)?.cast<String>(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  static Map<String, dynamic> toJson(BusinessCardEntity contact) {
    return {
      'user_id': contact.userId,
      'full_name': contact.fullName,
      'job_title': contact.jobTitle,
      'company': contact.company,
      'phone': contact.phone,
      'email': contact.email,
      'website': contact.website,
      'linkedin': contact.linkedIn,
      'facebook': contact.facebook,
      'address': contact.address,
      'notes': contact.notes,
      'brief': contact.brief,
      'keywords': contact.keywords,
      'highlights': contact.highlights,
    };
  }

  static List<BusinessCardEntity> formJsonList(
    List<Map<String, dynamic>> jsonList,
  ) {
    return jsonList.map((e) => fromJson(e)).toList();
  }
}
