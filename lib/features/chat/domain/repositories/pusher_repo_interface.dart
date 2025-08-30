import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/errors/failures.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';

abstract class PusherRepoInterface {
  /// Initialize Pusher connection
  Future<Either<Failure, void>> initialize();

  /// Subscribe to a chat channel (room) with token-based authentication
  Future<Either<Failure, void>> subscribeToChatChannel(int chatRoomId, String bearerToken);

  /// Unsubscribe from the current chat channel
  Future<Either<Failure, void>> unsubscribeFromChatChannel();

  /// Disconnect from Pusher
  Future<Either<Failure, void>> disconnect();

  /// Set callback for when new messages are received
  void setMessageCallback(Function(PusherMessageModel) callback);

  /// Set callback for connection state changes (previous → current)
  void setConnectionCallback(Function(String) callback);

  /// Set callback for connection errors
  void setErrorCallback(Function(String) callback);

  /// Set authentication token for private channels
  void setAuthToken(String token);

  /// Check if connected to Pusher
  bool get isConnected;

  /// Check connection health and reconnect if needed
  Future<bool> checkConnectionHealth();

  /// Get detailed diagnostics for debugging network and connection issues
  Future<Map<String, dynamic>> getDetailedDiagnostics();

  /// Test message handling (for debugging)
  void testMessageHandling();

  /// Test full message pipeline (for debugging)
  void testFullMessagePipeline();

  /// Force reconnect with optional backoff
  Future<Either<Failure, void>> forceReconnect();

  /// Get current connection status snapshot
  Map<String, dynamic> getConnectionStatus();

  /// Simulate a message received (for testing without Pusher)
  void simulateMessage(int chatId, String messageBody);
}
