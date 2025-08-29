import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:elsadeken/features/chat/data/services/chat_message_service.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:elsadeken/core/helper/network_helper.dart';

/// Pusher Configuration
class PusherConfig {
  static const String appId = '1893366';
  static const String appKey = '488b28cd543c3e616398';
  static const String appSecret = 'bb14accaa8c913fd988f';
  static const String cluster = 'eu';
  static const int port = 443;
  static const bool encrypted = true;
}

/// Service for managing Pusher connection with WebSocket (EU cluster only)
class PusherService {
  String? _lastSocketId;
  static PusherService? _instance;
  static PusherService get instance => _instance ??= PusherService._internal();

  PusherService._internal();

  WebSocketChannel? _webSocketChannel;
  bool _isConnected = false;
  String? _currentChannelName;
  String? _authToken;

  // Reconnection management
  Timer? _reconnectionTimer;
  int _reconnectionAttempts = 0;
  static const int _maxReconnectionAttempts = 5;
  static const int _baseReconnectionDelay = 3;

  // Socket ID waiting
  Completer<String>? _socketIdCompleter;

  // Callbacks
  Function(PusherMessageModel)? onMessageReceived;
  Function(String)? onConnectionEstablished;
  Function(String)? onConnectionError;

  void setAuthToken(String token) {
    _authToken = token;
    log('🔑 Auth token set for private channels');
  }

  /// Initialize WebSocket connection to EU cluster only
  Future<void> initialize() async {
    try {
      if (_isConnected && _webSocketChannel != null) {
        log('✅ WebSocket already connected, skipping initialization');
        return;
      }

      if (_webSocketChannel != null) {
        log('🔄 Cleaning up existing WebSocket connection...');
        try {
          _webSocketChannel!.sink.close();
        } catch (e) {
          log('⚠️ Error closing existing WebSocket: $e');
        }
        _webSocketChannel = null;
        _isConnected = false;
        _lastSocketId = null;
      }

      log('🔄 Initializing WebSocket connection to EU cluster...');

      final wsUrl = 'wss://ws-${PusherConfig.cluster}.pusher.com/app/${PusherConfig.appKey}?protocol=7&client=dart&version=1.0&flash=false';
      log('🔗 Connecting to: $wsUrl');

      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Wait for connection with proper error handling
      await Future.delayed(Duration(milliseconds: 2000));

      if (_webSocketChannel != null) {
        _isConnected = true;
        _resetReconnectionAttempts();
        log('✅ WebSocket connected successfully');

        _webSocketChannel!.stream.listen(
              (message) => _handleWebSocketMessage(message),
          onDone: () {
            log('❌ WebSocket closed');
            _isConnected = false;
            _webSocketChannel = null;
            _lastSocketId = null;
            _socketIdCompleter = null;

            ChatMessageService.instance.setPusherConnectionStatus(false);
            _scheduleReconnection();
          },
          onError: (error) {
            log('❌ WebSocket error: $error');
            _isConnected = false;
            _webSocketChannel = null;
            _lastSocketId = null;
            _socketIdCompleter = null;
            onConnectionError?.call(error.toString());

            ChatMessageService.instance.setPusherConnectionStatus(false);
            _scheduleReconnection();
          },
        );
      } else {
        log('❌ Failed to connect to EU cluster');
        _isConnected = false;
        onConnectionError?.call('Failed to connect to EU cluster');
        _scheduleReconnection();
      }

    } catch (e) {
      log('❌ WebSocket initialization failed: $e');
      _isConnected = false;
      _webSocketChannel = null;
      _lastSocketId = null;
      _socketIdCompleter = null;
      onConnectionError?.call('WebSocket failed: $e');
      _scheduleReconnection();
    }
  }

  /// Wait for socket ID to be available
  Future<String> _waitForSocketId({int timeoutSeconds = 2}) async {
    if (_lastSocketId != null) {
      return _lastSocketId!;
    }

    // Create a completer if not already waiting
    _socketIdCompleter ??= Completer<String>();

    try {
      // Wait for socket ID with timeout
      return await _socketIdCompleter!.future.timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Socket ID not received within $timeoutSeconds seconds');
        },
      );
    } catch (e) {
      log('❌ Error waiting for socket ID: $e');
      _socketIdCompleter = null;
      rethrow;
    }
  }

  void _resetReconnectionAttempts() {
    _reconnectionAttempts = 0;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    log('✅ Reconnection attempts reset to 0');
  }

  void dispose() {
    log('🔄 Disposing WebSocket connection...');

    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;

    if (_webSocketChannel != null) {
      try {
        _webSocketChannel!.sink.close();
      } catch (e) {
        log('⚠️ Error closing WebSocket during dispose: $e');
      }
      _webSocketChannel = null;
    }
    _isConnected = false;
    _currentChannelName = null;
    _reconnectionAttempts = 0;
    _lastSocketId = null;
    _socketIdCompleter = null;
    log('✅ WebSocket connection disposed');
  }

  void _scheduleReconnection() {
    if (_isConnected) return;

    if (_reconnectionAttempts >= _maxReconnectionAttempts) {
      log('❌ Maximum reconnection attempts ($_maxReconnectionAttempts) reached.');
      onConnectionError?.call('Failed to connect after $_maxReconnectionAttempts attempts.');
      return;
    }

    _reconnectionTimer?.cancel();

    final delay = _baseReconnectionDelay * (1 << _reconnectionAttempts);
    _reconnectionAttempts++;

    log('🔄 Scheduling reconnection attempt $_reconnectionAttempts in ${delay} seconds...');

    _reconnectionTimer = Timer(Duration(seconds: delay), () async {
      if (!_isConnected) {
        log('🔄 Attempting reconnection $_reconnectionAttempts...');
        try {
          await initialize();
        } catch (e) {
          log('❌ Reconnection attempt $_reconnectionAttempts failed: $e');
          if (_reconnectionAttempts < _maxReconnectionAttempts) {
            _scheduleReconnection();
          }
        }
      }
    });
  }

  /// Subscribe to a private chat channel with improved socket ID handling
  Future<void> subscribeToChatChannel(int chatRoomId, String bearerToken) async {
    final channelName = 'private-chat.$chatRoomId';

    if (_currentChannelName == channelName) {
      log('✅ Already subscribed to channel $channelName, skipping...');
      return;
    }

    if (!_isConnected || _webSocketChannel == null) {
      log('🔄 WebSocket not connected, initializing first...');
      await initialize();
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    if (!_isConnected || _webSocketChannel == null) {
      log('❌ Failed to establish WebSocket connection for subscription');
      onConnectionError?.call('Failed to establish connection for subscription');
      return;
    }

    _currentChannelName = channelName;
    log('🔗 Preparing subscription for channel: $channelName');

    try {
      // Wait for socket ID with proper timeout
      final socketId = await _waitForSocketId(timeoutSeconds: 10);
      log('✅ Got socket ID: $socketId');

      // Request authentication from Laravel backend
      final response = await http.post(
        Uri.parse('https://elsadkeen.sharetrip-ksa.com/api/broadcasting/auth'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Accept': 'application/json',
        },
        body: {
          'socket_id': socketId,
          'channel_name': channelName,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authSignature = data['auth'];

        log('✅ Authentication successful, subscribing to channel...');

        // Send subscription request with authentication
        final subscribeMessage = {
          'event': 'pusher:subscribe',
          'data': {
            'auth': authSignature,
            'channel': channelName,
          }
        };

        _webSocketChannel!.sink.add(jsonEncode(subscribeMessage));
        log('✅ Subscription request sent for $channelName');
      } else {
        log('❌ Auth request failed: ${response.statusCode} ${response.body}');
        onConnectionError?.call('Authentication failed: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Subscription error: $e');
      onConnectionError?.call('Subscription error: $e');
      _currentChannelName = null; // Reset on failure
    }
  }

  /// Handle WebSocket messages with improved message processing
  void _handleWebSocketMessage(dynamic message) {
    try {
      if (message is! String) {
        log('⚠️ Non-string WebSocket message: ${message.runtimeType}');
        return;
      }

      final data = jsonDecode(message);
      final eventType = data['event'];

      log('📨 Received event: $eventType');

      if (eventType == 'pusher:connection_established') {
        _isConnected = true;
        final socketData = jsonDecode(data['data']);
        _lastSocketId = socketData['socket_id'];

        // Complete the socket ID completer if waiting
        if (_socketIdCompleter != null && !_socketIdCompleter!.isCompleted) {
          _socketIdCompleter!.complete(_lastSocketId!);
        }

        onConnectionEstablished?.call('Connected');
        ChatMessageService.instance.setPusherConnectionStatus(true);
        log('✅ Pusher connected with socket ID: $_lastSocketId');

      } else if (eventType == 'pusher:subscription_succeeded') {
        log('✅ Subscription succeeded for $_currentChannelName');

      } else if (eventType == 'pusher:subscription_error') {
        log('❌ Subscription failed: ${data['data']}');
        onConnectionError?.call('Subscription failed: ${data['data']}');
        _currentChannelName = null; // Reset on subscription failure

      } else if (_isMessageEvent(eventType)) {
        log('💬 Message event received: $eventType');
        _processMessageEvent(data);

      } else if (eventType == 'pusher:error') {
        log('⚠️ Pusher error: ${data['data']}');
        onConnectionError?.call('Pusher error: ${data['data']}');

      } else {
        log('ℹ️ Other event: $eventType');
        // Try to process unknown events as potential messages
        _tryProcessAsMessage(data);
      }
    } catch (e) {
      log('❌ Error handling message: $e');
    }
  }

  /// Check if an event type indicates a message
  bool _isMessageEvent(String eventType) {
    final messageEvents = [
      'App\\Events\\MessageSent',
      'MessageSent',
      'message.sent',
      'chat.message',
      'message',
      'new-message',
      'chat-message',
    ];

    return messageEvents.contains(eventType) || eventType.contains('Message');
  }

  /// Process message events
  void _processMessageEvent(Map<String, dynamic> data) {
    try {
      final messageData = data['data'];

      if (messageData is String) {
        final parsed = jsonDecode(messageData);
        _processMessage(parsed);
      } else if (messageData is Map<String, dynamic>) {
        _processMessage(messageData);
      } else {
        log('⚠️ Unexpected message data type: ${messageData.runtimeType}');
      }
    } catch (e) {
      log('❌ Error processing message event: $e');
    }
  }

  /// Try to process unknown events as potential messages
  void _tryProcessAsMessage(Map<String, dynamic> data) {
    try {
      if (data.containsKey('data')) {
        final eventData = data['data'];

        if (eventData is String) {
          final parsed = jsonDecode(eventData);
          if (_looksLikeMessage(parsed)) {
            log('🔍 Unknown event looks like a message, processing...');
            _processMessage(parsed);
          }
        } else if (eventData is Map<String, dynamic> && _looksLikeMessage(eventData)) {
          log('🔍 Unknown event looks like a message, processing...');
          _processMessage(eventData);
        }
      }
    } catch (e) {
      log('🔍 Could not process as message: $e');
    }
  }

  /// Check if data structure looks like a message
  bool _looksLikeMessage(dynamic data) {
    if (data is! Map<String, dynamic>) return false;

    return data.containsKey('id') &&
        data.containsKey('chat_id') &&
        data.containsKey('body');
  }

  /// Process message data into PusherMessageModel
  void _processMessage(Map<String, dynamic> json) {
    try {
      log('🔍 Processing message JSON: $json');

      // Extract message data from various possible structures
      Map<String, dynamic> messageJson;

      if (json.containsKey('message')) {
        messageJson = json['message'] as Map<String, dynamic>;
      } else if (json.containsKey('data')) {
        messageJson = json['data'] as Map<String, dynamic>;
      } else {
        messageJson = json;
      }

      log('🔍 Extracted message data: $messageJson');

      final pusherMessage = PusherMessageModel.fromJson(messageJson);
      log('✅ Parsed PusherMessage: ${pusherMessage.body}');

      // Notify both callback and message service
      onMessageReceived?.call(pusherMessage);
      ChatMessageService.instance.handleNewMessage(pusherMessage);
    } catch (e) {
      log('⚠️ Failed to parse PusherMessage: $e');
      log('🔍 Raw JSON that failed: $json');
    }
  }

  /// Unsubscribe from the current chat channel
  void unsubscribeFromChatChannel() {
    if (_currentChannelName == null || _webSocketChannel == null) return;

    final unsubscribeMessage = {
      'event': 'pusher:unsubscribe',
      'data': {'channel': _currentChannelName}
    };

    try {
      _webSocketChannel!.sink.add(jsonEncode(unsubscribeMessage));
      log('🚪 Unsubscribed from $_currentChannelName');
    } catch (e) {
      log('⚠️ Error unsubscribing: $e');
    }

    _currentChannelName = null;
  }

  /// Disconnect from Pusher
  void disconnect() {
    try {
      unsubscribeFromChatChannel();
      _webSocketChannel?.sink.close(status.goingAway);
      _webSocketChannel = null;
      _isConnected = false;
      _lastSocketId = null;
      _socketIdCompleter = null;
      log('🔌 Disconnected');
    } catch (e) {
      log('❌ Error disconnecting: $e');
    }
  }

  bool get isConnected => _isConnected;
  String? get currentChannelName => _currentChannelName;

  /// Check connection health
  Future<bool> checkConnectionHealth() async {
    try {
      if (_webSocketChannel == null || !_isConnected) {
        log('🔄 Connection unhealthy, reconnecting...');
        await initialize();
        return _isConnected;
      }

      // Test with ping
      try {
        _webSocketChannel!.sink.add(jsonEncode({'event': 'pusher:ping'}));
        log('✅ Connection health check passed');
        return true;
      } catch (e) {
        log('⚠️ Ping failed, reconnecting...');
        await initialize();
        return _isConnected;
      }
    } catch (e) {
      log('❌ Connection health check failed: $e');
      return false;
    }
  }

  /// Get connection status for debugging
  Map<String, dynamic> getConnectionStatus() {
    return {
      'isConnected': _isConnected,
      'hasWebSocket': _webSocketChannel != null,
      'currentChannel': _currentChannelName,
      'hasAuthToken': _authToken != null,
      'hasSocketId': _lastSocketId != null,
      'socketId': _lastSocketId,
      'cluster': PusherConfig.cluster,
    };
  }


  /// Get comprehensive network and connection diagnostics
  Future<Map<String, dynamic>> getDetailedDiagnostics() async {
    try {
      // Get basic connection status
      final connectionStatus = getConnectionStatus();

      // Add additional diagnostic information
      final diagnostics = <String, dynamic>{
        ...connectionStatus,
        'reconnectionAttempts': _reconnectionAttempts,
        'maxReconnectionAttempts': _maxReconnectionAttempts,
        'hasReconnectionTimer': _reconnectionTimer != null,
        'lastSocketId': _lastSocketId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Try to get network diagnostics if NetworkHelper is available
      try {
        final networkDiagnostics = await NetworkHelper.getNetworkDiagnostics();
        diagnostics['networkDiagnostics'] = networkDiagnostics;
      } catch (e) {
        diagnostics['networkDiagnosticsError'] = e.toString();
      }

      return diagnostics;
    } catch (e) {
      return {
        'error': 'Failed to get diagnostics: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }


  // Debug methods
  void simulateMessageReceived(String messageText, int chatId) {
    log('🧪 Simulating message: $messageText for chat: $chatId');
    try {
      final testMessage = PusherMessageModel.fromJson({
        'id': DateTime.now().millisecondsSinceEpoch,
        'chat_id': chatId,
        'sender_id': 11,
        'receiver_id': 5,
        'body': messageText,
        'created_at': DateTime.now().toIso8601String(),
      });

      onMessageReceived?.call(testMessage);
      ChatMessageService.instance.handleNewMessage(testMessage);
      log('🧪 Test message processed successfully');
    } catch (e) {
      log('🧪 Test message failed: $e');
    }
  }

  void testMessageHandling() {
    log('🧪 Testing message handling...');
    final status = getConnectionStatus();
    status.forEach((key, value) {
      log('🧪 $key: $value');
    });
  }

  void testFullMessagePipeline() {
    log('🧪 Testing full message pipeline...');
    final testMessage = PusherMessageModel.fromJson({
      'id': 999,
      'chat_id': 1,
      'sender_id': 2,
      'receiver_id': 1,
      'body': 'Test message from debugging',
      'created_at': DateTime.now().toIso8601String(),
    });

    log('🧪 Test message created: ${testMessage.body}');
    onMessageReceived?.call(testMessage);
  }

  Future<void> forceReconnect() async {
    log('🔄 Force reconnection requested...');
    _isConnected = false;
    if (_webSocketChannel != null) {
      try {
        _webSocketChannel!.sink.close();
      } catch (e) {
        log('⚠️ Error closing connection during force reconnect: $e');
      }
      _webSocketChannel = null;
    }
    _lastSocketId = null;
    _socketIdCompleter = null;
    await initialize();
  }
}