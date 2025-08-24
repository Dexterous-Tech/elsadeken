import 'package:elsadeken/features/chat/data/models/chat_message_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatRoomModel>> getChatRooms();
  Future<List<ChatMessageModel>> getChatMessages(String roomId);
  Future<void> sendMessage(String roomId, String message);
  Future<void> markAsRead(String roomId);
  Future<void> deleteChat(String roomId);
  Future<void> markAllAsRead();
  Future<void> deleteAllChats();
}
