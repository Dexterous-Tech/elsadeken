import 'dart:async';
import 'dart:developer';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';

/// Service for handling real-time chat message updates via Firebase notifications
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

  // Track last message for debugging
  DateTime? _lastMessageTime;
  bool _isPusherConnected = false;

  /// Handle new message received from Pusher (for real-time conversation updates)
  void handleNewMessage(PusherMessageModel message) {
    log('⚡ Real-time message via Pusher: ${message.body}');
    _lastMessageTime = DateTime.now();
    _messageController.add(message);
    _chatUpdateController.add(message.chatId);
    
    // Also trigger chat list refresh for immediate updates
    triggerFirebaseChatRefresh();
  }

  /// Trigger chat refresh from Firebase notification (Primary method)
  void triggerFirebaseChatRefresh() {
    log('📱 Chat list refresh triggered by Firebase notification');
    _refreshChatListController.add(null);
  }

  /// Set Pusher connection status (for monitoring)
  void setPusherConnectionStatus(bool isConnected) {
    _isPusherConnected = isConnected;
    log('📊 Pusher connection status: $isConnected');
  }

  /// Check if we're getting real-time updates
  bool get isRealTimeWorking {
    if (_lastMessageTime == null) return false;
    final timeSince = DateTime.now().difference(_lastMessageTime!);
    return _isPusherConnected && timeSince.inMinutes < 5;
  }

  /// Get current update method being used
  String get currentUpdateMethod {
    if (_isPusherConnected && isRealTimeWorking) {
      return 'Pusher + Firebase Notifications';
    }
    return 'Firebase Notifications Only';
  }

  /// Dispose of the service
  void dispose() {
    _messageController.close();
    _chatUpdateController.close();
    _refreshChatListController.close();
  }
}
