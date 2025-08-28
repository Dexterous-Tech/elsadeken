import 'package:elsadeken/features/home/notification/notification_setting/data/data_source/notification_setting_data_source.dart';
import 'package:elsadeken/features/home/notification/notification_setting/data/model/notification_setting_model.dart';

abstract class NotificationSettingRepoInterface {
  Future<NotificationSettingResponseModel> getNotificationSettings();
  Future<void> updateNotificationSettings(
    int id,
    UpdateNotificationSettingRequestModel request,
  );
}

class NotificationSettingRepoImp implements NotificationSettingRepoInterface {
  final NotificationSettingDataSource _notificationSettingDataSource;

  NotificationSettingRepoImp(this._notificationSettingDataSource);

  @override
  Future<NotificationSettingResponseModel> getNotificationSettings() async {
    return await _notificationSettingDataSource.getNotificationSettings();
  }

  @override
  Future<void> updateNotificationSettings(
    int id,
    UpdateNotificationSettingRequestModel request,
  ) async {
    return await _notificationSettingDataSource.updateNotificationSettings(
      id,
      request,
    );
  }
}
