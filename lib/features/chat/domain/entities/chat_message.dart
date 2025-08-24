import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String senderImage;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.senderImage,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
        id,
        roomId,
        senderId,
        senderName,
        senderImage,
        message,
        timestamp,
        isRead,
      ];
}
