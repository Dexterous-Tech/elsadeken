import 'package:equatable/equatable.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';

class PusherMessageModel extends Equatable {
  final int chatId;
  final int senderId;
  final int receiverId;
  final String body;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  const PusherMessageModel({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.body,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory PusherMessageModel.fromJson(Map<String, dynamic> json) {
    return PusherMessageModel(
      chatId: json['chat_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      body: json['body'] ?? '',
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'body': body,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'id': id,
    };
  }

  /// Convert to ChatMessage entity
  ChatMessage toChatMessage(
      String currentUserId, String senderName, String senderImage) {
    return ChatMessage(
      id: id.toString(),
      roomId: chatId.toString(),
      senderId: senderId.toString(),
      senderName: senderName,
      senderImage: senderImage,
      message: body,
      timestamp: createdAt,
      isRead: false,
    );
  }

  @override
  List<Object?> get props =>
      [chatId, senderId, receiverId, body, updatedAt, createdAt, id];
}
