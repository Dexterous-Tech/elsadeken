import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';

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
  );

  // Global variable to handle background messages
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    log("Handling background message: ${message.messageId}");

    // Check if notifications are enabled before showing
    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;

    log("Background notification check - enabled: $notificationsEnabled");

    // Immediately return if notifications are disabled
    if (!notificationsEnabled) {
      log("Background notification IGNORED - notifications disabled in settings");
      return; // Exit immediately, don't process anything
    }

    // Double-check the setting before proceeding
    final doubleCheck = prefs.getBool('notifications_enabled') ?? true;
    if (!doubleCheck) {
      log("Background notification IGNORED - double check failed");
      return;
    }

    // Show notification only if enabled
    final localNotifications = FlutterLocalNotificationsPlugin();
    await localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      log("Showing background notification: ${notification.title}");
      await localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon ?? '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  /// Initialize Firebase and notification services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize Firebase
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      log("Firebase initialized successfully");

      // Initialize messaging after Firebase is ready
      _messaging = FirebaseMessaging.instance;

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Request notification permissions
      await _requestNotificationPermissions();

      // Setup local notifications
      await _setupLocalNotifications();

      // Setup Firebase messaging listeners
      await _setupFirebaseMessaging();

      _isInitialized = true;
      log("Firebase notification service initialized successfully");
    } catch (e) {
      log("Error initializing Firebase notification service: $e");
      rethrow;
    }
  }

  /// Request notification permissions
  Future<void> _requestNotificationPermissions() async {
    if (_messaging == null) {
      log("Firebase messaging not initialized yet");
      return;
    }

    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await _messaging!.getToken();
    log('FCM Token: $token');
  }

  /// Setup local notifications
  Future<void> _setupLocalNotifications() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('Notification clicked: ${response.payload}');
      },
    );

    // Create notification channel for Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Setup Firebase messaging listeners
  Future<void> _setupFirebaseMessaging() async {
    if (_messaging == null) {
      log("Firebase messaging not initialized yet");
      return;
    }

    // Dispose existing listeners first
    await _disposeListeners();

    // Handle foreground messages
    _foregroundSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Got message in foreground: ${message.notification?.title}");

      // Check if notifications are enabled before showing
      bool enabled = await isNotificationEnabled();
      if (enabled) {
        _showLocalNotification(message);
      } else {
        log("Notifications disabled, not showing foreground notification");
      }
    });

    // Handle when app is opened from notification
    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {
      log("App opened by notification: ${message.notification?.title}");

      // Only handle navigation if notifications are enabled
      bool enabled = await isNotificationEnabled();
      if (enabled) {
        _handleNotificationNavigation(message);
      }
    });

    // Handle initial notification when app is launched from terminated state
    RemoteMessage? initialMessage = await _messaging!.getInitialMessage();
    if (initialMessage != null) {
      log("App launched from notification: ${initialMessage.notification?.title}");

      // Only handle navigation if notifications are enabled
      bool enabled = await isNotificationEnabled();
      if (enabled) {
        _handleNotificationNavigation(initialMessage);
      }
    }
  }

  /// Dispose Firebase messaging listeners
  Future<void> _disposeListeners() async {
    log("Disposing Firebase messaging listeners");

    await _foregroundSubscription?.cancel();
    _foregroundSubscription = null;

    await _openedAppSubscription?.cancel();
    _openedAppSubscription = null;

    log("Firebase messaging listeners disposed");
  }

  /// Show local notification
  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon ?? '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  /// Handle notification navigation
  void _handleNotificationNavigation(RemoteMessage message) {
    // Handle navigation based on notification data
    // You can add your navigation logic here based on message.data
    log("Handling notification navigation with data: ${message.data}");
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

    log('Notification setting saved: $enabled');

    if (enabled && _isInitialized) {
      // Re-request permissions and setup listeners if needed
      await _requestNotificationPermissions();
      await _setupFirebaseMessaging();

      // Get a new FCM token when enabling notifications
      if (_messaging != null) {
        try {
          String? newToken = await _messaging!.getToken();
          log("New FCM token generated: $newToken");
        } catch (e) {
          log("Error getting new FCM token: $e");
        }
      }

      log("Notifications enabled - listeners activated");
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
          log("FCM token deleted to stop receiving notifications");
        } catch (e) {
          log("Error deleting FCM token: $e");
        }
      }

      log("Notifications disabled - listeners disposed and all notifications cancelled");
    }

    log('Notifications ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Force clear all notifications (more aggressive)
  Future<void> _clearAllNotifications() async {
    try {
      // Cancel all local notifications
      await _localNotifications.cancelAll();

      // Cancel notifications by channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.cancelAll();

      log("All notifications forcefully cleared");
    } catch (e) {
      log("Error clearing notifications: $e");
    }
  }

  /// Force refresh notification settings
  Future<void> forceRefreshNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('notifications_enabled') ?? true;

    log("Force refreshing notification settings - enabled: $isEnabled");

    if (!isEnabled) {
      await _clearAllNotifications();
      await _disposeListeners();

      // Also delete FCM token if messaging is available
      if (_messaging != null) {
        try {
          await _messaging!.deleteToken();
          log("FCM token deleted during force refresh");
        } catch (e) {
          log("Error deleting FCM token during force refresh: $e");
        }
      }

      log("Force refresh: notifications disabled and listeners disposed");
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    if (_messaging == null) {
      log("Firebase messaging not initialized yet");
      return null;
    }
    return await _messaging!.getToken();
  }

  /// Refresh FCM token
  Future<void> refreshFCMToken() async {
    if (_messaging == null) {
      log("Firebase messaging not initialized yet");
      return;
    }
    await _messaging!.deleteToken();
    String? newToken = await _messaging!.getToken();
    log('FCM Token refreshed: $newToken');
  }

  /// Dispose the service
  Future<void> dispose() async {
    await _disposeListeners();
    _isInitialized = false;
    log("Firebase notification service disposed");
  }
}
