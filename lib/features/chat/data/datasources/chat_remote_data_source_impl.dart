import 'package:elsadeken/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:elsadeken/features/chat/data/models/chat_message_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return empty list for now (empty state)
    return [];
    
    // Uncomment below for testing with mock data
    /*
    return [
      ChatRoomModel(
        id: '1',
        name: 'أحمد محمد',
        image: 'https://example.com/avatar1.jpg',
        lastMessage: 'مرحبا، كيف حالك؟',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        isOnline: true,
        isFavorite: true,
      ),
      ChatRoomModel(
        id: '2',
        name: 'فاطمة علي',
        image: 'https://example.com/avatar2.jpg',
        lastMessage: 'شكرا لك',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isOnline: false,
        isFavorite: false,
      ),
    ];
    */
  }

  @override
  Future<List<ChatMessageModel>> getChatMessages(String roomId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<void> sendMessage(String roomId, String message) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> markAsRead(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deleteChat(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> deleteAllChats() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
