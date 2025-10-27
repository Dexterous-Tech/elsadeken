import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elsadeken/core/helper/localization_helper.dart';

import 'api_error_model.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            message: LocalizationHelper.getLocalizedText(
              "انتهت مهلة الاتصال - يرجى التحقق من الإنترنت",
              "Connection timeout - please check your internet",
            ),
            errorKey: "connectionError",
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            message: LocalizationHelper.getLocalizedText(
              "تم إلغاء الطلب إلى الخادم",
              "Request to the server was cancelled",
            ),
            errorKey: "requestCancelled",
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            message: LocalizationHelper.getLocalizedText(
              "انتهت مهلة الاتصال - يرجى التحقق من الإنترنت",
              "Connection timeout - please check your internet",
            ),
            errorKey: "connectionTimeout",
          );
        case DioExceptionType.unknown:
          return ApiErrorModel(
            message: LocalizationHelper.getLocalizedText(
              "فشل الاتصال بالخادم بسبب انقطاع الإنترنت",
              "Connection to the server failed due to internet connection",
            ),
            errorKey: "noInternetConnection",
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            message: LocalizationHelper.getLocalizedText(
              "انتهت مهلة الاستلام من الخادم",
              "Receive timeout in connection with the server",
            ),
            errorKey: "receiveTimeout",
          );
        case DioExceptionType.badResponse:
          return _handleBadResponse(error);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            message: LocalizationHelper.getLocalizedText(
              "انتهت مهلة الإرسال في الاتصال بالخادم",
              "Send timeout in connection with the server",
            ),
            errorKey: "sendTimeout",
          );
        default:
          return ApiErrorModel(
            message: LocalizationHelper.getLocalizedText(
              "حدث خطأ ما",
              "Something went wrong",
            ),
            errorKey: "somethingWentWrong",
          );
      }
    } else {
      return ApiErrorModel(
        message: LocalizationHelper.getLocalizedText(
          "حدث خطأ غير معروف",
          "Unknown error occurred",
        ),
        errorKey: "unknownError",
      );
    }
  }

  static ApiErrorModel _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    try {
      if (data is Map<String, dynamic>) {
        return ApiErrorModel.fromJson(data, statusCode: statusCode);
      } else if (data is String) {
        try {
          final jsonData = jsonDecode(data) as Map<String, dynamic>;
          return ApiErrorModel.fromJson(jsonData, statusCode: statusCode);
        } catch (_) {
          return ApiErrorModel(
            message: data,
            statusCode: statusCode,
            rawData: data,
          );
        }
      }
    } catch (_) {
      return ApiErrorModel(
        message: "Failed to parse error response",
        errorKey: "failedToParseError",
        statusCode: statusCode,
        rawData: data,
      );
    }

    return ApiErrorModel(
      message: "Unexpected error format",
      errorKey: "unexpectedErrorFormat",
      statusCode: statusCode,
      rawData: data,
    );
  }
}
