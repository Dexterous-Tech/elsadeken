import 'dart:async';
import 'dart:convert';
import 'package:elsadeken/core/networking/api_constants.dart';
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
  }

  /// Initialize WebSocket connection to EU cluster only
  Future<void> initialize() async {
    try {
      if (_isConnected && _webSocketChannel != null) {
        return;
      }

      if (_webSocketChannel != null) {
        try {
          _webSocketChannel!.sink.close();
        } catch (e) {
          //
        }
        _webSocketChannel = null;
        _isConnected = false;
        _lastSocketId = null;
      }

      final wsUrl =
          'wss://ws-${PusherConfig.cluster}.pusher.com/app/${PusherConfig.appKey}?protocol=7&client=dart&version=1.0&flash=false';

      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Setup listener immediately and wait for connection established event
      await _setupWebSocketListenerAndWaitForConnection();

      if (_isConnected && _webSocketChannel != null) {
        _resetReconnectionAttempts();
      } else {
        _isConnected = false;
        onConnectionError?.call('Failed to connect to EU cluster');
        _scheduleReconnection();
      }
    } catch (e) {
      _isConnected = false;
      _webSocketChannel = null;
      _lastSocketId = null;
      _socketIdCompleter = null;
      onConnectionError?.call('WebSocket failed: $e');
      _scheduleReconnection();
    }
  }

  /// Setup WebSocket listener and wait for connection establishment
  Future<void> _setupWebSocketListenerAndWaitForConnection({
    int timeoutSeconds = 10,
  }) async {
    if (_webSocketChannel == null) {
      throw Exception('WebSocket channel is null');
    }

    final completer = Completer<void>();
    Timer? timeoutTimer;

    // Set timeout for connection establishment
    timeoutTimer = Timer(Duration(seconds: timeoutSeconds), () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('Connection timeout after $timeoutSeconds seconds'),
        );
      }
    });

    // Setup the main stream listener that will handle all messages
    _webSocketChannel!.stream.listen(
      (message) {
        // Handle connection establishment during initial setup
        if (!_isConnected && !completer.isCompleted) {
          try {
            final data = jsonDecode(message);
            if (data['event'] == 'pusher:connection_established') {
              timeoutTimer?.cancel();
              _isConnected = true;
              if (!completer.isCompleted) {
                completer.complete();
              }
            }
          } catch (e) {
            // Silent error handling during connection
          }
        }

        // Handle all messages through the main handler (process immediately)
        _handleWebSocketMessage(message);
      },
      onDone: () {
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(
            Exception('WebSocket closed before connection established'),
          );
        }
        _handleConnectionDeath();
      },
      onError: (error) {
        timeoutTimer?.cancel();
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
        _handleConnectionDeath();
        onConnectionError?.call(error.toString());
      },
    );

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
    _stopHeartbeat();

    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_isConnected && _webSocketChannel != null) {
        _sendPing();
      } else {
        _stopHeartbeat();
      }
    });
  }

  /// Stop heartbeat mechanism
  void _stopHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = null;
    _pongTimer?.cancel();
    _pongTimer = null;
    _waitingForPong = false;
  }

  /// Send ping to keep connection alive
  void _sendPing() {
    if (_waitingForPong) {
      _handleConnectionDeath();
      return;
    }

    try {
      final pingMessage = jsonEncode({'event': 'pusher:ping'});

      _webSocketChannel!.sink.add(pingMessage);
      _waitingForPong = true;

      // Set timeout for pong response
      _pongTimer = Timer(Duration(seconds: 10), () {
        if (_waitingForPong) {
          _handleConnectionDeath();
        }
      });
    } catch (e) {
      _handleConnectionDeath();
    }
  }

  /// Handle pong response
  void _handlePong() {
    _waitingForPong = false;
    _pongTimer?.cancel();
    _pongTimer = null;
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
          throw TimeoutException(
            'Socket ID not received within $timeoutSeconds seconds',
          );
        },
      );
    } catch (e) {
      _socketIdCompleter = null;
      rethrow;
    }
  }

  void _resetReconnectionAttempts() {
    _reconnectionAttempts = 0;
    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;
  }

  void dispose() {
    _stopHeartbeat();

    _reconnectionTimer?.cancel();
    _reconnectionTimer = null;

    if (_webSocketChannel != null) {
      try {
        _webSocketChannel!.sink.close();
      } catch (e) {
        //
      }
      _webSocketChannel = null;
    }

    _isConnected = false;
    _currentChannelName = null;
    _reconnectionAttempts = 0;
    _lastSocketId = null;
    _socketIdCompleter = null;
  }

  void _scheduleReconnection() {
    if (_isConnected) return;

    if (_reconnectionAttempts >= _maxReconnectionAttempts) {
      onConnectionError?.call(
        'Failed to connect after $_maxReconnectionAttempts attempts.',
      );
      return;
    }

    _reconnectionTimer?.cancel();

    final delay = _baseReconnectionDelay * (1 << _reconnectionAttempts);
    _reconnectionAttempts++;

    _reconnectionTimer = Timer(Duration(seconds: delay), () async {
      if (!_isConnected) {
        try {
          await initialize();
        } catch (e) {
          if (_reconnectionAttempts < _maxReconnectionAttempts) {
            _scheduleReconnection();
          }
        }
      }
    });
  }

  /// Subscribe to a private chat channel with improved socket ID handling
  Future<void> subscribeToChatChannel(
    int chatRoomId,
    String bearerToken,
  ) async {
    final channelName = 'private-chat.$chatRoomId';

    // Smart channel management - prevent duplicate subscriptions
    if (_currentChannelName == channelName && _isConnected) {
      return;
    }

    // Unsubscribe from previous channel if switching
    if (_currentChannelName != null && _currentChannelName != channelName) {
      unsubscribeFromChatChannel();
    }

    if (!_isConnected || _webSocketChannel == null) {
      await initialize();

      await Future.delayed(const Duration(milliseconds: 1000));
    }

    if (!_isConnected || _webSocketChannel == null) {
      onConnectionError?.call(
        'Failed to establish connection for subscription',
      );
      return;
    }

    _currentChannelName = channelName;

    try {
      // Wait for socket ID with proper timeout

      final socketId = await _waitForSocketId(timeoutSeconds: 10);

      // Request authentication from Laravel backend

      final authUrl = '${ApiConstants.baseUrl}/broadcasting/auth';

      final response = await http.post(
        Uri.parse(authUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Accept': 'application/json',
        },
        body: {'socket_id': socketId, 'channel_name': channelName},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final authSignature = data['auth'];

        // Send subscription request with authentication
        final subscribeMessage = {
          'event': 'pusher:subscribe',
          'data': {'auth': authSignature, 'channel': channelName},
        };

        _webSocketChannel!.sink.add(jsonEncode(subscribeMessage));
      } else {
        onConnectionError?.call(
          'Authentication failed: ${response.statusCode}',
        );
      }
    } catch (e) {
      onConnectionError?.call('Subscription error: $e');
      _currentChannelName = null; // Reset on failure
    }
  }

  /// Handle WebSocket messages with improved message processing
  void _handleWebSocketMessage(dynamic message) {
    try {
      if (message is! String) {
        return; // Skip non-string messages silently
      }

      final data = jsonDecode(message);
      final eventType = data['event'];

      if (eventType == 'pusher:connection_established') {
        if (!_isConnected) {
          _isConnected = true;
        }

        final socketData = jsonDecode(data['data']);
        _lastSocketId = socketData['socket_id'];

        // Complete the socket ID completer if waiting
        if (_socketIdCompleter != null && !_socketIdCompleter!.isCompleted) {
          _socketIdCompleter!.complete(_lastSocketId!);
        }

        // Start heartbeat mechanism
        _startHeartbeat();

        onConnectionEstablished?.call('Connected');
        ChatMessageService.instance.setPusherConnectionStatus(true);
      } else if (eventType == 'pusher:subscription_succeeded') {
      } else if (eventType == 'pusher:subscription_error') {
        onConnectionError?.call('Subscription failed: ${data['data']}');
        _currentChannelName = null; // Reset on subscription failure
      } else if (_isMessageEvent(eventType)) {
        // Process message immediately without logging to reduce latency
        _processMessageEvent(data);
      } else if (eventType == 'pusher:pong') {
        _handlePong();
      } else if (eventType == 'pusher:error') {
        onConnectionError?.call('Pusher error: ${data['data']}');
      } else {
        // Try to process unknown events as potential messages
        _tryProcessAsMessage(data);
      }
    } catch (e) {
      //
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
      } else {}
    } catch (e) {
      //
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
            _processMessage(parsed);
          }
        } else if (eventData is Map<String, dynamic> &&
            _looksLikeMessage(eventData)) {
          _processMessage(eventData);
        }
      }
    } catch (e) {
      //
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
      // Extract message data from various possible structures
      Map<String, dynamic> messageJson;

      if (json.containsKey('message')) {
        messageJson = json['message'] as Map<String, dynamic>;
      } else if (json.containsKey('data')) {
        messageJson = json['data'] as Map<String, dynamic>;
      } else {
        messageJson = json;
      }

      final pusherMessage = PusherMessageModel.fromJson(messageJson);

      // Emit message immediately for fastest processing
      onMessageReceived?.call(pusherMessage);
      ChatMessageService.instance.handleNewMessage(pusherMessage);
    } catch (e) {
      //
    }
  }

  /// Unsubscribe from the current chat channel
  void unsubscribeFromChatChannel() {
    if (_currentChannelName == null || _webSocketChannel == null) return;

    final unsubscribeMessage = {
      'event': 'pusher:unsubscribe',
      'data': {'channel': _currentChannelName},
    };

    try {
      _webSocketChannel!.sink.add(jsonEncode(unsubscribeMessage));
    } catch (e) {
      //
    }

    _currentChannelName = null;
  }

  /// Disconnect from Pusher
  void disconnect() {
    try {
      _stopHeartbeat();

      unsubscribeFromChatChannel();

      _webSocketChannel?.sink.close(status.goingAway);
      _webSocketChannel = null;
      _isConnected = false;
      _lastSocketId = null;
      _socketIdCompleter = null;
    } catch (e) {
      //
    }
  }

  bool get isConnected => _isConnected;
  String? get currentChannelName => _currentChannelName;

  /// Check connection health
  Future<bool> checkConnectionHealth() async {
    try {
      if (_webSocketChannel == null || !_isConnected) {
        await initialize();
        return _isConnected;
      }

      // Test with ping
      try {
        _webSocketChannel!.sink.add(jsonEncode({'event': 'pusher:ping'}));

        return true;
      } catch (e) {
        await initialize();
        return _isConnected;
      }
    } catch (e) {
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
    } catch (e) {
      //
    }
  }

  void testMessageHandling() {
    final status = getConnectionStatus();
    status.forEach((key, value) {});
  }

  void testFullMessagePipeline() {
    final testMessage = PusherMessageModel.fromJson({
      'id': 999,
      'chat_id': 1,
      'sender_id': 2,
      'receiver_id': 1,
      'body': 'Test message from debugging',
      'created_at': DateTime.now().toIso8601String(),
    });

    onMessageReceived?.call(testMessage);
  }

  Future<void> forceReconnect() async {
    _stopHeartbeat();
    _isConnected = false;
    if (_webSocketChannel != null) {
      try {
        _webSocketChannel!.sink.close();
      } catch (e) {
        //
      }
      _webSocketChannel = null;
    }
    _lastSocketId = null;
    _socketIdCompleter = null;
    _currentChannelName = null;
    await initialize();
  }
}
