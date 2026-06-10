class DeleteContactResponse {
  final String processingId;
  final String status;

  DeleteContactResponse({required this.processingId, required this.status});

  factory DeleteContactResponse.fromJson(Map<String, dynamic> json) {
    return DeleteContactResponse(
      processingId: json['processing_id'] as String,
      status: json['status'] as String,
    );
  }
}
