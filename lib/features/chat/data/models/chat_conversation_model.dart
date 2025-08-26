import 'dart:convert';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';

class ChatMessagesConversation {
  final int chatId;
  final List<Message> messages;

  ChatMessagesConversation({
    required this.chatId,
    required this.messages,
  });

  factory ChatMessagesConversation.fromJson(Map<String, dynamic> json) {
    return ChatMessagesConversation(
      chatId: json['chat_id'] ?? 0,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chat_id": chatId,
      "messages": messages.map((e) => e.toJson()).toList(),
    };
  }

   List<ChatMessage> toChatMessages(String currentUserId, String otherUserName, String otherUserImage, String currentUserImage) {
    return messages.map((message) => message.toChatMessage(currentUserId, otherUserName, otherUserImage, currentUserImage)).toList();
  }

   static ChatMessagesConversation fromRawJson(String str) =>
      ChatMessagesConversation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

/// 🔹 Single Message Model
class Message {
  final int id;
  final int chatId;
  final int senderId;
  final int receiverId;
  final String body;
  final int isRead;
  final int isReported;
  final int? reportedByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.body,
    required this.isRead,
    required this.isReported,
    this.reportedByUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      chatId: json['chat_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      body: json['body'] ?? '',
      isRead: json['is_read'] ?? 0,
      isReported: json['is_reported'] ?? 0,
      reportedByUserId: json['reported_by_user_id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert to ChatMessage entity with sender info
  ChatMessage toChatMessage(String currentUserId, String otherUserName, String otherUserImage, String currentUserImage) {
    final isCurrentUser = senderId.toString() == currentUserId;
    
    return ChatMessage(
      id: id.toString(),
      roomId: chatId.toString(),
      senderId: senderId.toString(),
      senderName: isCurrentUser ? 'أنا' : otherUserName,
      senderImage: isCurrentUser ? currentUserImage : otherUserImage,
      message: body,
      timestamp: createdAt,
      isRead: isRead == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "chat_id": chatId,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "body": body,
      "is_read": isRead,
      "is_reported": isReported,
      "reported_by_user_id": reportedByUserId,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
