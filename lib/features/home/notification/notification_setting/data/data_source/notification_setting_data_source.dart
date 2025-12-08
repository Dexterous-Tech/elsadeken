import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/home/notification/notification_setting/data/model/notification_setting_model.dart';

class NotificationSettingDataSource {
  final ApiServices _apiServices;

  NotificationSettingDataSource(this._apiServices);

  /// Get notification settings
  Future<NotificationSettingResponseModel> getNotificationSettings() async {
    try {
      final response = await _apiServices.get(
        endpoint: ApiConstants.getNotificationSetting,
      );

      return NotificationSettingResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings(
    int id,
    UpdateNotificationSettingRequestModel request,
  ) async {
    try {
      await _apiServices.put(
        endpoint: ApiConstants.updateNotificationSetting(id),
        requestBody: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
