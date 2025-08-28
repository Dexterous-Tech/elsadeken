import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

/// Pusher Configuration
class PusherConfig {
  static const String appId = '1893366';
  static const String appKey = '488b28cd543c3e616398';
  static const String appSecret = 'bb14accaa8c913fd988f';
  static const String cluster = 'eu';
  static const int port = 443;
  static const bool encrypted = true;
}

/// Service for managing Pusher connection using the official Flutter package
class PusherService {
  static PusherService? _instance;
  static PusherService get instance => _instance ??= PusherService._internal();

  PusherService._internal();

  PusherChannelsFlutter? _pusher;
  bool _isConnected = false;
  String? _currentChannelName;

  // Callbacks
  Function(PusherMessageModel)? onMessageReceived;
  Function(String)? onConnectionEstablished;
  Function(String)? onConnectionError;

  /// Initialize Pusher connection using the Flutter package
  Future<void> initialize() async {
    try {
      log('🔄 Initializing Pusher with Flutter package...');

      // Initialize Pusher
      _pusher = PusherChannelsFlutter.getInstance();

      await _pusher!.init(
        apiKey: PusherConfig.appKey,
        cluster: PusherConfig.cluster,
        onConnectionStateChange: (previousState, currentState) {
          log('Connection state: $currentState');
          if (currentState == 'CONNECTED') {
            _isConnected = true;
            onConnectionEstablished?.call('Connected to Pusher');
            log('✅ Pusher connected successfully');
          } else if (currentState == 'DISCONNECTED') {
            _isConnected = false;
          }
        },
        onError: (error, code, data) {
          log('Pusher error: $error');
          _isConnected = false;
          onConnectionError?.call('Pusher error: $error');
        },
      );

      // Connect to Pusher
      await _pusher!.connect();
      log('✅ Pusher initialization completed');
    } catch (e) {
      log('⚠️ Initialization error: $e');
      _isConnected = false;
      onConnectionError?.call('Initialization failed: $e');
    }
  }

  /// Subscribe to a private chat channel
  Future<void> subscribeToChatChannel(int chatRoomId) async {
    if (_pusher == null) {
      await initialize();
    }
    if (_pusher == null) return;

    final channelName = 'private-chat.$chatRoomId';
    _currentChannelName = channelName;

    log('🔗 Subscribing to $channelName');

    try {
      await _pusher!.subscribe(
        channelName: channelName,
        onEvent: (event) {
          log('📨 Event received: ${event.eventName} - ${event.data}');
          _handlePusherEvent(event);
        },
      );

      log('✅ Successfully subscribed to $channelName');
    } catch (e) {
      log('❌ Failed to subscribe to $channelName: $e');
      onConnectionError?.call('Subscription failed: $e');
    }
  }

  /// Handle incoming Pusher events
  void _handlePusherEvent(PusherEvent event) {
    try {
      if (event.eventName == 'App\\Events\\MessageSent') {
        log('💬 Message event received');

        // Parse the event data
        final eventData = jsonDecode(event.data);
        final messageData = eventData['message'] ?? eventData;

        if (messageData is Map<String, dynamic>) {
          final pusherMessage = PusherMessageModel.fromJson(messageData);
          log('✅ Parsed PusherMessage: ${pusherMessage.body}');
          onMessageReceived?.call(pusherMessage);
        }
      } else {
        log('ℹ️ Other event: ${event.eventName}');
      }
    } catch (e) {
      log('❌ Error handling Pusher event: $e');
    }
  }

  /// Unsubscribe from the current chat channel
  void unsubscribeFromChatChannel() {
    if (_currentChannelName == null || _pusher == null) return;

    try {
      _pusher!.unsubscribe(channelName: _currentChannelName!);
      log('🚪 Unsubscribed from $_currentChannelName');
      _currentChannelName = null;
    } catch (e) {
      log('❌ Error unsubscribing: $e');
    }
  }

  /// Disconnect from Pusher
  void disconnect() {
    try {
      unsubscribeFromChatChannel();
      _pusher?.disconnect();
      _pusher = null;
      _isConnected = false;
      log('🔌 Disconnected from Pusher');
    } catch (e) {
      log('❌ Error disconnecting: $e');
    }
  }

  bool get isConnected => _isConnected;
  String? get currentChannelName => _currentChannelName;

  /// Check connection health and attempt to reconnect if needed
  Future<bool> checkConnectionHealth() async {
    try {
      // Check if we have a valid pusher instance
      if (_pusher == null) {
        log('⚠️ Pusher instance is null, attempting to reinitialize...');
        await initialize();
        return _isConnected;
      }

      // Check if we're connected
      if (_isConnected) {
        log('✅ Connection is healthy');
        return true;
      }

      // If not connected, try to reconnect
      log('🔄 Connection lost, attempting to reconnect...');
      await initialize();

      // If we have a channel to subscribe to, resubscribe
      if (_currentChannelName != null) {
        final channelId = _currentChannelName!.split('.').last;
        if (channelId.isNotEmpty) {
          await subscribeToChatChannel(int.tryParse(channelId) ?? 0);
        }
      }

      return _isConnected;
    } catch (e) {
      log('❌ Connection health check failed: $e');
      return false;
    }
  }
}
