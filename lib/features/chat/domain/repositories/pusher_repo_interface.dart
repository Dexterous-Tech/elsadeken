import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/errors/failures.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';

abstract class PusherRepoInterface {
  /// Initialize Pusher connection
  Future<Either<Failure, void>> initialize();
  
  /// Subscribe to a chat channel for a specific user
  Future<Either<Failure, void>> subscribeToChatChannel(int userId);
  
  /// Unsubscribe from the current chat channel
  Future<Either<Failure, void>> unsubscribeFromChatChannel();
  
  /// Disconnect from Pusher
  Future<Either<Failure, void>> disconnect();
  
  /// Set callback for when new messages are received
  void setMessageCallback(Function(PusherMessageModel) callback);
  
  /// Set callback for connection status
  void setConnectionCallback(Function(String) callback);
  
  /// Set callback for connection errors
  void setErrorCallback(Function(String) callback);
  
  /// Set authentication token for private channels
  void setAuthToken(String token);
  
  /// Check if connected to Pusher
  bool get isConnected;
  
  /// Check connection health and reconnect if needed
  Future<bool> checkConnectionHealth();
}
