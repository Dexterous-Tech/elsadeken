import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

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
  static PusherService? _instance;
  static PusherService get instance => _instance ??= PusherService._internal();

  PusherService._internal();

  WebSocketChannel? _webSocketChannel;
  bool _isConnected = false;
  String? _currentChannelName;
  String? _authToken;

  // Callbacks
  Function(PusherMessageModel)? onMessageReceived;
  Function(String)? onConnectionEstablished;
  Function(String)? onConnectionError;

  /// Set authentication token for private channels
  void setAuthToken(String token) {
    _authToken = token;
    log('🔑 Auth token set for private channels');
  }

  /// Initialize WebSocket connection to EU cluster only
  Future<void> initialize() async {
    try {
      log('🔄 Initializing WebSocket connection to EU cluster...');
      
      // Use only EU cluster as backend depends on it
      final wsUrl = 'wss://ws-${PusherConfig.cluster}.pusherapp.com/app/${PusherConfig.appKey}?protocol=7&client=dart&version=1.0&flash=false';
      log('🔗 Connecting to: $wsUrl');

      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Wait for connection
      await Future.delayed(Duration(milliseconds: 2000));
      
      if (_webSocketChannel != null) {
        _isConnected = true;
        onConnectionEstablished?.call('Connected to Pusher via EU cluster');
        log('✅ WebSocket connected successfully via EU cluster');

        _webSocketChannel!.stream.listen(
          (message) => _handleWebSocketMessage(message),
          onDone: () {
            log('❌ WebSocket closed');
            _isConnected = false;
            // Schedule reconnection
            _scheduleReconnection();
          },
          onError: (error) {
            log('❌ WebSocket error: $error');
            _isConnected = false;
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
      onConnectionError?.call('WebSocket failed: $e');
      // Schedule reconnection for initialization failures
      _scheduleReconnection();
    }
  }

  /// Schedule automatic reconnection
  void _scheduleReconnection() {
    if (_isConnected) return; // Already reconnecting or connected
    
    log('🔄 Scheduling reconnection in 3 seconds...');
    Timer(Duration(seconds: 3), () async {
      if (!_isConnected) {
        log('🔄 Attempting to reconnect...');
        try {
          await initialize();
        } catch (e) {
          log('❌ Reconnection failed: $e');
        }
      }
    });
  }

  /// Subscribe to a private chat channel
  Future<void> subscribeToChatChannel(int chatRoomId) async {
    if (!_isConnected) {
      await initialize();
    }

    final channelName = 'private-chat.$chatRoomId';
    _currentChannelName = channelName;

    log('🔗 Subscribing to private channel: $channelName');

    if (_webSocketChannel != null) {
      // WebSocket subscription for private channel
      if (_authToken == null) {
        log('⚠️ No auth token available for private channel subscription');
        onConnectionError?.call('Authentication required for private channel');
        return;
      }

      final subscribeMessage = {
        'event': 'pusher:subscribe',
        'data': {
          'auth': _authToken, // Use the auth token for private channels
          'channel': channelName,
        }
      };
      
      log('🔐 Sending authenticated subscription with token: ${_authToken!.substring(0, 20)}...');
      _webSocketChannel!.sink.add(jsonEncode(subscribeMessage));
      log('✅ WebSocket authenticated subscription sent');
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
      final eventType = data['event'];
      log('📨 Event: $eventType');

      if (eventType == 'pusher:connection_established') {
        _isConnected = true;
        onConnectionEstablished?.call('Connected');
        log('✅ Pusher connected');
      } else if (eventType == 'pusher:subscription_succeeded') {
        log('✅ Subscription succeeded for $_currentChannelName');
      } else if (eventType == 'pusher:subscription_error') {
        log('❌ Subscription failed: ${data['data']}');
        onConnectionError?.call('Subscription failed: ${data['data']}');
      } else if (eventType == 'App\\Events\\MessageSent') {
        log('💬 Message event received');
        final messageData = data['data'];

        if (messageData is String) {
          final parsed = jsonDecode(messageData);
          _processMessage(parsed);
        } else if (messageData is Map<String, dynamic>) {
          _processMessage(messageData);
        }
      } else {
        log('ℹ️ Other event: $eventType');
      }
    } catch (e) {
      log('❌ Error handling message: $e');
    }
  }

  void _processMessage(Map<String, dynamic> json) {
    try {
      final messageJson = json['message'] as Map<String, dynamic>;
      final pusherMessage = PusherMessageModel.fromJson(messageJson);
      log('✅ Parsed PusherMessage: ${pusherMessage.body}');
      onMessageReceived?.call(pusherMessage);
    } catch (e) {
      log('⚠️ Failed to parse PusherMessage: $e');
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
}
