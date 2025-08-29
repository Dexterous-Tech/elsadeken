import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/errors/failures.dart';
import 'package:elsadeken/features/chat/data/services/pusher_service.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:elsadeken/features/chat/domain/repositories/pusher_repo_interface.dart';
import 'dart:developer';

class PusherRepoImpl implements PusherRepoInterface {
  final PusherService _pusherService;

  PusherRepoImpl(this._pusherService);

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      log('[PusherRepo] Initializing Pusher service...');
      await _pusherService.initialize();

      // Wait a bit to ensure connection is established
      await Future.delayed(Duration(milliseconds: 500));

      if (_pusherService.isConnected) {
        log('[PusherRepo] Pusher initialization successful');
        return const Right(null);
      } else {
        log('[PusherRepo] Pusher initialization failed - not connected');
        return Left(ServerFailure(message: 'Failed to establish Pusher connection'));
      }
    } catch (e) {
      log('[PusherRepo] Pusher initialization error: $e');
      return Left(ServerFailure(message: 'Pusher initialization failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToChatChannel(int chatRoomId, String bearerToken) async {
    try {
      log('[PusherRepo] Subscribing to chat channel: $chatRoomId');

      // Ensure we're connected before subscribing
      if (!_pusherService.isConnected) {
        log('[PusherRepo] Not connected, initializing first...');
        final initResult = await initialize();
        if (initResult.isLeft()) {
          return initResult;
        }
      }

      await _pusherService.subscribeToChatChannel(chatRoomId, bearerToken);

      // Give some time for subscription to complete
      await Future.delayed(Duration(milliseconds: 1000));

      log('[PusherRepo] Chat channel subscription completed');
      return const Right(null);
    } catch (e) {
      log('[PusherRepo] Chat channel subscription error: $e');
      return Left(ServerFailure(message: 'Failed to subscribe to chat channel: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromChatChannel() async {
    try {
      log('[PusherRepo] Unsubscribing from chat channel...');
      _pusherService.unsubscribeFromChatChannel();
      return const Right(null);
    } catch (e) {
      log('[PusherRepo] Unsubscribe error: $e');
      return Left(ServerFailure(message: 'Failed to unsubscribe: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      log('[PusherRepo] Disconnecting from Pusher...');
      _pusherService.disconnect();
      return const Right(null);
    } catch (e) {
      log('[PusherRepo] Disconnect error: $e');
      return Left(ServerFailure(message: 'Failed to disconnect: $e'));
    }
  }

  @override
  void setMessageCallback(Function(PusherMessageModel) callback) {
    log('[PusherRepo] Setting message callback');
    _pusherService.onMessageReceived = (message) {
      log('[PusherRepo] Message callback triggered: ${message.body}');
      callback(message);
    };
  }

  @override
  void setConnectionCallback(Function(String) callback) {
    log('[PusherRepo] Setting connection callback');
    _pusherService.onConnectionEstablished = (message) {
      log('[PusherRepo] Connection callback triggered: $message');
      callback(message);
    };
  }

  @override
  void setErrorCallback(Function(String) callback) {
    log('[PusherRepo] Setting error callback');
    _pusherService.onConnectionError = (error) {
      log('[PusherRepo] Error callback triggered: $error');
      callback(error);
    };
  }

  @override
  void setAuthToken(String token) {
    log('[PusherRepo] Setting auth token');
    _pusherService.setAuthToken(token);
  }

  @override
  bool get isConnected {
    final connected = _pusherService.isConnected;
    log('[PusherRepo] Connection status requested: $connected');
    return connected;
  }

  @override
  Future<bool> checkConnectionHealth() async {
    try {
      log('[PusherRepo] Checking connection health...');
      final isHealthy = await _pusherService.checkConnectionHealth();
      log('[PusherRepo] Connection health result: $isHealthy');
      return isHealthy;
    } catch (e) {
      log('[PusherRepo] Connection health check failed: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getDetailedDiagnostics() async {
    try {
      log('[PusherRepo] Getting detailed diagnostics...');

      // Use existing getConnectionStatus method instead
      final basicStatus = _pusherService.getConnectionStatus();

      // Add additional diagnostic information manually
      final diagnostics = <String, dynamic>{
        ...basicStatus,
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'PusherRepoImpl',
        'currentChannelName': _pusherService.currentChannelName,
      };

      log('[PusherRepo] Diagnostics retrieved: $diagnostics');
      return diagnostics;
    } catch (e) {
      log('[PusherRepo] Failed to get detailed diagnostics: $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'PusherRepoImpl'
      };
    }
  }

  /// Test message handling (for debugging)
  void testMessageHandling() {
    log('[PusherRepo] Testing message handling...');
    try {
      _pusherService.testMessageHandling();
      log('[PusherRepo] Message handling test completed');
    } catch (e) {
      log('[PusherRepo] Message handling test failed: $e');
    }
  }

  /// Test full message pipeline (for debugging)
  void testFullMessagePipeline() {
    log('[PusherRepo] Testing full message pipeline...');
    try {
      _pusherService.testFullMessagePipeline();
      log('[PusherRepo] Message pipeline test completed');
    } catch (e) {
      log('[PusherRepo] Message pipeline test failed: $e');
    }
  }

  /// Force reconnection (useful for debugging connection issues)
  Future<Either<Failure, void>> forceReconnect() async {
    try {
      log('[PusherRepo] Force reconnecting...');
      await _pusherService.forceReconnect();

      if (_pusherService.isConnected) {
        log('[PusherRepo] Force reconnection successful');
        return const Right(null);
      } else {
        log('[PusherRepo] Force reconnection failed - not connected');
        return Left(ServerFailure(message: 'Force reconnection failed'));
      }
    } catch (e) {
      log('[PusherRepo] Force reconnection error: $e');
      return Left(ServerFailure(message: 'Force reconnection failed: $e'));
    }
  }

  /// Get current connection status with detailed information
  Map<String, dynamic> getConnectionStatus() {
    try {
      final status = _pusherService.getConnectionStatus();
      log('[PusherRepo] Connection status: $status');
      return status;
    } catch (e) {
      log('[PusherRepo] Failed to get connection status: $e');
      return {
        'error': e.toString(),
        'isConnected': false,
        'timestamp': DateTime.now().toIso8601String()
      };
    }
  }

  /// Simulate message reception for testing
  void simulateMessage(int chatId, String messageBody) {
    log('[PusherRepo] Simulating message for testing...');
    try {
      _pusherService.simulateMessageReceived(messageBody, chatId);
      log('[PusherRepo] Message simulation completed');
    } catch (e) {
      log('[PusherRepo] Message simulation failed: $e');
    }
  }
}