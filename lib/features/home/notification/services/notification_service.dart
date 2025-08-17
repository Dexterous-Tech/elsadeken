// This service will be used for future API integration
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elsadeken/core/firebase/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../data/models/notification_model.dart';

class FirebaseNotificationService {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;

  FirebaseNotificationService({
    required FirebaseFirestore firestore,
    required FirebaseMessaging messaging,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _messaging = messaging,
        _auth = auth;

  Stream<List<NotificationModel>> getNotificationsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  Future<void> initializePushNotifications() async {
    await _messaging.requestPermission();
    final fcmToken = await _messaging.getToken();
    debugPrint('FCM Token: $fcmToken');

    final userId = _auth.currentUser?.uid;
    if (userId != null && fcmToken != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
            'fcmTokens': FieldValue.arrayUnion([fcmToken]),
          });
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationClick);
  }

  Future<void> markAsRead(String notificationId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllAsRead() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (final doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  Future<void> clearAllNotifications() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .get();

    for (final doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  void _handleForegroundNotification(RemoteMessage message) {
    // You can show a snackbar or local notification here
    debugPrint('Foreground notification: ${message.notification?.title}');
  }

  void _handleNotificationClick(RemoteMessage message) {
    // Handle navigation when notification is clicked
    debugPrint('Notification clicked: ${message.data}');
  }
}