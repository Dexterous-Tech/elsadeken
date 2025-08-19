import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/notification_model.dart';
import '../../services/local_notification_service.dart';

abstract class NotificationApiService {
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20});
  Future<void> markNotificationAsRead(int notificationId);
  Future<void> markAllNotificationsAsRead();
  Future<void> clearAllNotifications();
  Future<void> updateFcmToken(String fcmToken);
}

class NotificationApiServiceImpl implements NotificationApiService {
  final ApiServices _apiServices;

  NotificationApiServiceImpl(this._apiServices);

  @override
  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiServices.get(
        endpoint: ApiConstants.notifications,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        requiresAuth: true,
      );

      final data = response.data['data'] as List;
      return data.map((json) => NotificationModel.fromApiJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      await _apiServices.post(
        endpoint: ApiConstants.markNotificationAsRead(notificationId),
        requestBody: {},
        requiresAuth: true,
      );
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _apiServices.post(
        endpoint: ApiConstants.markAllNotificationsAsRead,
        requestBody: {},
        requiresAuth: true,
      );
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  @override
  Future<void> clearAllNotifications() async {
    try {
      await _apiServices.delete(
        endpoint: ApiConstants.clearAllNotifications,
        requiresAuth: true,
      );
    } catch (e) {
      throw Exception('Failed to clear all notifications: $e');
    }
  }

  @override
  Future<void> updateFcmToken(String fcmToken) async {
    try {
      await _apiServices.post(
        endpoint: ApiConstants.updateFcmToken,
        requestBody: {'fcm_token': fcmToken},
        requiresAuth: true,
      );
    } catch (e) {
      throw Exception('Failed to update FCM token: $e');
    }
  }

  /// Initialize FCM and update token on server
  static Future<void> initializeFcmAndUpdateToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      
      // Initialize local notifications
      await LocalNotificationService.initialize();
      
      // Request permission
      await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      // Get FCM token
      final fcmToken = await messaging.getToken();
      if (fcmToken != null) {
        final apiService = await ApiServices.init();
        final notificationService = NotificationApiServiceImpl(apiService);
        await notificationService.updateFcmToken(fcmToken);
        
        print('FCM Token updated on server: $fcmToken');
      }

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('Received foreground message: ${message.notification?.title}');
        
        // Show local notification when app is in foreground
        await LocalNotificationService.showNotificationFromFirebaseMessage(message);
      });

      // Handle notification tap when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Notification tapped while app was in background');
        print('Message data: ${message.data}');
        // Handle navigation based on notification data
        _handleNotificationNavigation(message);
      });

      // Check for initial message (when app was terminated and opened by notification)
      RemoteMessage? initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        print('App opened from terminated state by notification');
        _handleNotificationNavigation(initialMessage);
      }

      // Listen to token refresh
      messaging.onTokenRefresh.listen((newToken) async {
        try {
          final apiService = await ApiServices.init();
          final notificationService = NotificationApiServiceImpl(apiService);
          await notificationService.updateFcmToken(newToken);
          print('FCM Token refreshed and updated: $newToken');
        } catch (e) {
          print('Failed to update refreshed FCM token: $e');
        }
      });

    } catch (e) {
      print('Failed to initialize FCM: $e');
    }
  }

  /// Handle navigation when notification is tapped
  static void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    
    // Example navigation logic based on notification type
    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'message':
          // Navigate to messages screen
          print('Navigate to messages: ${data['sender_id']}');
          break;
        case 'like':
          // Navigate to profile or likes screen
          print('Navigate to likes: ${data['user_id']}');
          break;
        case 'follow':
          // Navigate to profile screen
          print('Navigate to profile: ${data['user_id']}');
          break;
        default:
          // Navigate to notifications screen
          print('Navigate to notifications');
          break;
      }
    }
  }
}
