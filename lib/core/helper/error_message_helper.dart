import 'package:elsadeken/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ErrorMessageHelper {
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

      // Default fallback
      default:
        return errorKey; // Return the key itself if not found
    }
  }
}
