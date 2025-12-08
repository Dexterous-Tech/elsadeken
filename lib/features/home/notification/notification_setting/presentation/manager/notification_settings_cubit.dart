import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elsadeken/features/home/notification/notification_setting/data/model/notification_setting_model.dart';
import 'package:elsadeken/features/home/notification/notification_setting/data/repo/notification_setting_repo.dart';

part 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final NotificationSettingRepoInterface _notificationSettingRepo;

  NotificationSettingDataModel? _currentSettings;

  NotificationSettingsCubit(this._notificationSettingRepo)
      : super(NotificationSettingsInitial());

  /// Load notification settings from API
  Future<void> loadNotificationSettings({
    String? whoAddedMeToFavorites,
    String? profileVisits,
    String? whoAddedMeToIgnoreList,
    String? newMessages,
    String? successStories,
    String? errorMessage,
  }) async {
    try {
      emit(NotificationSettingsLoading());

      final response = await _notificationSettingRepo.getNotificationSettings();

      if (response.data != null) {
        _currentSettings = response.data;

        final settingsData = _currentSettings!;

        // Convert the single data object to a list format for UI

        // Convert settings to list with localized titles
        List<Map<String, dynamic>> settingsList = settingsData.toSettingsList(
          whoAddedMeToFavorites: whoAddedMeToFavorites,
          profileVisits: profileVisits,
          whoAddedMeToIgnoreList: whoAddedMeToIgnoreList,
          newMessages: newMessages,
          successStories: successStories,
        );

        emit(NotificationSettingsLoaded(settings: settingsList));

      } else {
        emit(NotificationSettingsError(
            errorMessage ?? 'No notification settings found'));
      }
    } catch (e) {

      emit(NotificationSettingsError(
          errorMessage ?? 'Failed to load notification settings'));
    }
  }

  /// Toggle notification setting
  Future<void> toggleNotificationSetting(
    String settingId,
    bool isActive, {
    required String settingTitle,
    required String actionDescription,
    required String noCurrentSettingsError,
    required String toggleError,
  }) async {
    try {
      // Use cached settings to create the update request. Fallback to API if cache is empty.
      NotificationSettingDataModel? currentData = _currentSettings;
      if (currentData == null) {
        final currentResponse =
            await _notificationSettingRepo.getNotificationSettings();
        if (currentResponse.data == null) {
          throw Exception(noCurrentSettingsError);
        }
        currentData = currentResponse.data!;
        _currentSettings = currentData;
      }

      final id = currentData.id ?? 0;

      final updatedValues = <String, bool>{
        'favorite_list': settingId == 'favorite_list'
            ? isActive
            : currentData.favoriteList ?? false,
        'visit_profile': settingId == 'visit_profile'
            ? isActive
            : currentData.visitProfile ?? false,
        'ignore_list': settingId == 'ignore_list'
            ? isActive
            : currentData.ignoreList ?? false,
        'message':
            settingId == 'message' ? isActive : currentData.message ?? false,
        'blog': settingId == 'blog' ? isActive : currentData.blog ?? false,
      };

      // Create update request with ALL fields so backend receives the complete state.
      final updateRequest = UpdateNotificationSettingRequestModel(
        favoriteList: updatedValues['favorite_list']! ? 1 : 0,
        visitProfile: updatedValues['visit_profile']! ? 1 : 0,
        ignoreList: updatedValues['ignore_list']! ? 1 : 0,
        message: updatedValues['message']! ? 1 : 0,
        blog: updatedValues['blog']! ? 1 : 0,
      );

      // Send update request
      await _notificationSettingRepo.updateNotificationSettings(
        id,
        updateRequest,
      );

      currentData.favoriteList = updatedValues['favorite_list']!;
      currentData.visitProfile = updatedValues['visit_profile']!;
      currentData.ignoreList = updatedValues['ignore_list']!;
      currentData.message = updatedValues['message']!;
      currentData.blog = updatedValues['blog']!;
      _currentSettings = currentData;

      // Update local state without reloading from API
      final currentState = state;
      List<Map<String, dynamic>>? currentSettingsList;
      if (currentState is NotificationSettingsLoaded) {
        currentSettingsList = currentState.settings;
      } else if (currentState is NotificationSettingsSuccess) {
        currentSettingsList = currentState.settings;
      }

      if (currentSettingsList != null) {
        final updatedSettings = currentSettingsList.map((setting) {
          if (setting['id'] == settingId) {
            final newValue = updatedValues[settingId] ?? isActive;
            return {
              ...setting,
              'value': newValue,
            };
          }
          return setting;
        }).toList();

        // Emit success state with message
        emit(NotificationSettingsSuccess(
          message: '$settingTitle - $actionDescription',
          settings: updatedSettings,
        ));

        // After a short delay, go back to loaded state
        Future.delayed(const Duration(seconds: 2), () {
          if (state is NotificationSettingsSuccess) {
            emit(NotificationSettingsLoaded(settings: updatedSettings));
          }
        });
      }

    } catch (e) {

      emit(NotificationSettingsError(toggleError));
    }
  }
}
