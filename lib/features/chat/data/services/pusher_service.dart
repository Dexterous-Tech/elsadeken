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
  String? _lastSocketId; // holds current Pusher socket_id
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
  static const int _baseReconnectionDelay = 3; // seconds

  // Callbacks
  Function(PusherMessageModel)? onMessageReceived;
  Function(String)? onConnectionEstablished;
  Function(String)? onConnectionError;

  /// Set authentication token for private channels
  void setAuthToken(String token) {
    _authToken = token;
    log('🔑 Auth token set for private channels');
  }

  Future<void> setAuthTokenFromBackend(int chatRoomId, String socketId,  String bearerToken) async {
    final response = await http.post(
      Uri.parse('https://elsadkeen.sharetrip-ksa.com/api/broadcasting/auth'),
      headers: {'Authorization': 'Bearer $bearerToken'},
      body: {
        'socket_id': socketId,
        'channel_name': 'private-chat.$chatRoomId',
      },
    );

    final data = jsonDecode(response.body);
    _authToken = data['auth']; // <-- whole "APP_KEY:SIGNED_HMAC"
  }


  /// Initialize WebSocket connection to EU cluster only
  Future<void> initialize() async {
    try {
      // Prevent multiple simultaneous initialization attempts
      if (_isConnected && _webSocketChannel != null) {
        log('✅ WebSocket already connected, skipping initialization');
        return;
      }
      
      // Clean up existing connection if any
      if (_webSocketChannel != null) {
        log('🔄 Cleaning up existing WebSocket connection...');
        try {
          _webSocketChannel!.sink.close();
        } catch (e) {
          log('⚠️ Error closing existing WebSocket: $e');
        }
        _webSocketChannel = null;
        _isConnected = false;
      }
      
      log('🔄 Initializing WebSocket connection to EU cluster...');
      
      // Use only EU cluster as backend depends on it
      final wsUrl = 'wss://ws-${PusherConfig.cluster}.pusher.com/app/${PusherConfig.appKey}?protocol=7&client=dart&version=1.0&flash=false';
      log('🔗 Connecting to: $wsUrl');

      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Wait for connection
      await Future.delayed(Duration(milliseconds: 2000));
      
        if (_webSocketChannel != null) {
          _isConnected = true;
          _resetReconnectionAttempts(); // Reset reconnection attempts on successful connection
          onConnectionEstablished?.call('Connected to Pusher via EU cluster');
          log('✅ WebSocket connected successfully via EU cluster');

          _webSocketChannel!.stream.listen(
          (message) => _handleWebSocketMessage(message),
          onDone: () {
            log('❌ WebSocket closed');
            _isConnected = false;
            _webSocketChannel = null;
            // Schedule reconnection
            _scheduleReconnection();
          },
          onError: (error) {
            log('❌ WebSocket error: $error');
            _isConnected = false;
            _webSocketChannel = null;
            onConnectionError?.call(error.toString());
            // Schedule reconnection
            _scheduleReconnection();
          },
        );
      } else {
        log('❌ Failed to connect to EU cluster');
        _isConnected = false;
        onConnectionError?.call('Failed to connect to EU cluster');
        // Schedule reconnection for connection failures
        _scheduleReconnection();
      }

    } catch (e) {
      log('❌ WebSocket initialization failed: $e');
      _isConnected = false;
      _webSocketChannel = null;
      onConnectionError?.call('WebSocket failed: $e');
      // Schedule reconnection for initialization failures
      _scheduleReconnection();
    }
  }

  /// Reset reconnection attempts when connection is successful
  void _resetReconnectionAttempts() {
    _reconnectionAttempts = 0;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
    log('✅ Reconnection attempts reset to 0');
  }

  /// Dispose of the WebSocket connection
  void dispose() {
    log('🔄 Disposing WebSocket connection...');
    
    // Cancel any pending reconnection timer
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
    _reconnectionAttempts = 0; // Reset reconnection attempts
    log('✅ WebSocket connection disposed');
  }

  /// Schedule automatic reconnection
  void _scheduleReconnection() {
    if (_isConnected) return; // Already reconnecting or connected
    
    // Check if we've exceeded maximum reconnection attempts
    if (_reconnectionAttempts >= _maxReconnectionAttempts) {
      log('❌ Maximum reconnection attempts ($_maxReconnectionAttempts) reached. Stopping reconnection.');
      onConnectionError?.call('Failed to connect after $_maxReconnectionAttempts attempts. Please check your network connection.');
      return;
    }
    
    // Cancel any existing reconnection timer
    _reconnectionTimer?.cancel();
    
    // Calculate delay with exponential backoff
    final delay = _baseReconnectionDelay * (1 << _reconnectionAttempts); // Exponential backoff: 3, 6, 12, 24, 48 seconds
    _reconnectionAttempts++;
    
    log('🔄 Scheduling reconnection attempt $_reconnectionAttempts in ${delay} seconds... (${_maxReconnectionAttempts - _reconnectionAttempts} attempts remaining)');
    
    _reconnectionTimer = Timer(Duration(seconds: delay), () async {
      if (!_isConnected) {
        log('🔄 Attempting reconnection $_reconnectionAttempts...');
        try {
          await initialize();
        } catch (e) {
          log('❌ Reconnection attempt $_reconnectionAttempts failed: $e');
          // Schedule next reconnection attempt if we haven't reached the limit
          if (_reconnectionAttempts < _maxReconnectionAttempts) {
            _scheduleReconnection();
          }
        }
      }
    });
  }

  /// Subscribe to a private chat channel

  Future<void> subscribeToChatChannel(int chatRoomId, String bearerToken) async {
    // Check if already subscribed to this channel
    if (_currentChannelName == 'private-chat.$chatRoomId') {
      log('✅ Already subscribed to channel private-chat.$chatRoomId, skipping...');
      return;
    }

    // Ensure connection
    if (!_isConnected || _webSocketChannel == null) {
      log('🔄 WebSocket not connected, initializing first...');
      await initialize();
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!_isConnected || _webSocketChannel == null) {
      log('❌ Failed to establish WebSocket connection for subscription');
      onConnectionError?.call('Failed to establish connection for subscription');
      return;
    }

    final channelName = 'private-chat.$chatRoomId';
    _currentChannelName = channelName;

    log('🔗 Preparing subscription for channel: $channelName');

    // Step 1: Wait until we have a socket_id from Pusher
    if (_lastSocketId == null) {
      log('⚠️ No socket_id yet, waiting...');
      await Future.delayed(const Duration(seconds: 1));
    }

    if (_lastSocketId == null) {
      log('❌ Still no socket_id, cannot authenticate channel.');
      return;
    }

    // Step 2: Ask Laravel backend for auth signature
    try {
      final response = await http.post(
        Uri.parse('https://elsadkeen.sharetrip-ksa.com/api/broadcasting/auth'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Accept': 'application/json',
        },
        body: {
          'socket_id': _lastSocketId!,
          'channel_name': channelName,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['auth']; // <-- use full "APP_KEY:SIGNED_HMAC"

        // Step 3: Send subscription request with correct auth
        final subscribeMessage = {
          'event': 'pusher:subscribe',
          'data': {
            'auth': _authToken,
            'channel': channelName,
          }
        };

        _webSocketChannel!.sink.add(jsonEncode(subscribeMessage));
        log('✅ Subscription request sent for $channelName with auth.');
      } else {
        log('❌ Auth request failed: ${response.statusCode} ${response.body}');
        onConnectionError?.call('Auth request failed');
      }
    } catch (e) {
      log('❌ Auth request error: $e');
      onConnectionError?.call('Auth error: $e');
    }
  }

  /// Handle WebSocket messages
  void _handleWebSocketMessage(dynamic message) {
    try {
      if (message is! String) {
        log('⚠️ Non-string WebSocket message: ${message.runtimeType}');
        return;
      }

      final data = jsonDecode(message);
      log('📨 Event Test:  $data');
      final eventType = data['event'];
      log('📨 Event:  $eventType');
      
      // Log all events for debugging
      log('🔍 Full message structure: ${data.keys.toList()}');
      if (data.containsKey('data')) {
        log('🔍 Data field type: ${data['data'].runtimeType}');
        log('🔍 Data field content: ${data['data']}');
      }

      if (eventType == 'pusher:connection_established') {
        _isConnected = true;
        final socketData = jsonDecode(data['data']);
        _lastSocketId = socketData['socket_id']; // <-- missing line
        onConnectionEstablished?.call('Connected');
        log('✅ Pusher connected');
      } else if (eventType == 'pusher:subscription_succeeded') {
        log('✅ Subscription succeeded for $_currentChannelName');
      } else if (eventType == 'pusher:subscription_error') {
        log('❌ Subscription failed: ${data['data']}');
        onConnectionError?.call('Subscription failed: ${data['data']}');
      } else if (eventType == 'App\\Events\\MessageSent' || 
                 eventType == 'MessageSent' ||
                 eventType == 'message.sent' ||
                 eventType == 'chat.message') {
        log('💬 Message event received: $eventType');
        final messageData = data['data'];
        log('📨 Message data: $messageData');
        log('📨 Message data type: ${messageData.runtimeType}');

        if (messageData is String) {
          try {
            log('🔄 Parsing string message data...');
            final parsed = jsonDecode(messageData);
            log('🔄 Parsed string data: $parsed');
            _processMessage(parsed);
          } catch (e) {
            log('❌ Failed to parse string message data: $e');
            log('🔍 Raw string data: $messageData');
          }
        } else if (messageData is Map<String, dynamic>) {
          log('🔄 Processing map message data...');
          _processMessage(messageData);
        } else {
          log('⚠️ Unexpected message data type: ${messageData.runtimeType}');
          log('🔍 Raw message data: $messageData');
        }
      } else if (eventType == 'pusher_internal:subscription_succeeded') {
        log('✅ Subscription succeeded for $_currentChannelName');
      } else if (eventType == 'pusher:error') {
        log('⚠️ Pusher error: ${data['data']}');
      } else {
        log('ℹ️ Other event: $eventType');
        // Log the full data for debugging
        log('📋 Full event data: $data');
      }
    } catch (e) {
      log('❌ Error handling message: $e');
    }
  }

  void _processMessage(Map<String, dynamic> json) {
    try {
      log('🔍 Processing message JSON: $json');
      log('🔍 JSON keys: ${json.keys.toList()}');
      
      // Try different possible data structures
      Map<String, dynamic> messageJson;
      
      if (json.containsKey('message')) {
        log('🔍 Found "message" key');
        messageJson = json['message'] as Map<String, dynamic>;
      } else if (json.containsKey('data')) {
        log('🔍 Found "data" key');
        messageJson = json['data'] as Map<String, dynamic>;
      } else if (json.containsKey('body')) {
        log('🔍 Found "body" key - assuming direct message structure');
        messageJson = json;
      } else if (json.containsKey('id') && json.containsKey('chat_id')) {
        log('🔍 Found direct message structure with id and chat_id');
        messageJson = json;
      } else {
        log('🔍 No standard keys found - assuming json itself is the message');
        messageJson = json;
      }
      
      log('🔍 Extracted message data: $messageJson');
      log('🔍 Message data keys: ${messageJson.keys.toList()}');
      
      final pusherMessage = PusherMessageModel.fromJson(messageJson);
      log('✅ Parsed PusherMessage: ${pusherMessage.body}');
      log('✅ PusherMessage details: ID=${pusherMessage.id}, ChatID=${pusherMessage.chatId}, SenderID=${pusherMessage.senderId}');
      
      // Notify both the callback and the message service
      onMessageReceived?.call(pusherMessage);
      ChatMessageService.instance.handleNewMessage(pusherMessage);
    } catch (e) {
      log('⚠️ Failed to parse PusherMessage: $e');
      log('🔍 Raw JSON that failed: $json');
      log('🔍 Error details: ${e.toString()}');
    }
  }

  /// Unsubscribe from the current chat channel
  void unsubscribeFromChatChannel() {
    if (_currentChannelName == null || _webSocketChannel == null) return;

    final unsubscribeMessage = {
      'event': 'pusher:unsubscribe',
      'data': {'channel': _currentChannelName}
    };
    
    _webSocketChannel!.sink.add(jsonEncode(unsubscribeMessage));
    log('🚪 WebSocket unsubscribed from $_currentChannelName');
    _currentChannelName = null;
  }

  /// Disconnect
  void disconnect() {
    try {
      unsubscribeFromChatChannel();
      _webSocketChannel?.sink.close(status.goingAway);
      _webSocketChannel = null;
      _isConnected = false;
      log('🔌 Disconnected');
    } catch (e) {
      log('❌ Error disconnecting: $e');
    }
  }

  bool get isConnected => _isConnected;
  String? get currentChannelName => _currentChannelName;

  /// Check the health of the connection
  Future<bool> checkConnectionHealth() async {
    try {
      if (_webSocketChannel == null || !_isConnected) {
        log('🔄 Connection unhealthy, reconnecting...');
        await initialize();
        return _isConnected;
      }

      // Try a ping to test connection
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

  /// Get connection status details for debugging
  Map<String, dynamic> getConnectionStatus() {
    return {
      'isConnected': _isConnected,
      'hasWebSocket': _webSocketChannel != null,
      'currentChannel': _currentChannelName,
      'hasAuthToken': _authToken != null,
      'cluster': PusherConfig.cluster,
    };
  }

  /// Get comprehensive network and connection diagnostics
  Future<Map<String, dynamic>> getDetailedDiagnostics() async {
    final diagnostics = await NetworkHelper.getNetworkDiagnostics();
    final connectionStatus = getConnectionStatus();
    
    return {
      ...connectionStatus,
      'networkDiagnostics': diagnostics,
      'reconnectionAttempts': _reconnectionAttempts,
      'maxReconnectionAttempts': _maxReconnectionAttempts,
      'hasReconnectionTimer': _reconnectionTimer != null,
    };
  }

  /// Force reconnection (useful for debugging)
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
    await initialize();
  }

  /// Test message handling (for debugging)
  void testMessageHandling() {
    log('🧪 Testing message handling...');
    final testMessage = {
      'message': {
        'id': 999,
        'chat_id': 13,
        'sender_id': 11,
        'receiver_id': 34,
        'body': 'Test message from Pusher',
        'is_read': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }
    };
    
    try {
      _processMessage(testMessage);
      log('✅ Test message processed successfully');
    } catch (e) {
      log('❌ Test message failed: $e');
    }
  }

  /// Test the full message pipeline (for debugging)
  void testFullMessagePipeline() {
    log('🧪 Testing full message pipeline...');
    
    // Simulate a real Pusher message event
    final testPusherEvent = {
      'event': 'App\\Events\\MessageSent',
      'data': {
        'message': {
          'id': 999,
          'chat_id': 13,
          'sender_id': 11,
          'receiver_id': 34,
          'body': 'Test message from Pusher',
          'is_read': 0,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }
      }
    };
    
    try {
      _handleWebSocketMessage(jsonEncode(testPusherEvent));
      log('✅ Full message pipeline test completed');
    } catch (e) {
      log('❌ Full message pipeline test failed: $e');
    }
  }
}
