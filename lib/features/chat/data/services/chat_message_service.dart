import 'dart:async';
import 'dart:developer';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';

/// Service for handling real-time chat message updates
class ChatMessageService {
  static ChatMessageService? _instance;
  static ChatMessageService get instance => _instance ??= ChatMessageService._internal();

  ChatMessageService._internal();

  // Stream controllers for different types of updates
  final StreamController<PusherMessageModel> _messageController = StreamController<PusherMessageModel>.broadcast();
  final StreamController<int> _chatUpdateController = StreamController<int>.broadcast();
  final StreamController<void> _refreshChatListController = StreamController<void>.broadcast();

  // Streams that screens can listen to
  Stream<PusherMessageModel> get messageStream => _messageController.stream;
  Stream<int> get chatUpdateStream => _chatUpdateController.stream;
  Stream<void> get refreshChatListStream => _refreshChatListController.stream;

  /// Handle new message received from Pusher
  void handleNewMessage(PusherMessageModel message) {
    _messageController.add(message);
    _chatUpdateController.add(message.chatId);
    _refreshChatListController.add(null);
  }

  /// Trigger chat refresh from Firebase notification
  void triggerFirebaseChatRefresh() {
    log('🔄 Firebase notification triggered chat refresh');
    _refreshChatListController.add(null);
  }

  /// Dispose of the service
  void dispose() {
    _messageController.close();
    _chatUpdateController.close();
    _refreshChatListController.close();
  }
}
