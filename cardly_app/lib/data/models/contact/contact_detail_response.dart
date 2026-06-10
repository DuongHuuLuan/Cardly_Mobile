class ContactDetailResponse {
  final String processingId;
  final String? status;
  final String? uploadedAt;
  final NormalizedFields normalizedFields;

  ContactDetailResponse({
    required this.processingId,
    this.status,
    this.uploadedAt,
    required this.normalizedFields,
  });

  factory ContactDetailResponse.fromJson(Map<String, dynamic> json) {
    return ContactDetailResponse(
      processingId: json['processing_id'] as String,
      status: json['status'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
      normalizedFields: NormalizedFields.fromJson(
        json['normalized_fields'] as Map<String, dynamic>,
      ),
    );
  }
}

class NormalizedFields {
  final String? name;
  final List<String> phones;
  final String? email;
  final String? company;
  final String? position;
  final String? address;
  final String? website;

  NormalizedFields({
    this.name,
    this.phones = const [],
    this.email,
    this.company,
    this.position,
    this.address,
    this.website,
  });

  factory NormalizedFields.fromJson(Map<String, dynamic> json) {
    return NormalizedFields(
      name: json['name'] as String?,
      phones: (json['phones'] as List?)?.cast<String>() ?? [],
      email: json['email'] as String?,
      company: json['company'] as String?,
      position: json['position'] as String?,
      address: json['address'] as String?,
      website: json['website'] as String?,
    );
  }
}
