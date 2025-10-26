import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ErrorMessageHelper {
  /// Get localized error message from ApiErrorModel
  static String getLocalizedErrorFromModel(
      BuildContext context, ApiErrorModel error) {
    final localizations = AppLocalizations.of(context)!;
    return error.getLocalizedMessage(localizations);
  }
  static String getLocalizedMessage(BuildContext context, String errorKey) {
    final localizations = AppLocalizations.of(context)!;

    switch (errorKey) {
      // Chat List Errors
      case 'errorUpdatingChatList':
        return localizations.errorUpdatingChatList;
      case 'failedToReportUser':
        return localizations.failedToReportUser;
      case 'errorReportingUser':
        return localizations.errorReportingUser;
      case 'failedToUnreportUser':
        return localizations.failedToUnreportUser;
      case 'errorUnreportingUser':
        return localizations.errorUnreportingUser;
      case 'failedToMuteUser':
        return localizations.failedToMuteUser;
      case 'errorMutingUser':
        return localizations.errorMutingUser;
      case 'failedToDeleteChat':
        return localizations.failedToDeleteChat;
      case 'errorDeletingChat':
        return localizations.errorDeletingChat;
      case 'failedToDeleteAllChats':
        return localizations.failedToDeleteAllChats;
      case 'errorDeletingAllChats':
        return localizations.errorDeletingAllChats;
      case 'failedToLoadFavoritesList':
        return localizations.failedToLoadFavoritesList;
      case 'errorLoadingFavoritesList':
        return localizations.errorLoadingFavoritesList;
      case 'failedToUpdateFavoriteStatus':
        return localizations.failedToUpdateFavoriteStatus;
      case 'errorUpdatingFavoriteStatus':
        return localizations.errorUpdatingFavoriteStatus;
      case 'failedToRemoveFromFavorites':
        return localizations.failedToRemoveFromFavorites;
      case 'errorRemovingFromFavorites':
        return localizations.errorRemovingFromFavorites;

      // Chat Messages Errors
      case 'thisConversationNoLongerExists':
        return localizations.thisConversationNoLongerExists;
      case 'errorOccurred':
        return localizations.errorOccurred;

      // Chat Settings Errors
      case 'errorLoadingSettings':
        return localizations.errorLoadingSettings;
      case 'cannotUpdateSettingsBeforeLoading':
        return localizations.cannotUpdateSettingsBeforeLoading;
      case 'noChatSettingsContactSupport':
        return localizations.noChatSettingsContactSupport;
      case 'dataUpdatedSuccessfully':
        return localizations.dataUpdatedSuccessfully;
      case 'errorUpdatingSettings':
        return localizations.errorUpdatingSettings;
      case 'connectionTimeoutRetry':
        return localizations.connectionTimeoutRetry;
      case 'requestMethodError':
        return localizations.requestMethodError;
      case 'sessionExpiredRelogin':
        return localizations.sessionExpiredRelogin;
      case 'serverErrorTryLater':
        return localizations.serverErrorTryLater;
      case 'connectionTimeoutCheckInternet':
        return localizations.connectionTimeoutCheckInternet;
      case 'settingsNotFoundContactSupport':
        return localizations.settingsNotFoundContactSupport;

      // Network Errors
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

      // Default fallback
      default:
        return errorKey; // Return the key itself if not found
    }
  }
}
