// import 'package:elsadeken/features/home/notification/data/repo/notification_repository.dart';
// import 'package:elsadeken/features/home/notification/data/model/notification_model.dart';

// abstract class NotificationService {
//   Future<List<NotificationModel>> getNotifications();
//   Future<void> markNotificationAsRead(String notificationId);
//   Future<void> markAllNotificationsAsRead();
//   Future<void> clearAllNotifications();
// }

// class NotificationServiceImpl implements NotificationService {
//   final NotificationRepository _repository;

//   NotificationServiceImpl(this._repository);

//   @override
//   Future<List<NotificationModel>> getNotifications() async {
//     return await _repository.getNotifications();
//   }

//   @override
//   Future<void> markNotificationAsRead(String notificationId) async {
//     return await _repository.markNotificationAsRead(notificationId);
//   }

//   @override
//   Future<void> markAllNotificationsAsRead() async {
//     return await _repository.markAllNotificationsAsRead();
//   }

//   @override
//   Future<void> clearAllNotifications() async {
//     return await _repository.clearAllNotifications();
//   }
// }
