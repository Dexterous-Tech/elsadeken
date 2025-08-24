import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String id;
  final String name;
  final String image;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool isFavorite;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isOnline,
    required this.isFavorite,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        lastMessage,
        lastMessageTime,
        unreadCount,
        isOnline,
        isFavorite,
      ];
}
