// core/firebase/firebase_client_impl.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_client.dart';

class FirebaseClientImpl implements IFirebaseClient {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  FirebaseClientImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseMessaging? messaging,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _messaging = messaging ?? FirebaseMessaging.instance;

  @override
  FirebaseAuth get auth => _auth;

  @override
  FirebaseFirestore get firestore => _firestore;

  @override
  Future<String?> getFcmToken() => _messaging.getToken();

  @override
  Future<void> subscribeToTopic(String topic) => _messaging.subscribeToTopic(topic);

  @override
  Future<void> unsubscribeFromTopic(String topic) => _messaging.unsubscribeFromTopic(topic);
}
