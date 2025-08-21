import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/home/notification/data/data_source/notification_data_source.dart';
import 'package:elsadeken/features/home/notification/data/model/notification_response_model.dart';
import 'package:elsadeken/features/home/notification/data/model/notification_model.dart';

abstract class NotificationRepoInterface {
  Future<
      ({
        List<NotificationModel> notifications,
        bool hasNextPage,
        int currentPage
      })> getNotifications({int? page});
}

class NotificationRepoImp implements NotificationRepoInterface {
  final NotificationDataSource notificationDataSource;

  NotificationRepoImp(this.notificationDataSource);

  @override
  Future<
      ({
        List<NotificationModel> notifications,
        bool hasNextPage,
        int currentPage
      })> getNotifications({int? page}) async {
    try {
      final response =
          await notificationDataSource.getNotifications(page: page);

      final notifications = response.data
              ?.map(
                  (item) => NotificationModel.fromResponseModel(item.toJson()))
              .toList() ??
          [];

      final hasNextPage =
          response.links?.next != null && response.links!.next != false;
      final currentPage = response.meta?.currentPage ?? 1;

      return (
        notifications: notifications,
        hasNextPage: hasNextPage,
        currentPage: currentPage,
      );
    } catch (e) {
      if (e is ApiErrorModel) {
        throw ApiErrorModel(
          message: e.message ?? 'Failed to get notifications',
          statusCode: e.statusCode,
        );
      }
      throw ApiErrorModel(
        message: 'Failed to get notifications: $e',
        statusCode: 500,
      );
    }
  }
}
