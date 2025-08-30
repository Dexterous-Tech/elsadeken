import 'dart:developer';

import 'package:elsadeken/features/profile/manage_profile/data/models/my_profile_response_model.dart';
import 'package:elsadeken/features/profile/profile/data/repo/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/shared/shared_preferences_helper.dart';
import '../../../../../core/shared/shared_preferences_key.dart';

part 'notification_settings_profile_state.dart';

class NotificationSettingsProfileCubit
    extends Cubit<NotificationSettingsProfileState> {
  NotificationSettingsProfileCubit(this._profileRepoInterface)
      : super(NotificationSettingsProfileInitial());

  final ProfileRepoInterface _profileRepoInterface;
  MyProfileResponseModel? _profileData;

  /// Set profile data and load notification settings based on is_notifable
  void setProfileData(MyProfileResponseModel profileData) {
    _profileData = profileData;
    log('🔔 Profile data set - isNotifable: ${profileData.data?.isNotifable}');
    log('🔔 Profile data type: ${profileData.data?.isNotifable.runtimeType}');
    log('🔔 Profile data value: ${profileData.data?.isNotifable}');
    log('🔔 Profile data is null: ${profileData.data?.isNotifable == null}');
    _loadNotificationSettingsFromProfile();
  }

  /// Load notification settings from profile data
  void _loadNotificationSettingsFromProfile() {
    log('🔔 _loadNotificationSettingsFromProfile called');
    log('🔔 _profileData is null: ${_profileData == null}');
    log('🔔 _profileData.data is null: ${_profileData?.data == null}');
    log('🔔 _profileData.data.isNotifable is null: ${_profileData?.data?.isNotifable == null}');
    log('🔔 _profileData.data.isNotifable value: ${_profileData?.data?.isNotifable}');
    log('🔔 _profileData.data.isNotifable type: ${_profileData?.data?.isNotifable.runtimeType}');

    if (_profileData?.data?.isNotifable != null) {
      bool isEnabled = _profileData!.data!.isNotifable == 1;
      emit(NotificationSettingsProfileLoaded(isEnabled: isEnabled));
      log('🔔 Notification settings loaded from profile: isNotifable=${_profileData!.data!.isNotifable}, isEnabled=$isEnabled');
    } else {
      // If no profile data, try to load from SharedPreferences as fallback
      _loadFromSharedPreferencesFallback();
    }
  }

  /// Load notification settings from SharedPreferences as fallback
  void _loadFromSharedPreferencesFallback() async {
    try {
      final bool? isNotifable = await SharedPreferencesHelper.getBool(
          SharedPreferencesKey.isNotifable);

      if (isNotifable != null) {
        emit(NotificationSettingsProfileLoaded(isEnabled: isNotifable));
        log('🔔 Notification settings loaded from SharedPreferences fallback: $isNotifable');
      } else {
        // Default to false if no data available anywhere
        emit(NotificationSettingsProfileLoaded(isEnabled: false));
        log('🔔 Notification settings loaded: false (default) - no data available');
      }
    } catch (e) {
      log('🔔 Error loading from SharedPreferences fallback: $e');
      emit(NotificationSettingsProfileLoaded(isEnabled: false));
    }
  }

  /// Load notification settings from API
  Future<void> loadNotificationSettings() async {
    try {
      emit(NotificationSettingsProfileLoading());

      // Use profile data if available, otherwise default to false
      if (_profileData?.data?.isNotifable != null) {
        bool isEnabled = _profileData!.data!.isNotifable == 1;
        emit(NotificationSettingsProfileLoaded(isEnabled: isEnabled));
        log('Notification settings loaded from profile: $isEnabled');
      } else {
        // Default to false since we're not storing local state
        // In the future, you might want to add an API endpoint to get current notification status
        emit(NotificationSettingsProfileLoaded(isEnabled: false));
        log('Notification settings loaded: false (default)');
      }
    } catch (e) {
      log('Error loading notification settings: $e');
      emit(NotificationSettingsError('Failed to load notification settings'));
    }
  }

  /// Toggle notification settings using API only
  Future<void> toggleNotificationWithApi(bool enabled) async {
    try {
      emit(NotificationSettingsProfileLoading());

      // Call the API to toggle notifications
      final result = await _profileRepoInterface.toggleNotify();

      result.fold(
        (error) {
          log('Error from API: ${error.message}');
          emit(NotificationSettingsError(
              error.message ?? 'Failed to toggle notification settings'));
        },
        (response) async {
          // Update local profile data to reflect the change
          if (_profileData?.data != null) {
            _profileData!.data!.isNotifable = enabled ? 1 : 0;
          }
// Save to prefs as well
          await SharedPreferencesHelper.setBool(
              SharedPreferencesKey.isNotifable, enabled);
          // Don't update local Firebase service - keep it always active
          // Only update the server-side notification preference

          emit(NotificationSettingsToggleSuccess(
              isEnabled: enabled,
              message: response.message ??
                  'Notification settings updated successfully'));
          log('Notification settings toggled via API to: $enabled');
        },
      );
    } catch (e) {
      log('Error toggling notification settings with API: $e');
      emit(NotificationSettingsError('Failed to toggle notification settings'));
    }
  }

  Future<void> loadNotificationFromPrefs() async {
    try {
      emit(NotificationSettingsProfileLoading());

      final bool? isNotifable = await SharedPreferencesHelper.getBool(
          SharedPreferencesKey.isNotifable);

      if (isNotifable != null) {
        emit(NotificationSettingsProfileLoaded(isEnabled: isNotifable));
        log("🔔 Loaded notification setting from prefs: $isNotifable");
      } else {
        emit(NotificationSettingsProfileLoaded(isEnabled: false));
        log("🔔 No value in prefs, defaulting to false");
      }
    } catch (e) {
      log("❌ Error loading notification from prefs: $e");
      emit(NotificationSettingsError("Failed to load local settings"));
    }
  }
}
