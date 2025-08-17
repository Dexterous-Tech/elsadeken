// core/firebase/firebase_client.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IFirebaseClient {
  FirebaseAuth get auth;
  FirebaseFirestore get firestore;
  Future<String?> getFcmToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
}
