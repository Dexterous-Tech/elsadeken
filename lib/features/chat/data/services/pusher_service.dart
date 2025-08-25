import 'dart:developer';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:elsadeken/core/helper/app_constants.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';

class PusherService {
  static PusherService? _instance;
  static PusherService get instance {
    _instance ??= PusherService._internal();
    return _instance!;
  }

  PusherService._internal();

  WebSocketChannel? _channel;
  bool _isConnected = false;
  String? _currentChannelName;

  // Callback for when new messages are received
  Function(PusherMessageModel)? onMessageReceived;
  Function(String)? onConnectionEstablished;
  Function(String)? onConnectionError;

  /// Initialize WebSocket connection to Pusher
  Future<void> initialize() async {
    try {
      // Wait for network to be ready (Android sometimes needs a moment)
      await Future.delayed(Duration(milliseconds: 800));

      // Connect to Pusher WebSocket
      final wsUrl =
          'wss://ws-${PusherConfig.cluster}.pusherapp.com/app/${PusherConfig.appKey}?protocol=7&client=js&version=7.6.0&flash=false';

      log('🔄 Attempting to connect to: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen for connection
      _channel!.stream.listen(
        (message) {
          _handleWebSocketMessage(message);
        },
        onDone: () {
          log('WebSocket connection closed');
          _isConnected = false;
        },
        onError: (error) {
          log('WebSocket error: $error');
          _isConnected = false;
          // Don't call onConnectionError here - we'll handle it silently
        },
      );

      // Wait for connection to establish with timeout
      bool connectionEstablished = false;
      int attempts = 0;
      const maxAttempts = 15; // Increased attempts

      while (!connectionEstablished && attempts < maxAttempts) {
        await Future.delayed(Duration(milliseconds: 400));
        attempts++;

        // Check if we can send a ping message
        try {
          if (_channel != null) {
            _channel!.sink.add(jsonEncode({'event': 'pusher:ping'}));
            connectionEstablished = true;
            log('✅ Connection test successful');
          }
        } catch (e) {
          log('⏳ Connection attempt $attempts/$maxAttempts...');
        }
      }

      if (connectionEstablished) {
        _isConnected = true;
        onConnectionEstablished?.call('Connected to Pusher WebSocket');
        log('✅ Pusher WebSocket service initialized successfully');
      } else {
        // Instead of throwing, we'll try to reconnect silently
        log('⚠️ Initial connection failed, will retry silently');
        _isConnected = false;
        // Don't call onConnectionError - we'll handle this silently
      }
    } catch (e) {
      log('⚠️ Error during initialization: $e');
      _isConnected = false;
      // Don't call onConnectionError - we'll handle this silently
    }
  }

  /// Subscribe to a private chat channel
  Future<void> subscribeToChatChannel(int userId) async {
    try {
      if (_channel == null) {
        log('🔄 WebSocket channel is null, initializing...');
        await initialize();
      }

      // Ensure we have a stable connection before subscribing
      if (!_isConnected) {
        log('⏳ Ensuring stable connection before subscription...');
        int retryCount = 0;
        const maxRetries = 8; // Increased retries

        while (!_isConnected && retryCount < maxRetries) {
          await Future.delayed(Duration(milliseconds: 600));
          retryCount++;
          log('⏳ Connection check attempt $retryCount/$maxRetries');

          // Try to reconnect if still not connected
          if (!_isConnected && retryCount > 3) {
            log('🔄 Attempting silent reconnection...');
            await initialize();
          }
        }

        if (!_isConnected) {
          // Instead of throwing, we'll try one more time
          log('⚠️ Still not connected, final attempt...');
          await Future.delayed(Duration(milliseconds: 1000));
          await initialize();

          if (!_isConnected) {
            throw Exception('Failed to establish stable connection');
          }
        }
      }

      final channelName = 'private-chat.$userId';
      _currentChannelName = channelName;

      // Send subscription message
      final subscribeMessage = {
        'event': 'pusher:subscribe',
        'data': {
          'auth': '', // For private channels, you might need auth
          'channel': channelName
        }
      };

      log('🔗 Subscribing to channel: $channelName');
      _channel!.sink.add(jsonEncode(subscribeMessage));

      // Wait a moment to ensure subscription is processed
      await Future.delayed(Duration(milliseconds: 300));

      log('✅ Successfully subscribed to chat channel: $channelName');
    } catch (e) {
      log('❌ Error subscribing to chat channel: $e');
      rethrow;
    }
  }

  /// Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic message) {
    try {
      log('📨 Received WebSocket message: $message');

      if (message is String) {
        final data = jsonDecode(message);
        log('📋 Parsed message data: $data');

        // Handle Pusher events
        if (data['event'] == 'App\\Events\\MessageSent') {
          log('✅ Received MessageSent event');
          final messageData = data['data'];

          if (messageData is String) {
            // Sometimes data is a JSON string
            log('📝 Message data is string, parsing JSON...');
            final parsedData = jsonDecode(messageData);
            if (parsedData is Map<String, dynamic>) {
              log('📋 Parsed message content: $parsedData');
              final pusherMessage = PusherMessageModel.fromJson(parsedData);
              log('✅ Successfully created PusherMessage: ${pusherMessage.body}');
              onMessageReceived?.call(pusherMessage);
            }
          } else if (messageData is Map<String, dynamic>) {
            log('📋 Message data is map: $messageData');
            final pusherMessage = PusherMessageModel.fromJson(messageData);
            log('✅ Successfully created PusherMessage: ${pusherMessage.body}');
            onMessageReceived?.call(pusherMessage);
          } else {
            log('⚠️ Unexpected message data type: ${messageData.runtimeType}');
          }
        } else {
          log('ℹ️ Received other event: ${data['event']}');
        }
      } else {
        log('⚠️ Received non-string message: ${message.runtimeType}');
      }
    } catch (e) {
      log('❌ Error handling WebSocket message: $e');
    }
  }

  /// Unsubscribe from the current chat channel
  void unsubscribeFromChatChannel() {
    try {
      if (_currentChannelName != null && _channel != null) {
        final unsubscribeMessage = {
          'event': 'pusher:unsubscribe',
          'data': {'channel': _currentChannelName}
        };

        _channel!.sink.add(jsonEncode(unsubscribeMessage));
        _currentChannelName = null;
        log('Unsubscribed from chat channel');
      }
    } catch (e) {
      log('Error unsubscribing from chat channel: $e');
    }
  }

  /// Disconnect from WebSocket
  void disconnect() {
    try {
      unsubscribeFromChatChannel();
      _channel?.sink.close(status.goingAway);
      _channel = null;
      _isConnected = false;
      log('Disconnected from Pusher WebSocket');
    } catch (e) {
      log('Error disconnecting from Pusher WebSocket: $e');
    }
  }

  /// Check if connected to WebSocket
  bool get isConnected => _isConnected;

  /// Get the current channel name
  String? get currentChannelName => _currentChannelName;

  /// Check connection health and reconnect if needed
  Future<bool> checkConnectionHealth() async {
    try {
      if (_channel == null || !_isConnected) {
        log('🔄 Connection unhealthy, attempting to reconnect...');
        await initialize();
        return _isConnected;
      }

      // Test connection with a ping
      try {
        _channel!.sink.add(jsonEncode({'event': 'pusher:ping'}));
        return true;
      } catch (e) {
        log('⚠️ Connection test failed, reconnecting...');
        await initialize();
        return _isConnected;
      }
    } catch (e) {
      log('❌ Connection health check failed: $e');
      return false;
    }
  }
}
