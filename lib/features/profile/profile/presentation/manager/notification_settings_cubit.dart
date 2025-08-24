import 'dart:developer';

import 'package:elsadeken/core/services/firebase_notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit() : super(NotificationSettingsInitial());

  final FirebaseNotificationService _notificationService =
      FirebaseNotificationService.instance;

  /// Load notification settings
  Future<void> loadNotificationSettings() async {
    try {
      emit(NotificationSettingsLoading());

      final isEnabled = await _notificationService.isNotificationEnabled();

      emit(NotificationSettingsLoaded(isEnabled: isEnabled));
      log('Notification settings loaded: $isEnabled');
    } catch (e) {
      log('Error loading notification settings: $e');
      emit(NotificationSettingsError('Failed to load notification settings'));
    }
  }

  /// Toggle notification settings
  Future<void> toggleNotifications(bool enabled) async {
    try {
      emit(NotificationSettingsLoading());

      await _notificationService.toggleNotifications(enabled);

      emit(NotificationSettingsLoaded(isEnabled: enabled));
      log('Notification settings toggled to: $enabled');
    } catch (e) {
      log('Error toggling notification settings: $e');
      emit(NotificationSettingsError('Failed to toggle notification settings'));
    }
  }
}
