import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    required super.senderName,
    required super.senderImage,
    required super.message,
    required super.timestamp,
    required super.isRead,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      senderImage: json['sender_image'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_image': senderImage,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}
