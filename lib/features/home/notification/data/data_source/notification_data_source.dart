import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/home/notification/data/model/Notification_count_response_model.dart';
import 'package:elsadeken/features/home/notification/data/model/notification_response_model.dart';

abstract class NotificationDataSource {
  Future<NotificationResponseModel> getNotifications({int? page});
  Future<NotificationCountResponseModel> countNotifications();
}

class NotificationDataSourceImpl implements NotificationDataSource {
  final ApiServices _apiServices;

  NotificationDataSourceImpl(this._apiServices);

  @override
  Future<NotificationResponseModel> getNotifications({int? page}) async {
    try {
      final response = await _apiServices.get(
        endpoint: ApiConstants.getNotifications,
        queryParameters: page != null ? {'page': page} : null,
      );

      return NotificationResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<NotificationCountResponseModel> countNotifications() async {
    var response =
        await _apiServices.get(endpoint: ApiConstants.countNotifications);

    return NotificationCountResponseModel.fromJson(response.data);
  }
}
