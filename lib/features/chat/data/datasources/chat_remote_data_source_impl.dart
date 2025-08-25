import 'package:elsadeken/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:elsadeken/features/chat/data/models/chat_message_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  // Mutable static data for development
  late List<ChatRoomModel> _mockChatRooms;
  final Map<String, List<ChatMessageModel>> _mockMessages = {};

  ChatRemoteDataSourceImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _mockChatRooms = _getMockChatRooms();
    
    // Initialize messages for each chat room
    _mockChatRooms.forEach((room) {
      _mockMessages[room.id] = _getMockChatMessages(room.id);
    });
  }

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    return _mockChatRooms;
  }

  @override
  Future<List<ChatMessageModel>> getChatMessages(String roomId) async {
    print("ChatRemoteDataSourceImpl: Returning mock messages for room $roomId");
    return _mockMessages[roomId] ?? [];
  }

  @override
  Future<void> sendMessage(String roomId, String message) async {
    print("ChatRemoteDataSourceImpl: Adding message '$message' to room $roomId");
    
    // Create new message
    final newMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: roomId,
      senderId: 'current_user',
      senderName: 'أنا',
      senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Add to messages list
    if (_mockMessages[roomId] != null) {
      _mockMessages[roomId]!.add(newMessage);
    } else {
      _mockMessages[roomId] = [newMessage];
    }

    // Update chat room's last message and time
    final chatRoomIndex = _mockChatRooms.indexWhere((room) => room.id == roomId);
    if (chatRoomIndex != -1) {
      final oldRoom = _mockChatRooms[chatRoomIndex];
      _mockChatRooms[chatRoomIndex] = ChatRoomModel(
        id: oldRoom.id,
        name: oldRoom.name,
        image: oldRoom.image,
        lastMessage: message,
        lastMessageTime: DateTime.now(),
        unreadCount: 0, // Reset unread count for current user's message
        isOnline: oldRoom.isOnline,
        isFavorite: oldRoom.isFavorite,
        receiverId: oldRoom.receiverId,
      );
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> markAsRead(String roomId) async {
    print("ChatRemoteDataSourceImpl: Marking room $roomId as read");
    
    // Mark all messages in the room as read
    if (_mockMessages[roomId] != null) {
      for (int i = 0; i < _mockMessages[roomId]!.length; i++) {
        final message = _mockMessages[roomId]![i];
        if (message.senderId != 'current_user') {
          _mockMessages[roomId]![i] = ChatMessageModel(
            id: message.id,
            roomId: message.roomId,
            senderId: message.senderId,
            senderName: message.senderName,
            senderImage: message.senderImage,
            message: message.message,
            timestamp: message.timestamp,
            isRead: true,
          );
        }
      }
    }

    // Update chat room's unread count
    final chatRoomIndex = _mockChatRooms.indexWhere((room) => room.id == roomId);
    if (chatRoomIndex != -1) {
      final oldRoom = _mockChatRooms[chatRoomIndex];
      _mockChatRooms[chatRoomIndex] = ChatRoomModel(
        id: oldRoom.id,
        name: oldRoom.name,
        image: oldRoom.image,
        lastMessage: oldRoom.lastMessage,
        lastMessageTime: oldRoom.lastMessageTime,
        unreadCount: 0,
        isOnline: oldRoom.isOnline,
        isFavorite: oldRoom.isFavorite,
        receiverId: oldRoom.receiverId,
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deleteChat(String roomId) async {
    print("ChatRemoteDataSourceImpl: Deleting chat room $roomId");
    
    // Remove chat room
    _mockChatRooms.removeWhere((room) => room.id == roomId);
    
    // Remove messages
    _mockMessages.remove(roomId);
    
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> markAllAsRead() async {
    print("ChatRemoteDataSourceImpl: Marking all chats as read");
    
    // Mark all messages in all rooms as read
    _mockMessages.values.forEach((messages) {
      for (int i = 0; i < messages.length; i++) {
        final message = messages[i];
        if (message.senderId != 'current_user') {
          messages[i] = ChatMessageModel(
            id: message.id,
            roomId: message.roomId,
            senderId: message.senderId,
            senderName: message.senderName,
            senderImage: message.senderImage,
            message: message.message,
            timestamp: message.timestamp,
            isRead: true,
          );
        }
      }
    });

    // Update all chat rooms' unread counts
    for (int i = 0; i < _mockChatRooms.length; i++) {
      final oldRoom = _mockChatRooms[i];
             _mockChatRooms[i] = ChatRoomModel(
         id: oldRoom.id,
         name: oldRoom.name,
         image: oldRoom.image,
         lastMessage: oldRoom.lastMessage,
         lastMessageTime: oldRoom.lastMessageTime,
         unreadCount: 0,
         isOnline: oldRoom.isOnline,
         isFavorite: oldRoom.isFavorite,
         receiverId: oldRoom.receiverId,
       );
    }
    
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deleteAllChats() async {
    print("ChatRemoteDataSourceImpl: Deleting all chats");
    
    // Clear all data
    _mockChatRooms.clear();
    _mockMessages.clear();
    
    // Reinitialize with fresh data
    _initializeMockData();
    
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Mock data for development
  List<ChatRoomModel> _getMockChatRooms() {
    return [
      ChatRoomModel(
        id: '1',
        name: 'محمد القحطاني',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
        lastMessage: 'مرحبا كيف حالك ؟',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 2,
        isOnline: true,
        isFavorite: true,
        receiverId: 1,
      ),
      ChatRoomModel(
        id: '2',
        name: 'فاطمة علي',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
        lastMessage: 'شكرا لك',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        isOnline: false,
        isFavorite: false,
        receiverId: 2,
      ),
      ChatRoomModel(
        id: '3',
        name: 'أحمد محمد',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
        lastMessage: 'أراك غدا',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 1,
        isOnline: true,
        isFavorite: false,
        receiverId: 3,
      ),
      ChatRoomModel(
        id: '4',
        name: 'سارة أحمد',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
        lastMessage: 'هل تريد أن نلتقي في المطعم؟',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 3,
        isOnline: false,
        isFavorite: true,
        receiverId: 4,
      ),
      ChatRoomModel(
        id: '5',
        name: 'علي حسن',
        image: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
        lastMessage: 'أشكرك على المساعدة',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 0,
        isOnline: false,
        isFavorite: false,
        receiverId: 5,
      ),
    ];
  }

  List<ChatMessageModel> _getMockChatMessages(String roomId) {
    if (roomId == '1') {
      return [
        ChatMessageModel(
          id: '1',
          roomId: roomId,
          senderId: '1',
          senderName: 'محمد القحطاني',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
          message: 'مرحبا كيف حالك ؟',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '2',
          roomId: roomId,
          senderId: 'current_user',
          senderName: 'أنا',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
          message: 'أهلا وسهلا، الحمد لله',
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '3',
          roomId: roomId,
          senderId: '1',
          senderName: 'محمد القحطاني',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
          message: 'ممتاز، هل تريد أن نلتقي؟',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isRead: false,
        ),
      ];
    } else if (roomId == '2') {
      return [
        ChatMessageModel(
          id: '1',
          roomId: roomId,
          senderId: '2',
          senderName: 'فاطمة علي',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
          message: 'أهلا وسهلا',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '2',
          roomId: roomId,
          senderId: 'current_user',
          senderName: 'أنا',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
          message: 'أهلا وسهلا بك',
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '3',
          roomId: roomId,
          senderId: '2',
          senderName: 'فاطمة علي',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
          message: 'شكرا لك',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: true,
        ),
      ];
    } else if (roomId == '4') {
      return [
        ChatMessageModel(
          id: '1',
          roomId: roomId,
          senderId: '4',
          senderName: 'سارة أحمد',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
          message: 'مرحبا، كيف حالك؟',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '2',
          roomId: roomId,
          senderId: 'current_user',
          senderName: 'أنا',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
          message: 'أهلا وسهلا، الحمد لله',
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
          isRead: true,
        ),
        ChatMessageModel(
          id: '3',
          roomId: roomId,
          senderId: '4',
          senderName: 'سارة أحمد',
          senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/female.png',
          message: 'هل تريد أن نلتقي في المطعم؟',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: false,
        ),
      ];
    }
    
    return [
      ChatMessageModel(
        id: '1',
        roomId: roomId,
        senderId: 'other_user',
        senderName: 'مستخدم آخر',
        senderImage: 'https://elsadkeen.sharetrip-ksa.com/assets/img/male.png',
        message: 'مرحبا',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: true,
      ),
    ];
  }
}
