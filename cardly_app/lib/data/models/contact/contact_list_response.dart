class ContactListResponse {
  final List<ContactItemResponse> items;
  final int total;
  final int skip;
  final int limit;

  ContactListResponse({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ContactListResponse.fromJson(Map<String, dynamic> json) {
    return ContactListResponse(
      items: (json['items'] as List)
          .map((e) => ContactItemResponse.fromJson(e))
          .toList(),
      total: json['total'] as int,
      skip: json['skip'] as int,
      limit: json['limit'] as int,
    );
  }
}

class ContactItemResponse {
  final String processingId;
  final String? originalFilename;
  final String? mimeType;
  final int? fileSize;
  final String? status;
  final String uploadedAt;
  final List<String> fileUrls;

  ContactItemResponse({
    required this.processingId,
    this.originalFilename,
    this.mimeType,
    this.fileSize,
    this.status,
    required this.uploadedAt,
    required this.fileUrls,
  });

  factory ContactItemResponse.fromJson(Map<String, dynamic> json) {
    return ContactItemResponse(
      processingId: json['processing_id'] as String,
      originalFilename: json['original_filename'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSize: json['file_size'] as int?,
      status: json['status'] as String?,
      uploadedAt: json['uploaded_at'] as String,
      fileUrls: (json['file_urls'] as List).cast<String>(),
    );
  }
}
