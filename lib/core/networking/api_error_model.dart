/*
* class change depend on error json return in response
* this I make before to check in all key error because error's key change
* */
class ApiErrorModel {
  final String? message;
  final Map<String, dynamic>? errors;
  final int? statusCode;

  ApiErrorModel({this.message, this.errors, this.statusCode});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    return ApiErrorModel(
      message: json['message'] ?? json['detail'] ?? json['error'],
      errors: json['errors'] is Map ? json['errors'] : null,
      statusCode: statusCode,
    );
  }

  String get displayMessage {
    if (message != null) return message!;
    if (errors != null) {
      // Handle field-specific errors (e.g., {"email": ["Invalid email"]})
      final firstError = errors!.values.first;
      if (firstError is List) return firstError.first.toString();
      if (firstError is String) return firstError;
    }
    return statusCode != null
        ? _getDefaultMessageForStatusCode(statusCode!)
        : 'Unknown error occurred';
  }

  static String _getDefaultMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Unknown error occurred';
    }
  }

  @override
  String toString() =>
      'ApiErrorModel(message: $message, errors: $errors, statusCode: $statusCode)';
}
