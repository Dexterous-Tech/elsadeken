class ApiResponseModel<T> {
  final T? data;
  final String message;
  final String type;
  final int status;
  final bool showToast;

  ApiResponseModel({
    this.data,
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiResponseModel<T>(
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? 0,
      showToast: json['showToast'] ?? false,
    );
  }

  bool get isSuccess => type == 'success' && status == 200;
}

