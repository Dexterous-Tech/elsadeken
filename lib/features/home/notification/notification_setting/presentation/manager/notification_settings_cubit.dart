import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:elsadeken/features/home/notification/notification_setting/data/model/notification_setting_model.dart';
import 'package:elsadeken/features/home/notification/notification_setting/data/repo/notification_setting_repo.dart';

part 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final NotificationSettingRepoInterface _notificationSettingRepo;

  NotificationSettingsCubit(this._notificationSettingRepo)
      : super(NotificationSettingsInitial());

  /// Load notification settings from API
  Future<void> loadNotificationSettings() async {
    try {
      emit(NotificationSettingsLoading());

      final response = await _notificationSettingRepo.getNotificationSettings();

      if (response.data != null) {
        log('Response data type: ${response.data.runtimeType}');
        log('Response data: ${response.data}');

        // Convert the single data object to a list format for UI
        log('About to call toSettingsList() on: ${response.data}');
        log('Available methods: ${response.data.runtimeType.toString()}');

        // Try to call the method using reflection as a fallback
        List<Map<String, dynamic>> settingsList;
        try {
          settingsList = response.data!.toSettingsList();
        } catch (e) {
          log('Error calling toSettingsList(): $e');
          // Fallback: create the list manually
          settingsList = [
            {
              'id': 'favorite_list',
              'title': 'من وضعني في قائمته المفضلة؟',
              'value': response.data!.favoriteList ?? false,
            },
            {
              'id': 'visit_profile',
              'title': 'زيارات ملفي الشخصي',
              'value': response.data!.visitProfile ?? false,
            },
            {
              'id': 'ignore_list',
              'title': 'من أضافني إلى قائمة التجاهل؟',
              'value': response.data!.ignoreList ?? false,
            },
            {
              'id': 'message',
              'title': 'رسائل جديدة',
              'value': response.data!.message ?? false,
            },
            {
              'id': 'blog',
              'title': 'قصص ناجحة',
              'value': response.data!.blog ?? false,
            },
            {
              'id': 'ring',
              'title': 'إشعار نغمة الرنين',
              'value': response.data!.ring ?? false,
            },
            {
              'id': 'vibration',
              'title': 'تنبيه بالاهتزاز',
              'value': response.data!.vibration ?? false,
            },
          ];
        }
        log('Settings list: $settingsList');
        emit(NotificationSettingsLoaded(settings: settingsList));
        log('Notification settings loaded: ${settingsList.length} settings');
      } else {
        emit(NotificationSettingsError('No notification settings found'));
      }
    } catch (e) {
      log('Error loading notification settings: $e');
      emit(NotificationSettingsError('Failed to load notification settings'));
    }
  }

  /// Toggle notification setting
  Future<void> toggleNotificationSetting(
      String settingId, bool isActive) async {
    try {
      // Get current settings to create the update request
      final currentResponse =
          await _notificationSettingRepo.getNotificationSettings();
      if (currentResponse.data == null) {
        throw Exception('No current settings found');
      }

      final currentData = currentResponse.data!;
      final id = currentData.id ?? 0;

      // Create update request with ALL fields - the changed field gets new value, others keep current values
      UpdateNotificationSettingRequestModel updateRequest =
          UpdateNotificationSettingRequestModel(
        favoriteList: settingId == 'favorite_list'
            ? (isActive ? 1 : 0)
            : (currentData.favoriteList == true ? 1 : 0),
        visitProfile: settingId == 'visit_profile'
            ? (isActive ? 1 : 0)
            : (currentData.visitProfile == true ? 1 : 0),
        ignoreList: settingId == 'ignore_list'
            ? (isActive ? 1 : 0)
            : (currentData.ignoreList == true ? 1 : 0),
        message: settingId == 'message'
            ? (isActive ? 1 : 0)
            : (currentData.message == true ? 1 : 0),
        blog: settingId == 'blog'
            ? (isActive ? 1 : 0)
            : (currentData.blog == true ? 1 : 0),
        ring: settingId == 'ring'
            ? (isActive ? 1 : 0)
            : (currentData.ring == true ? 1 : 0),
        vibration: settingId == 'vibration'
            ? (isActive ? 1 : 0)
            : (currentData.vibration == true ? 1 : 0),
      );

      // Send update request
      await _notificationSettingRepo.updateNotificationSettings(
        id,
        updateRequest,
      );

      log('Setting $settingId updated to: ${isActive ? 1 : 0}');

      // Update local state without reloading from API
      final currentState = state;
      if (currentState is NotificationSettingsLoaded) {
        final updatedSettings = currentState.settings.map((setting) {
          if (setting['id'] == settingId) {
            return {
              ...setting,
              'value': isActive,
            };
          }
          return setting;
        }).toList();

        // Emit success state with message
        final settingTitle = _getSettingTitle(settingId);
        final actionDescription = _getActionDescription(settingId, isActive);
        emit(NotificationSettingsSuccess(
          message: 'تم تحديث $settingTitle - $actionDescription',
          settings: updatedSettings,
        ));

        // After a short delay, go back to loaded state
        Future.delayed(const Duration(seconds: 2), () {
          if (state is NotificationSettingsSuccess) {
            emit(NotificationSettingsLoaded(settings: updatedSettings));
          }
        });
      }

      log('Notification setting toggled: ID $settingId, Active: $isActive');
    } catch (e) {
      log('Error toggling notification setting: $e');
      emit(NotificationSettingsError('Failed to toggle notification setting'));
    }
  }

  /// Get the Arabic title for a setting ID
  String _getSettingTitle(String settingId) {
    switch (settingId) {
      case 'favorite_list':
        return 'من وضعني في قائمته المفضلة؟';
      case 'visit_profile':
        return 'زيارات ملفي الشخصي';
      case 'ignore_list':
        return 'من أضافني إلى قائمة التجاهل؟';
      case 'message':
        return 'رسائل جديدة';
      case 'blog':
        return 'قصص ناجحة';
      case 'ring':
        return 'إشعار نغمة الرنين';
      case 'vibration':
        return 'تنبيه بالاهتزاز';
      default:
        return 'الإعداد';
    }
  }

  /// Get detailed action description for a setting
  String _getActionDescription(String settingId, bool isActive) {
    if (isActive) {
      switch (settingId) {
        case 'favorite_list':
          return 'سيتم إعلامك عند وضعك في قائمة المفضلة';
        case 'visit_profile':
          return 'سيتم إعلامك عند زيارة ملفك الشخصي';
        case 'ignore_list':
          return 'سيتم إعلامك عند إضافتك لقائمة التجاهل';
        case 'message':
          return 'سيتم إعلامك عند استلام رسائل جديدة';
        case 'blog':
          return 'سيتم إعلامك عند نشر قصص ناجحة';
        case 'ring':
          return 'سيتم تشغيل نغمة الرنين للإشعارات';
        case 'vibration':
          return 'سيتم تفعيل الاهتزاز للإشعارات';
        default:
          return 'يسمح بتلقي الإشعارات';
      }
    } else {
      switch (settingId) {
        case 'favorite_list':
          return 'لن يتم إعلامك عند وضعك في قائمة المفضلة';
        case 'visit_profile':
          return 'لن يتم إعلامك عند زيارة ملفك الشخصي';
        case 'ignore_list':
          return 'لن يتم إعلامك عند إضافتك لقائمة التجاهل';
        case 'message':
          return 'لن يتم إعلامك عند استلام رسائل جديدة';
        case 'blog':
          return 'لن يتم إعلامك عند نشر قصص ناجحة';
        case 'ring':
          return 'لن يتم تشغيل نغمة الرنين للإشعارات';
        case 'vibration':
          return 'لن يتم تفعيل الاهتزاز للإشعارات';
        default:
          return 'لا يسمح بتلقي الإشعارات';
      }
    }
  }
}
