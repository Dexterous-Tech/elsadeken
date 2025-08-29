import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';

/// Pusher Configuration
class PusherConfig {
  static const String appId = '1893366';
  static const String appKey = '488b28cd543c3e616398';
  static const String appSecret = 'bb14accaa8c913fd988f';
  static const String cluster = 'eu';
  static const int port = 443;
  static const bool encrypted = true;
}

/// Service for managing WebSocket connection with Pusher
class PusherService {
  static PusherService? _instance;
  static PusherService get instance => _instance ??= PusherService._internal();

  PusherService._internal();

  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isConnecting = false;
  String? _currentChannelName;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;

  // Callbacks
  Function(PusherMessageModel)? onMessageReceived;
  Function(String)? onConnectionEstablished;
  Function(String)? onConnectionError;

  /// Connectivity check
  Future<bool> _hasInternetConnection() async {
    try {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 3);
      final request =
          await client.getUrl(Uri.parse('https://httpbin.org/status/200'));
      final response = await request.close();
      client.close();
      return response.statusCode == 200;
    } catch (_) {
      return true; // fallback, let Pusher handle actual connection
    }
  }

  /// Initialize WebSocket connection
  Future<void> initialize() async {
    // Prevent multiple simultaneous connection attempts
    if (_isConnecting || _isConnected) {
      log('⚠️ Connection already in progress or established');
      return;
    }

    try {
      _isConnecting = true;

      if (!await _hasInternetConnection()) {
        log('⚠️ No internet connection');
        _isConnected = false;
        _isConnecting = false;
        onConnectionError?.call('No internet connection available');
        return;
      }

      // Close any existing connection first
      if (_channel != null) {
        try {
          _channel!.sink.close();
          _channel = null;
        } catch (e) {
          log('⚠️ Error closing existing connection: $e');
        }
      }

      // Try eu cluster first (as requested), then fallback options if it fails
      final clusterOptions = [
        'eu', // Primary - your preferred cluster
        'us-east-1', // Fallback if eu fails
        'ap1', // Asia Pacific fallback
        'ap2', // Asia Pacific 2 fallback
      ];

      bool connectionSuccessful = false;
      String lastError = '';

      for (final cluster in clusterOptions) {
        if (connectionSuccessful) break;

        try {
          final wsUrl =
              'wss://ws-$cluster.pusherapp.com/app/${PusherConfig.appKey}?protocol=7&client=dart&version=1.0&flash=false';
          log('🔄 Attempting connection to: $wsUrl');

          // Create the WebSocket connection with error handling
          try {
            _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
          } catch (e) {
            log('⚠️ Failed to create WebSocket connection to $cluster: $e');
            lastError = e.toString();
            continue; // Try next cluster
          }

          // Wait for connection to establish with timeout
          bool connectionEstablished = false;

          try {
            await Future.delayed(Duration(milliseconds: 3000));

            // Check if connection is established and working
            if (_channel != null && _channel!.sink != null) {
              // Test the connection by sending a ping
              try {
                _channel!.sink.add(jsonEncode({'event': 'pusher:ping'}));
                connectionEstablished = true;
                connectionSuccessful = true;
                _isConnected = true;
                _isConnecting = false;
                _reconnectAttempts = 0; // Reset reconnect attempts on success

                onConnectionEstablished
                    ?.call('Connected to Pusher via $cluster cluster');
                log('✅ Pusher WebSocket service initialized successfully via $cluster cluster');
                break;
              } catch (pingError) {
                log('⚠️ Connection test failed for $cluster: $pingError');
                // Close failed connection and try next cluster
                try {
                  _channel!.sink.close();
                  _channel = null;
                } catch (closeError) {
                  log('⚠️ Error closing failed connection: $closeError');
                }
                continue;
              }
            }
          } catch (e) {
            lastError = e.toString();
            log('⚠️ Connection timeout or error for $cluster cluster: $e');

            // Close failed connection
            if (_channel != null) {
              try {
                _channel!.sink.close();
                _channel = null;
              } catch (closeError) {
                log('⚠️ Error closing failed connection: $closeError');
              }
            }
          }

          // Wait before trying next cluster
          await Future.delayed(Duration(milliseconds: 1000));
        } catch (e) {
          lastError = e.toString();
          log('⚠️ Failed to connect to $cluster cluster: $e');

          // Close any existing connection before trying next
          if (_channel != null) {
            try {
              _channel!.sink.close();
              _channel = null;
            } catch (closeError) {
              log('⚠️ Error closing connection: $closeError');
            }
          }

          // Wait before trying next cluster
          await Future.delayed(Duration(milliseconds: 1000));
        }
      }

      if (!connectionSuccessful) {
        log('❌ Failed to connect to any Pusher cluster');
        _isConnected = false;
        _isConnecting = false;
        onConnectionError
            ?.call('Unable to connect to any Pusher cluster: $lastError');

        // Schedule reconnection attempt
        _scheduleReconnection();
        return;
      }

      // Set up message handling
      _channel!.stream.listen(
        (message) => _handleWebSocketMessage(message),
        onDone: () {
          log('❌ WebSocket closed');
          _isConnected = false;
          _isConnecting = false;
          _scheduleReconnection();
        },
        onError: (error) {
          log('❌ WebSocket error: $error');
          _isConnected = false;
          _isConnecting = false;
          onConnectionError?.call(error.toString());
          _scheduleReconnection();
        },
        cancelOnError: false, // Don't cancel on error, let us handle it
      );
    } catch (e) {
      log('⚠️ Initialization error: $e');
      _isConnected = false;
      _isConnecting = false;
      onConnectionError?.call('Initialization failed: $e');
      _scheduleReconnection();
    }
  }

  /// Schedule reconnection attempt
  void _scheduleReconnection() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log('⚠️ Max reconnection attempts reached');
      return;
    }

    if (_reconnectTimer != null) {
      _reconnectTimer!.cancel();
    }

    _reconnectAttempts++;
    final delay =
        Duration(seconds: _reconnectAttempts * 2); // Exponential backoff

    log('🔄 Scheduling reconnection attempt $_reconnectAttempts in ${delay.inSeconds} seconds');

    _reconnectTimer = Timer(delay, () {
      if (!_isConnected && !_isConnecting) {
        log('🔄 Attempting reconnection...');
        initialize();
      }
    });
  }

  /// Check connection health and reconnect if needed
  Future<bool> checkConnectionHealth() async {
    try {
      if (_channel == null || !_isConnected) {
        log('🔄 Connection unhealthy, reconnecting...');
        await initialize();
        return _isConnected;
      }

      // Check if the sink is still valid
      if (_channel!.sink == null) {
        log('⚠️ WebSocket sink is null, reconnecting...');
        await initialize();
        return _isConnected;
      }

      // Try a ping
      try {
        _channel!.sink.add(jsonEncode({'event': 'pusher:ping'}));
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

  /// Subscribe to a private chat channel
  Future<void> subscribeToChatChannel(int chatRoomId) async {
    if (_channel == null || !_isConnected) {
      log('⚠️ No active connection, initializing first...');
      await initialize();

      // Wait a bit for connection to establish
      if (!_isConnected) {
        log('⚠️ Still no connection after initialization');
        return;
      }
    }

    final channelName = 'private-chat.$chatRoomId';
    _currentChannelName = channelName;

    final subscribeMessage = {
      'event': 'pusher:subscribe',
      'data': {
        'auth': '', // TODO: add backend auth if required
        'channel': channelName,
      }
    };

    log('🔗 Subscribing to $channelName');
    try {
      _channel!.sink.add(jsonEncode(subscribeMessage));
    } catch (e) {
      log('❌ Error sending subscription message: $e');
      onConnectionError?.call('Subscription failed: $e');
    }
  }

  /// Handle incoming messages
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
      // Your backend wraps the actual payload inside `message`
      final messageJson = json['message'] as Map<String, dynamic>;
      final pusherMessage = PusherMessageModel.fromJson(messageJson);
      log('✅ Parsed PusherMessage: ${pusherMessage.body}');
      onMessageReceived?.call(pusherMessage);
    } catch (e) {
      log('⚠️ Failed to parse PusherMessage: $e');
    }
  }

  /// Unsubscribe
  void unsubscribeFromChatChannel() {
    if (_currentChannelName == null || _channel == null) return;

    final unsubscribeMessage = {
      'event': 'pusher:unsubscribe',
      'data': {'channel': _currentChannelName}
    };

    _channel!.sink.add(jsonEncode(unsubscribeMessage));
    log('🚪 Unsubscribed from $_currentChannelName');
    _currentChannelName = null;
  }

  /// Disconnect
  void disconnect() {
    unsubscribeFromChatChannel();
    _channel?.sink.close(status.goingAway);
    _channel = null;
    _isConnected = false;
    _isConnecting = false;
    log('🔌 Disconnected');
  }

  bool get isConnected => _isConnected;
  String? get currentChannelName => _currentChannelName;
}
