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

  // Heartbeat mechanism
  Timer? _pingTimer;
  Timer? _pongTimer;
  bool _waitingForPong = false;

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
    log('🚀 === PUSHER INITIALIZATION STARTED ===');
    try {
      if (_isConnected && _webSocketChannel != null) {
        log('✅ WebSocket already connected, skipping initialization');
        log('📊 Current status: connected=$_isConnected, channel=${_webSocketChannel != null}, socketId=$_lastSocketId');
        return;
      }

      if (_webSocketChannel != null) {
        log('🔄 Cleaning up existing WebSocket connection...');
        try {
          _webSocketChannel!.sink.close();
          log('✅ Existing WebSocket closed successfully');
        } catch (e) {
          log('⚠️ Error closing existing WebSocket: $e');
        }
        _webSocketChannel = null;
        _isConnected = false;
        _lastSocketId = null;
        log('🧹 Cleanup completed');
      }

      log('🔄 Initializing WebSocket connection to EU cluster...');
      log('🌍 Cluster: ${PusherConfig.cluster}, App Key: ${PusherConfig.appKey}');

      final wsUrl = 'wss://ws-${PusherConfig.cluster}.pusher.com/app/${PusherConfig.appKey}?protocol=7&client=dart&version=1.0&flash=false';
      log('🔗 Connecting to: $wsUrl');

      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      log('🔗 WebSocket channel created, setting up listener...');

      // Setup listener immediately and wait for connection established event
      await _setupWebSocketListenerAndWaitForConnection();

      if (_isConnected && _webSocketChannel != null) {
        _resetReconnectionAttempts();
        log('✅ WebSocket connected and listener setup successfully');
        log('🎉 === PUSHER INITIALIZATION COMPLETED ===');
        log('📊 Final status: connected=$_isConnected, socketId=$_lastSocketId');
      } else {
        log('❌ Failed to connect to EU cluster');
        log('📊 Final status: connected=$_isConnected, channel=${_webSocketChannel != null}');
        _isConnected = false;
        onConnectionError?.call('Failed to connect to EU cluster');
        _scheduleReconnection();
      }

    } catch (e) {
      log('❌ WebSocket initialization failed: $e');
      log('💥 === PUSHER INITIALIZATION FAILED ===');
      _isConnected = false;
      _webSocketChannel = null;
      _lastSocketId = null;
      _socketIdCompleter = null;
      onConnectionError?.call('WebSocket failed: $e');
      _scheduleReconnection();
    }
  }

  /// Setup WebSocket listener and wait for connection establishment
  Future<void> _setupWebSocketListenerAndWaitForConnection({int timeoutSeconds = 10}) async {
    if (_webSocketChannel == null) {
      throw Exception('WebSocket channel is null');
    }

    log('🔗 Setting up WebSocket stream listener...');
    final completer = Completer<void>();
    Timer? timeoutTimer;

    // Set timeout for connection establishment
    timeoutTimer = Timer(Duration(seconds: timeoutSeconds), () {
      if (!completer.isCompleted) {
        log('⏰ Connection timeout after $timeoutSeconds seconds');
        completer.completeError(TimeoutException('Connection timeout after $timeoutSeconds seconds'));
      }
    });

    // Setup the main stream listener that will handle all messages
    _webSocketChannel!.stream.listen(
      (message) {
        log('📨 WebSocket message received: ${message.toString().substring(0, message.toString().length > 100 ? 100 : message.toString().length)}...');
        
        // Handle connection establishment during initial setup
        if (!_isConnected && !completer.isCompleted) {
          try {
            final data = jsonDecode(message);
            if (data['event'] == 'pusher:connection_established') {
              log('🎉 Connection established event received');
              timeoutTimer?.cancel();
              _isConnected = true;
              if (!completer.isCompleted) {
                completer.complete();
              }
            }
          } catch (e) {
            log('⚠️ Error parsing initial message: $e');
          }
        }
        
        // Handle all messages through the main handler
        _handleWebSocketMessage(message);
      },
      onDone: () {
        log('❌ WebSocket stream closed');
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(Exception('WebSocket closed before connection established'));
        }
        _handleConnectionDeath();
      },
      onError: (error) {
        log('❌ WebSocket stream error: $error');
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
        _handleConnectionDeath();
        onConnectionError?.call(error.toString());
      },
    );

    log('🔗 WebSocket listener setup complete, waiting for connection...');
    return completer.future;
  }

  /// Handle connection death with proper cleanup
  void _handleConnectionDeath() {
    _stopHeartbeat();
    _isConnected = false;
    _webSocketChannel = null;
    _lastSocketId = null;
    _socketIdCompleter = null;
    _currentChannelName = null;

    ChatMessageService.instance.setPusherConnectionStatus(false);
    _scheduleReconnection();
  }

  /// Start heartbeat mechanism
  void _startHeartbeat() {
    log('💓 Starting heartbeat mechanism...');
    _stopHeartbeat();
    
    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      log('💓 Heartbeat timer triggered - checking connection...');
      if (_isConnected && _webSocketChannel != null) {
        log('💓 Connection appears healthy, sending ping...');
        _sendPing();
      } else {
        log('💔 Connection not healthy, stopping heartbeat...');
        _stopHeartbeat();
      }
    });
    
    log('💓 Heartbeat started successfully (30s intervals)');
  }

  /// Stop heartbeat mechanism
  void _stopHeartbeat() {
    log('💓 Stopping heartbeat mechanism...');
    _pingTimer?.cancel();
    _pingTimer = null;
    _pongTimer?.cancel();
    _pongTimer = null;
    _waitingForPong = false;
    log('💓 Heartbeat stopped successfully');
  }

  /// Send ping to keep connection alive
  void _sendPing() {
    log('💓 Attempting to send ping...');
    
    if (_waitingForPong) {
      log('💔 Still waiting for previous pong - connection appears dead');
      _handleConnectionDeath();
      return;
    }

    try {
      final pingMessage = jsonEncode({'event': 'pusher:ping'});
      log('💓 Sending ping message: $pingMessage');
      
      _webSocketChannel!.sink.add(pingMessage);
      _waitingForPong = true;
      
      // Set timeout for pong response
      _pongTimer = Timer(Duration(seconds: 10), () {
        if (_waitingForPong) {
          log('💔 Pong timeout (10s) - connection appears dead');
          _handleConnectionDeath();
        }
      });
      
      log('💓 Ping sent successfully, waiting for pong...');
    } catch (e) {
      log('💔 Failed to send ping: $e');
      _handleConnectionDeath();
    }
  }

  /// Handle pong response
  void _handlePong() {
    log('💓 Pong received - processing...');
    _waitingForPong = false;
    _pongTimer?.cancel();
    _pongTimer = null;
    log('💓 Pong processed successfully - connection confirmed alive');
  }

  /// Wait for socket ID to be available
  Future<String> _waitForSocketId({int timeoutSeconds = 10}) async {
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
    log('🗑️ === PUSHER DISPOSE STARTED ===');

    log('💓 Stopping heartbeat mechanism...');
    _stopHeartbeat();
    
    log('🔄 Cancelling reconnection timer...');
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;

    if (_webSocketChannel != null) {
      log('🔌 Closing WebSocket connection...');
      try {
        _webSocketChannel!.sink.close();
        log('✅ WebSocket closed successfully');
      } catch (e) {
        log('⚠️ Error closing WebSocket during dispose: $e');
      }
      _webSocketChannel = null;
    }
    
    log('🧹 Cleaning up state variables...');
    _isConnected = false;
    _currentChannelName = null;
    _reconnectionAttempts = 0;
    _lastSocketId = null;
    _socketIdCompleter = null;
    
    log('✅ === PUSHER DISPOSE COMPLETED ===');
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
    log('🔔 Starting subscription process for channel: $channelName');

    // Smart channel management - prevent duplicate subscriptions
    if (_currentChannelName == channelName && _isConnected) {
      log('✅ Already subscribed to channel $channelName and connected, skipping...');
      return;
    }

    // Unsubscribe from previous channel if switching
    if (_currentChannelName != null && _currentChannelName != channelName) {
      log('🔄 Switching from $_currentChannelName to $channelName');
      unsubscribeFromChatChannel();
    }

    log('🔍 Checking connection status - isConnected: $_isConnected, hasChannel: ${_webSocketChannel != null}');
    
    if (!_isConnected || _webSocketChannel == null) {
      log('🔄 WebSocket not connected, initializing first...');
      await initialize();
      log('⏳ Waiting 1s for connection to stabilize...');
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    if (!_isConnected || _webSocketChannel == null) {
      log('❌ Failed to establish WebSocket connection for subscription');
      onConnectionError?.call('Failed to establish connection for subscription');
      return;
    }

    _currentChannelName = channelName;
    log('🔗 Connection confirmed, preparing subscription for channel: $channelName');

    try {
      // Wait for socket ID with proper timeout
      log('🆔 Waiting for socket ID...');
      final socketId = await _waitForSocketId(timeoutSeconds: 10);
      log('✅ Got socket ID: $socketId');

      // Request authentication from Laravel backend
      log('🔐 Requesting authentication from backend...');
      final authUrl = 'https://elsadkeen.sharetrip-ksa.com/api/broadcasting/auth';
      log('🔐 Auth URL: $authUrl');
      log('🔐 Auth payload: socket_id=$socketId, channel_name=$channelName');
      
      final response = await http.post(
        Uri.parse(authUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Accept': 'application/json',
        },
        body: {
          'socket_id': socketId,
          'channel_name': channelName,
        },
      );

      log('🔐 Auth response status: ${response.statusCode}');
      log('🔐 Auth response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authSignature = data['auth'];

        log('✅ Authentication successful, subscribing to channel...');
        log('🔐 Auth signature received: ${authSignature.substring(0, 20)}...');

        // Send subscription request with authentication
        final subscribeMessage = {
          'event': 'pusher:subscribe',
          'data': {
            'auth': authSignature,
            'channel': channelName,
          }
        };

        log('📤 Sending subscription message: ${jsonEncode(subscribeMessage)}');
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

      log('🔍 Parsing WebSocket message...');
      final data = jsonDecode(message);
      final eventType = data['event'];

      log('📨 Received event: $eventType');

      if (eventType == 'pusher:connection_established') {
        log('🎉 Processing connection established event...');
        
        if (!_isConnected) {
          _isConnected = true;
          log('✅ Connection status updated to: $_isConnected');
        }
        
        final socketData = jsonDecode(data['data']);
        _lastSocketId = socketData['socket_id'];
        log('🆔 Socket ID received: $_lastSocketId');

        // Complete the socket ID completer if waiting
        if (_socketIdCompleter != null && !_socketIdCompleter!.isCompleted) {
          log('✅ Completing socket ID completer...');
          _socketIdCompleter!.complete(_lastSocketId!);
        }

        // Start heartbeat mechanism
        log('💓 Starting heartbeat mechanism...');
        _startHeartbeat();

        onConnectionEstablished?.call('Connected');
        ChatMessageService.instance.setPusherConnectionStatus(true);
        log('✅ Pusher fully connected with socket ID: $_lastSocketId');

      } else if (eventType == 'pusher:subscription_succeeded') {
        log('✅ Subscription succeeded for $_currentChannelName');

      } else if (eventType == 'pusher:subscription_error') {
        log('❌ Subscription failed: ${data['data']}');
        onConnectionError?.call('Subscription failed: ${data['data']}');
        _currentChannelName = null; // Reset on subscription failure

      } else if (_isMessageEvent(eventType)) {
        log('💬 Message event received: $eventType');
        _processMessageEvent(data);

      } else if (eventType == 'pusher:pong') {
        _handlePong();

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
    log('🔌 === PUSHER DISCONNECT STARTED ===');
    try {
      log('💓 Stopping heartbeat...');
      _stopHeartbeat();
      
      log('🚪 Unsubscribing from channels...');
      unsubscribeFromChatChannel();
      
      log('🔌 Closing WebSocket connection...');
      _webSocketChannel?.sink.close(status.goingAway);
      _webSocketChannel = null;
      _isConnected = false;
      _lastSocketId = null;
      _socketIdCompleter = null;
      
      log('✅ === PUSHER DISCONNECT COMPLETED ===');
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
    _stopHeartbeat();
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
    _currentChannelName = null;
    await initialize();
  }
}