class BaseResponse<T> {
  final T? data;
  final String? message;
  final int? status;
  final bool? success;

  BaseResponse({this.data, this.message, this.status, this.success});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse<T>(
      data: json['data'],
      message: json['message'],
      status: json['status'] != null ? json['status'] as int : null,
      success: json['success'] != null ? json['success'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'message': message,
      'status': status,
      'success': success,
    };
  }
}
