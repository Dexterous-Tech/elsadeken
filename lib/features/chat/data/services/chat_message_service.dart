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

  // Track connection status and message history
  DateTime? _lastMessageTime;
  bool _isPusherConnected = false;
  final Set<String> _processedMessageIds = <String>{};

  /// Handle new message received from Pusher (for real-time conversation updates)
  void handleNewMessage(PusherMessageModel message) {
    // Prevent duplicate message processing
    final messageKey = '${message.id}_${message.chatId}';

    if (_processedMessageIds.contains(messageKey)) {
      log('Duplicate message ignored: ${message.body}');
      return;
    }

    _processedMessageIds.add(messageKey);

    // Clean up old processed messages (keep only last 100)
    if (_processedMessageIds.length > 100) {
      final oldIds = _processedMessageIds.take(_processedMessageIds.length - 100);
      _processedMessageIds.removeAll(oldIds);
    }

    log('Real-time message processed via Pusher: ${message.body}');
    _lastMessageTime = DateTime.now();

    // Emit to message stream for conversation screen
    _messageController.add(message);

    // Emit to chat update stream for chat list updates
    _chatUpdateController.add(message.chatId);

    // Trigger Firebase-based chat list refresh for comprehensive updates
    triggerFirebaseChatRefresh();
  }

  /// Trigger chat refresh from Firebase notification
  void triggerFirebaseChatRefresh() {
    log('Chat list refresh triggered');
    _refreshChatListController.add(null);
  }

  /// Set Pusher connection status
  void setPusherConnectionStatus(bool isConnected) {
    _isPusherConnected = isConnected;
    log('Pusher connection status updated: $isConnected');

    if (!isConnected) {
      // Clear processed messages on disconnect to allow re-processing after reconnect
      _processedMessageIds.clear();
    }
  }

  /// Check if real-time updates are working
  bool get isRealTimeWorking {
    if (_lastMessageTime == null) return false;
    final timeSince = DateTime.now().difference(_lastMessageTime!);
    return _isPusherConnected && timeSince.inMinutes < 5;
  }

  /// Get diagnostic information
  Map<String, dynamic> getDiagnostics() {
    return {
      'isPusherConnected': _isPusherConnected,
      'lastMessageTime': _lastMessageTime?.toIso8601String(),
      'isRealTimeWorking': isRealTimeWorking,
      'processedMessageCount': _processedMessageIds.length,
    };
  }

  /// Test method for debugging
  void simulateMessage(int chatId, String messageBody) {
    final testMessage = PusherMessageModel.fromJson({
      'id': DateTime.now().millisecondsSinceEpoch,
      'chat_id': chatId,
      'sender_id': 999,
      'receiver_id': 1,
      'body': messageBody,
      'created_at': DateTime.now().toIso8601String(),
    });

    handleNewMessage(testMessage);
  }

  /// Dispose of the service
  void dispose() {
    _messageController.close();
    _chatUpdateController.close();
    _refreshChatListController.close();
    _processedMessageIds.clear();
  }
}