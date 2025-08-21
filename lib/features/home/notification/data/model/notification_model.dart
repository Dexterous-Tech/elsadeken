import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final int userId;
  final String userName;
  final String title;
  final String body;
  final String? icon;
  final DateTime? readAt;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.body,
    this.icon,
    this.readAt,
    required this.createdAt,
  }) : isRead = readAt != null;

  factory NotificationModel.fromResponseModel(dynamic json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      icon: json['icon'],
      readAt:
          json['read_at'] != null ? DateTime.tryParse(json['read_at']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  NotificationModel copyWith({
    String? id,
    int? userId,
    String? userName,
    String? title,
    String? body,
    String? icon,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      body: body ?? this.body,
      icon: icon ?? this.icon,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'title': title,
      'body': body,
      'icon': icon,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
