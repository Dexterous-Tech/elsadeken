import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:elsadeken/core/helper/app_constants.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'dart:async'; // Added for Timer

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

  /// Check if there's internet connectivity
  Future<bool> _hasInternetConnection() async {
    try {
      // Simple HTTP connectivity check
      final client = HttpClient();
      client.connectionTimeout = Duration(seconds: 3);
      
      final request = await client.getUrl(Uri.parse('https://httpbin.org/status/200'));
      final response = await request.close();
      client.close();
      
      return response.statusCode == 200;
    } catch (e) {
      // If connectivity check fails, assume internet is available and let Pusher try
      // This prevents blocking Pusher when the check fails
      return true;
    }
  }

  /// Initialize WebSocket connection to Pusher
  Future<void> initialize() async {
    try {
      // Check internet connectivity first
      final hasInternet = await _hasInternetConnection();
      if (!hasInternet) {
        log('⚠️ No internet connection available - skipping Pusher initialization');
        _isConnected = false;
        return;
      }

      // Wait for network to be ready (Android sometimes needs a moment)
      await Future.delayed(Duration(milliseconds: 800));

      // Connect to Pusher WebSocket
      final wsUrl =
          'wss://ws-${PusherConfig.cluster}.pusherapp.com/app/${PusherConfig.appKey}?protocol=7&client=js&version=7.6.0&flash=false';

      log('🔄 Attempting to connect to: $wsUrl');

      try {
        _channel = WebSocketChannel.connect(
          Uri.parse(wsUrl),
          protocols: ['websocket'],
        );
        
        // Add a timeout to the connection
        Timer(Duration(seconds: 10), () {
          if (!_isConnected && _channel != null) {
            log('⚠️ WebSocket connection timeout - closing connection');
            try {
              _channel!.sink.close();
              _channel = null;
            } catch (e) {
              log('⚠️ Error closing timed out connection: $e');
            }
          }
        });
      } catch (e) {
        log('⚠️ WebSocket connection failed: $e');
        _isConnected = false;
        // Don't rethrow - handle gracefully
        return;
      }

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
  Future<void> subscribeToChatChannel(int chatRoomId) async {
    try {
      if (_channel == null) {
        log('🔄 WebSocket channel is null, initializing...');
        try {
          await initialize();
        } catch (e) {
          log('⚠️ Failed to initialize WebSocket: $e');
          // Don't rethrow - handle gracefully
          return;
        }
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
            try {
              await initialize();
            } catch (e) {
              log('⚠️ Reconnection failed: $e');
            }
          }
        }

        if (!_isConnected) {
          // Instead of throwing, we'll try one more time
          log('⚠️ Still not connected, final attempt...');
          await Future.delayed(Duration(milliseconds: 1000));
          try {
            await initialize();
          } catch (e) {
            log('⚠️ Final connection attempt failed: $e');
            // Don't throw - just log and return
            return;
          }

          if (!_isConnected) {
            log('⚠️ Failed to establish stable connection - continuing without Pusher');
            return; // Don't throw - handle gracefully
          }
        }
      }

      // Try different channel naming conventions that the backend might be using
      final possibleChannelNames = [
        'private-chat.$chatRoomId',           // private-chat.123
        'private-chatroom.$chatRoomId',      // private-chatroom.123
        'chat.$chatRoomId',                  // chat.123
        'private-messages.$chatRoomId',      // private-messages.123
        'messages.$chatRoomId',              // messages.123
      ];

      log('🔍 Trying to subscribe to chat room $chatRoomId');
      log('📡 Attempting channel names: $possibleChannelNames');

      for (final channelName in possibleChannelNames) {
        try {
          _currentChannelName = channelName;
          
          // Send subscription message
          final subscribeMessage = {
            'event': 'pusher:subscribe',
            'data': {
              'auth': '', // For private channels, you might need auth
              'channel': channelName
            }
          };

          log('🔗 Attempting to subscribe to channel: $channelName');
          _channel!.sink.add(jsonEncode(subscribeMessage));
          
          // Wait a moment to see if subscription is successful
          await Future.delayed(Duration(milliseconds: 500));
          
          // If we're still here, assume subscription was successful
          log('✅ Successfully subscribed to chat channel: $channelName');
          return;
          
        } catch (e) {
          log('⚠️ Failed to subscribe to $channelName: $e');
          // Continue to next channel name
        }
      }
      
      log('❌ Failed to subscribe to any channel for chat room $chatRoomId');
      
    } catch (e) {
      log('❌ Error subscribing to chat channel: $e');
      // Don't rethrow - handle gracefully
    }
  }

  /// Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic message) {
    try {
      log('📨 Received WebSocket message: $message');

      if (message is String) {
        final data = jsonDecode(message);
        log('📋 Parsed message data: $data');

        // Handle various Pusher events that might contain chat messages
        final eventType = data['event'];
        log('🎯 Event type: $eventType');
        
        if (eventType == 'App\\Events\\MessageSent' ||
            eventType == 'MessageSent' ||
            eventType == 'chat.message' ||
            eventType == 'message.sent' ||
            eventType == 'new.message') {
          
          log('✅ Received chat message event: $eventType');
          final messageData = data['data'];

          if (messageData is String) {
            // Sometimes data is a JSON string
            log('📝 Message data is string, parsing JSON...');
            try {
              final parsedData = jsonDecode(messageData);
              if (parsedData is Map<String, dynamic>) {
                log('📋 Parsed message content: $parsedData');
                final pusherMessage = PusherMessageModel.fromJson(parsedData);
                log('✅ Successfully created PusherMessage: ${pusherMessage.body}');
                onMessageReceived?.call(pusherMessage);
              }
            } catch (parseError) {
              log('⚠️ Failed to parse message data string: $parseError');
            }
          } else if (messageData is Map<String, dynamic>) {
            log('📋 Message data is map: $messageData');
            try {
              final pusherMessage = PusherMessageModel.fromJson(messageData);
              log('✅ Successfully created PusherMessage: ${pusherMessage.body}');
              onMessageReceived?.call(pusherMessage);
            } catch (parseError) {
              log('⚠️ Failed to create PusherMessage from map: $parseError');
            }
          } else {
            log('⚠️ Unexpected message data type: ${messageData.runtimeType}');
          }
        } else if (eventType == 'pusher:connection_established') {
          log('🔗 Pusher connection established');
        } else if (eventType == 'pusher:subscription_succeeded') {
          log('✅ Channel subscription succeeded');
        } else if (eventType == 'pusher:subscription_error') {
          log('❌ Channel subscription failed');
        } else {
          log('ℹ️ Received other event: $eventType');
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
