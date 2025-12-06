/*
* class change depend on error json return in response
* this I make before to check in all key error because error's key change
* */
class ApiErrorModel {
  final String? message;
  final String? errorKey; // Key for localization
  final Map<String, dynamic>? fieldErrors;
  final int? statusCode;
  final bool? showToast;
  final dynamic rawData;

  ApiErrorModel({
    this.message,
    this.errorKey,
    this.fieldErrors,
    this.statusCode,
    this.showToast,
    this.rawData,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    String? message;

    // Known keys for generic messages
    final possibleMessageKeys = [
      'message',
      'detail',
      'error',
      'msg',
      'description'
    ];
    for (var key in possibleMessageKeys) {
      if (json.containsKey(key) && json[key] is String) {
        message = json[key];
        break;
      }
    }

    // Extract field-specific errors from "data" or "errors"
    Map<String, dynamic>? fieldErrors;
    if (json['data'] is Map) {
      fieldErrors = Map<String, dynamic>.from(json['data']);
    } else if (json['errors'] is Map) {
      fieldErrors = Map<String, dynamic>.from(json['errors']);
    }

    return ApiErrorModel(
      message: message,
      fieldErrors: fieldErrors,
      statusCode: statusCode ?? json['status'] as int?,
      showToast: json['showToast'] as bool?,
      rawData: json,
    );
  }

  /// Returns the best user-friendly message
  String get displayMessage {
    // 1. If there are field-specific errors, return all of them
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final messages = <String>[];

      fieldErrors!.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          messages.addAll(value.map((e) => e.toString()));
        } else if (value is String && value.isNotEmpty) {
          messages.add(value);
        }
      });

      if (messages.isNotEmpty) {
        return messages.join('\n'); // Join with newlines
      }
    }

    // 2. Otherwise return the general message
    if (message != null && message!.isNotEmpty) {
      return message!;
    }

    // 3. Fallback to HTTP status default
    if (statusCode != null) {
      return _getDefaultMessageForStatusCode(statusCode!);
    }

    // 4. Last resort
    return 'Unknown error occurred';
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
      case 422:
        return 'Validation error';
      case 500:
        return 'Internal server error';
      default:
        return 'Unknown error occurred';
    }
  }

  static String _getDefaultErrorKeyForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'badRequest';
      case 401:
        return 'unauthorized';
      case 403:
        return 'forbidden';
      case 404:
        return 'resourceNotFound';
      case 422:
        return 'validationError';
      case 500:
        return 'internalServerError';
      default:
        return 'unknownError';
    }
  }

  /// Get error key for localization
  String get localizationKey {
    if (errorKey != null) {
      return errorKey!;
    }
    if (statusCode != null) {
      return _getDefaultErrorKeyForStatusCode(statusCode!);
    }
    return 'unknownError';
  }

  /// Get localized error message
  /// Pass AppLocalizations to get the message in the current language
  String getLocalizedMessage(dynamic localizations) {
    // If the server returns a custom message, use it
    if (message != null && message!.isNotEmpty && errorKey == null) {
      return message!;
    }

    // Otherwise, use the localization key
    try {
      switch (localizationKey) {
        case 'connectionError':
          return localizations.connectionError;
        case 'requestCancelled':
          return localizations.requestCancelled;
        case 'connectionTimeout':
          return localizations.connectionTimeout;
        case 'noInternetConnection':
          return localizations.noInternetConnection;
        case 'receiveTimeout':
          return localizations.receiveTimeout;
        case 'sendTimeout':
          return localizations.sendTimeout;
        case 'somethingWentWrong':
          return localizations.somethingWentWrong;
        case 'unknownError':
          return localizations.unknownError;
        case 'badRequest':
          return localizations.badRequest;
        case 'unauthorized':
          return localizations.unauthorized;
        case 'forbidden':
          return localizations.forbidden;
        case 'resourceNotFound':
          return localizations.resourceNotFound;
        case 'validationError':
          return localizations.validationError;
        case 'internalServerError':
          return localizations.internalServerError;
        case 'failedToParseError':
          return localizations.failedToParseError;
        case 'unexpectedErrorFormat':
          return localizations.unexpectedErrorFormat;
        default:
          return message ?? localizations.unknownError;
      }
    } catch (e) {
      // Fallback to original message if localization fails
      return message ?? displayMessage;
    }
  }

  @override
  String toString() =>
      'ApiErrorModel(message: $message, errorKey: $errorKey, fieldErrors: $fieldErrors, statusCode: $statusCode, showToast: $showToast, rawData: $rawData)';
}
