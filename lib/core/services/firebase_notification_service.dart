import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

    if (notificationsEnabled) {
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

    // Handle foreground messages
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
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
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

    if (enabled && _isInitialized) {
      // Re-request permissions if needed
      await _requestNotificationPermissions();
    } else if (!enabled) {
      // Clear all notifications when disabled
      await _localNotifications.cancelAll();
      log("All notifications cancelled due to disabled setting");
    }

    log('Notifications ${enabled ? 'enabled' : 'disabled'}');
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
}
