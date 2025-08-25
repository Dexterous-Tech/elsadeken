import 'package:elsadeken/features/chat/domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required super.id,
    required super.name,
    required super.image,
    required super.lastMessage,
    required super.lastMessageTime,
    required super.unreadCount,
    required super.isOnline,
    required super.isFavorite,
    required super.receiverId,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      lastMessage: json['last_message'] as String,
      lastMessageTime: DateTime.parse(json['last_message_time'] as String),
      unreadCount: json['unread_count'] as int,
      isOnline: json['is_online'] as bool,
      isFavorite: json['is_favorite'] as bool,
      receiverId: json['receiver_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'unread_count': unreadCount,
      'is_online': isOnline,
      'is_favorite': isFavorite,
      'receiver_id': receiverId,
    };
  }
}
