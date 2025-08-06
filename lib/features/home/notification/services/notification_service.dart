


// This service will be used for future API integration
import '../data/models/notification_model.dart';

class NotificationService {
  // TODO: Replace with actual API endpoints when available
  
  static Future<List<NotificationModel>> getNotifications() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data - replace with actual API call
    return [
      NotificationModel(
        id: '1',
        title: 'رسالة جديدة',
        body: 'رسالة من المستخدم osama97 تم إرسالها',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        type: NotificationType.message,
      ),
      NotificationModel(
        id: '2',
        title: 'رسالة جديدة',
        body: 'رسالة من المستخدم osama97 تم إرسالها',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        type: NotificationType.message,
      ),
      NotificationModel(
        id: '3',
        title: 'من يهتم بي؟',
        body: 'المستخدم osama97 بدأ يتابعك',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        type: NotificationType.follow,
      ),
    ];
  }

  static Future<void> markAsRead(String notificationId) async {
    // TODO: Implement API call
    // Example: await ApiClient.post('/notifications/$notificationId/read');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> markAllAsRead() async {
    // TODO: Implement API call
    // Example: await ApiClient.post('/notifications/mark-all-read');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> deleteNotification(String notificationId) async {
    // TODO: Implement API call
    // Example: await ApiClient.delete('/notifications/$notificationId');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> clearAllNotifications() async {
    // TODO: Implement API call
    // Example: await ApiClient.delete('/notifications');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<int> getUnreadCount() async {
    // TODO: Implement API call
    // Example: final response = await ApiClient.get('/notifications/unread-count');
    await Future.delayed(const Duration(milliseconds: 300));
    return 2; // Mock unread count
  }
}