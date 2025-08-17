import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { message, follow, like, comment }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? senderId;
  final String? relatedPostId;
  final Map<String, dynamic>? additionalData;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.senderId,
    this.relatedPostId,
    this.additionalData,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  // Convert to JSON for future API integration
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'type': type.toString().split('.').last,
    };
  }

  // Create from JSON for future API integration
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isRead: json['isRead'] ?? false,
      type: _parseNotificationType(json['type']),
      senderId: json['senderId'],
      relatedPostId: json['relatedPostId'],
      additionalData: json['additionalData'] != null 
          ? Map<String, dynamic>.from(json['additionalData'])
          : null,
    );
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'message':
        return NotificationType.message;
      case 'follow':
        return NotificationType.follow;
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      default:
        return NotificationType.message;
    }
  }
}