import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/errors/failures.dart';
import 'package:elsadeken/features/chat/data/services/pusher_service.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:elsadeken/features/chat/domain/repositories/pusher_repo_interface.dart';

class PusherRepoImpl implements PusherRepoInterface {
  final PusherService _pusherService;

  PusherRepoImpl(this._pusherService);

  @override
  Future<Either<Failure, void>> initialize() async {
    try {
      await _pusherService.initialize();

      // Wait a bit to ensure connection is established
      await Future.delayed(Duration(milliseconds: 500));

      if (_pusherService.isConnected) {
        return const Right(null);
      } else {
        return Left(
          ServerFailure(message: 'Failed to establish Pusher connection'),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Pusher initialization failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToChatChannel(
    int chatRoomId,
    String bearerToken,
  ) async {
    try {
      // Ensure we're connected before subscribing
      if (!_pusherService.isConnected) {
        final initResult = await initialize();
        if (initResult.isLeft()) {
          return initResult;
        }
      }

      await _pusherService.subscribeToChatChannel(chatRoomId, bearerToken);

      // Give some time for subscription to complete
      await Future.delayed(Duration(milliseconds: 1000));

      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to subscribe to chat channel: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromChatChannel() async {
    try {
      _pusherService.unsubscribeFromChatChannel();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to unsubscribe: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      _pusherService.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to disconnect: $e'));
    }
  }

  @override
  void setMessageCallback(Function(PusherMessageModel) callback) {
    _pusherService.onMessageReceived = (message) {
      callback(message);
    };
  }

  @override
  void setConnectionCallback(Function(String) callback) {
    _pusherService.onConnectionEstablished = (message) {
      callback(message);
    };
  }

  @override
  void setErrorCallback(Function(String) callback) {
    _pusherService.onConnectionError = (error) {
      callback(error);
    };
  }

  @override
  void setAuthToken(String token) {
    _pusherService.setAuthToken(token);
  }

  @override
  bool get isConnected {
    final connected = _pusherService.isConnected;

    return connected;
  }

  @override
  Future<bool> checkConnectionHealth() async {
    try {
      final isHealthy = await _pusherService.checkConnectionHealth();

      return isHealthy;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getDetailedDiagnostics() async {
    try {
      // Use existing getConnectionStatus method instead
      final basicStatus = _pusherService.getConnectionStatus();

      // Add additional diagnostic information manually
      final diagnostics = <String, dynamic>{
        ...basicStatus,
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'PusherRepoImpl',
        'currentChannelName': _pusherService.currentChannelName,
      };

      return diagnostics;
    } catch (e) {
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'PusherRepoImpl',
      };
    }
  }

  /// Test message handling (for debugging)
  @override
  void testMessageHandling() {
    try {
      _pusherService.testMessageHandling();
    } catch (e) {
      //
    }
  }

  /// Test full message pipeline (for debugging)
  @override
  void testFullMessagePipeline() {
    try {
      _pusherService.testFullMessagePipeline();
    } catch (e) {
      //
    }
  }

  /// Force reconnection (useful for debugging connection issues)
  @override
  Future<Either<Failure, void>> forceReconnect() async {
    try {
      await _pusherService.forceReconnect();

      if (_pusherService.isConnected) {
        return const Right(null);
      } else {
        return Left(ServerFailure(message: 'Force reconnection failed'));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Force reconnection failed: $e'));
    }
  }

  /// Get current connection status with detailed information
  @override
  Map<String, dynamic> getConnectionStatus() {
    try {
      final status = _pusherService.getConnectionStatus();

      return status;
    } catch (e) {
      return {
        'error': e.toString(),
        'isConnected': false,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Simulate message reception for testing
  @override
  void simulateMessage(int chatId, String messageBody) {
    try {
      _pusherService.simulateMessageReceived(messageBody, chatId);
    } catch (e) {
      //
    }
  }
}
