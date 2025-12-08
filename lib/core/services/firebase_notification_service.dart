import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import '../../features/chat/data/services/chat_message_service.dart';

@pragma('vm:entry-point')
class FirebaseNotificationService {
  static FirebaseNotificationService? _instance;
  static FirebaseNotificationService get instance {
    _instance ??= FirebaseNotificationService._internal();
    return _instance!;
  }

  FirebaseNotificationService._internal();

  FirebaseMessaging? _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // Store listeners for proper disposal
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;

  // Notification channel for Android
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  // Global variable to handle background messages
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Check if notifications are enabled
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;

    // If notifications are disabled, don't process anything
    if (!notificationsEnabled) {
      return;
    }

    // IMPORTANT: Don't manually show notifications here!
    // Firebase automatically displays notifications when app is in background/terminated
    // Manually showing would cause duplicate notifications
    // Only trigger refresh logic, not notification display

    // Always trigger chat refresh for background messages (if it's a chat notification)
    _triggerBackgroundChatRefresh(message);
  }

  /// Trigger chat refresh for background messages
  @pragma('vm:entry-point')
  static void _triggerBackgroundChatRefresh(RemoteMessage message) {
    try {
      // Check if this is a chat-related notification
      final notificationTitle =
          message.notification?.title?.toLowerCase() ?? '';
      final notificationBody = message.notification?.body?.toLowerCase() ?? '';

      // Check if it's a chat message notification
      if (notificationTitle.contains('رساله') ||
          notificationTitle.contains('message') ||
          notificationBody.contains('رساله') ||
          notificationBody.contains('message') ||
          message.data.containsKey('chat_id') ||
          message.data.containsKey('message_id')) {
        // Store a flag that the app should refresh chats when it becomes active
        // This will be handled by the main app when it resumes
        _storeChatRefreshFlag();
      }
    } catch (e) {
      // exception
    }
  }

  /// Store flag for chat refresh when app becomes active
  @pragma('vm:entry-point')
  static Future<void> _storeChatRefreshFlag() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('chat_refresh_needed', true);
      await prefs.setString(
        'chat_refresh_timestamp',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      // exception
    }
  }

  /// Initialize Firebase and notification services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize messaging after Firebase is ready
      _messaging = FirebaseMessaging.instance;

      // Configure Firebase to NOT automatically show notifications
      // This prevents duplicate notifications
      await _messaging!.setForegroundNotificationPresentationOptions(
        alert: false, // Don't show notification alert automatically
        badge: false, // Don't update badge automatically
        sound: false, // Don't play sound automatically
      );

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Request notification permissions
      await _requestNotificationPermissions();

      // Setup local notifications
      await _setupLocalNotifications();

      // Setup Firebase messaging listeners
      await _setupFirebaseMessaging();

      _isInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    if (_messaging == null) {
      return;
    }

    await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get FCM token
    await _messaging!.getToken();
  }

  /// Setup local notifications
  Future<void> _setupLocalNotifications() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    // Create notification channel for Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  /// Setup Firebase messaging listeners
  Future<void> _setupFirebaseMessaging() async {
    if (_messaging == null) {
      return;
    }

    // Dispose existing listeners first
    await _disposeListeners();

    // Handle foreground messages
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) async {
      // Check if notifications are enabled before showing
      bool enabled = await isNotificationEnabled();
      if (enabled) {
        _showLocalNotification(message);
      } else {}

      // Always trigger chat refresh when Firebase notification is received
      // This ensures chat list and conversations are updated even if local notification is disabled
      _triggerChatRefresh(message);
    });

    // Handle when app is opened from notification
    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage message,
    ) async {
      // Only handle navigation if notifications are enabled
      bool enabled = await isNotificationEnabled();
      if (enabled) {
        _handleNotificationNavigation(message);
      }
    });

    // Handle initial notification when app is launched from terminated state
    RemoteMessage? initialMessage = await _messaging!.getInitialMessage();
    if (initialMessage != null) {
      // Only handle navigation if notifications are enabled
      bool enabled = await isNotificationEnabled();
      if (enabled) {
        _handleNotificationNavigation(initialMessage);
      }
    }
  }

  /// Dispose Firebase messaging listeners
  Future<void> _disposeListeners() async {
    await _foregroundSubscription?.cancel();
    _foregroundSubscription = null;

    await _openedAppSubscription?.cancel();
    _openedAppSubscription = null;
  }

  /// Show local notification
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      // For Android, use Android-specific settings
      if (defaultTargetPlatform == TargetPlatform.android) {
        AndroidNotification? android = message.notification?.android;
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android?.smallIcon ?? '@mipmap/launcher_icon',
              // Add these for better foreground notification display
              importance: Importance.high,
              priority: Priority.high,
              showWhen: true,
              enableVibration: true,
              playSound: true,
            ),
          ),
        );
      } else {
        // For iOS and other platforms
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(),
        );
      }
    } else {}
  }

  /// Handle notification navigation
  void _handleNotificationNavigation(RemoteMessage message) {
    // Handle navigation based on notification data
    // You can add your navigation logic here based on message.data
  }

  /// Trigger chat refresh when Firebase notification is received
  void _triggerChatRefresh(RemoteMessage message) {
    try {
      // Check if this is a chat-related notification
      final notificationTitle =
          message.notification?.title?.toLowerCase() ?? '';
      final notificationBody = message.notification?.body?.toLowerCase() ?? '';

      // Check if it's a chat message notification
      if (notificationTitle.contains('رساله') ||
          notificationTitle.contains('message') ||
          notificationBody.contains('رساله') ||
          notificationBody.contains('message') ||
          message.data.containsKey('chat_id') ||
          message.data.containsKey('message_id')) {
        // Trigger chat list refresh through the message service
        ChatMessageService.instance.triggerFirebaseChatRefresh();

        // You can also add specific chat updates if you have chat_id in the data
        if (message.data.containsKey('chat_id')) {
          final chatId = int.tryParse(message.data['chat_id'].toString());
          if (chatId != null) {
            ChatMessageService.instance.triggerFirebaseChatRefresh();
          }
        }
      } else {}
    } catch (e) {
      //
    }
  }

  /// Check if notifications are enabled
  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? true; // Default to true
  }

  /// Toggle notification settings
  Future<void> toggleNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);

    if (enabled && _isInitialized) {
      // Re-request permissions and setup listeners if needed
      await _requestNotificationPermissions();
      await _setupFirebaseMessaging();

      // Get a new FCM token when enabling notifications
      // if (_messaging != null) {
      //   try {
      //     String? newToken = await _messaging!.getToken();
      //   } catch (e) {
      //   }
      // }
    } else if (!enabled) {
      // Clear all notifications and dispose listeners when disabled
      await _localNotifications.cancelAll();
      await _disposeListeners();

      // Force clear any pending notifications
      await _clearAllNotifications();

      // Completely disable Firebase messaging when notifications are off
      if (_messaging != null) {
        try {
          // Delete the FCM token to stop receiving messages
          await _messaging!.deleteToken();
        } catch (e) {
          //
        }
      }
    }
  }

  /// Force clear all notifications (more aggressive)
  Future<void> _clearAllNotifications() async {
    try {
      // Cancel all local notifications
      await _localNotifications.cancelAll();

      // Cancel notifications by channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.cancelAll();
    } catch (e) {
      //
    }
  }

  /// Force refresh notification settings
  Future<void> forceRefreshNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('notifications_enabled') ?? true;

    if (!isEnabled) {
      await _clearAllNotifications();
      await _disposeListeners();

      // Also delete FCM token if messaging is available
      if (_messaging != null) {
        try {
          await _messaging!.deleteToken();
        } catch (e) {
          //
        }
      }
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    if (_messaging == null) {
      return null;
    }
    return await _messaging!.getToken();
  }

  /// Refresh FCM token
  // Future<void> refreshFCMToken() async {
  //   if (_messaging == null) {
  //     return;
  //   }
  //   await _messaging!.deleteToken();
  //   String? newToken = await _messaging!.getToken();
  // }

  /// Dispose the service
  Future<void> dispose() async {
    await _disposeListeners();
    _isInitialized = false;
  }

  /// Check if chat refresh is needed and clear the flag
  Future<bool> checkAndClearChatRefreshFlag() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final needsRefresh = prefs.getBool('chat_refresh_needed') ?? false;

      if (needsRefresh) {
        await prefs.setBool('chat_refresh_needed', false);

        // Trigger chat refresh
        ChatMessageService.instance.triggerFirebaseChatRefresh();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get the timestamp of the last chat refresh request
  Future<DateTime?> getLastChatRefreshTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getString('chat_refresh_timestamp');
      if (timestamp != null) {
        return DateTime.tryParse(timestamp);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check notification permissions and settings for debugging
  Future<void> checkNotificationPermissions() async {
    try {
      if (_messaging == null) {
        return;
      }

      await _messaging!.getNotificationSettings();

      // Get FCM token
      await _messaging!.getToken();

      // Check Android notification channel
      if (defaultTargetPlatform == TargetPlatform.android) {}
    } catch (e) {
      //
    }
  }

  /// Test foreground notification manually (for debugging)
  Future<void> testForegroundNotification() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _localNotifications.show(
          999999, // Use a unique ID for test
          '🧪 Test Notification',
          'This is a test notification while app is in foreground',
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/launcher_icon',
              importance: Importance.high,
              priority: Priority.high,
              showWhen: true,
              enableVibration: true,
              playSound: true,
            ),
          ),
        );
      } else {
        await _localNotifications.show(
          999999,
          '🧪 Test Notification',
          'This is a test notification while app is in foreground',
          NotificationDetails(),
        );
      }
    } catch (e) {
      //
    }
  }
}
