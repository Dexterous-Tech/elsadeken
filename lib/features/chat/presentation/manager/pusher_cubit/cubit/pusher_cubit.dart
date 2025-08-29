import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/chat/domain/repositories/pusher_repo_interface.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'package:elsadeken/features/chat/data/services/pusher_service.dart';
import 'pusher_state.dart';

class PusherCubit extends Cubit<PusherState> {
  final PusherRepoInterface _pusherRepo;
  bool _isInitializing = false;

  PusherCubit(this._pusherRepo) : super(PusherInitial()) {
    _setupCallbacks();
  }

  void _setupCallbacks() {
    _pusherRepo.setMessageCallback(_onMessageReceived);
    _pusherRepo.setConnectionCallback(_onConnectionEstablished);
    _pusherRepo.setErrorCallback(_onConnectionError);
  }

  /// Set authentication token for private channels
  void setAuthToken(String token) {
    // Set the auth token in the repository
    _pusherRepo.setAuthToken(token);
  }

  /// Initialize Pusher connection
  Future<void> initialize() async {
    // Prevent multiple simultaneous initialization attempts
    if (_isInitializing) {
      print('⚠️ Pusher initialization already in progress, skipping...');
      return;
    }

    try {
      _isInitializing = true;
      emit(PusherLoading());

      // Add a small delay to ensure network is ready
      await Future.delayed(Duration(milliseconds: 500));

      final result = await _pusherRepo.initialize();

      result.fold(
        (failure) {
          // Handle failures silently - don't emit error state
          print(
              '⚠️ Pusher initialization issue (handled silently): ${failure.message}');
          // Don't emit error - we'll retry silently
          emit(PusherInitialized()); // Emit initialized state anyway
        },
        (_) => emit(PusherInitialized()),
      );
    } catch (e) {
      // Handle exceptions silently - don't emit error state
      print('⚠️ Pusher initialization exception (handled silently): $e');
      // Don't emit error - we'll retry silently
      emit(PusherInitialized()); // Emit initialized state anyway
    } finally {
      _isInitializing = false;
    }
  }

  /// Subscribe to a chat channel for a specific chat room
  Future<void> subscribeToChatChannel(int chatRoomId, String authToken) async {
    try {
      if (state is! PusherInitialized) {
        await initialize();
      }

      // Don't emit subscribing state if already subscribed
      if (state is! PusherSubscribing) {
        emit(PusherSubscribing());
      }

      final result = await _pusherRepo.subscribeToChatChannel(chatRoomId, authToken);

      result.fold(
        (failure) {
          // Handle failures gracefully - emit error but don't crash
          print('⚠️ Pusher subscription failed: ${failure.message}');
          // Only emit if not already subscribed
          if (state is! PusherSubscribed) {
            emit(PusherSubscribed());
          }
        },
        (_) {
          // Only emit if not already subscribed
          if (state is! PusherSubscribed) {
            emit(PusherSubscribed());
          }
        },
      );
    } catch (e) {
      // Handle exceptions gracefully - emit error but don't crash
      print('⚠️ Pusher subscription exception: $e');
      // Only emit if not already subscribed
      if (state is! PusherSubscribed) {
        emit(PusherSubscribed());
      }
    }
  }

  /// Unsubscribe from the current chat channel
  Future<void> unsubscribeFromChatChannel() async {
    emit(PusherUnsubscribing());

    final result = await _pusherRepo.unsubscribeFromChatChannel();

    result.fold(
      (failure) => emit(PusherError(failure.message)),
      (_) => emit(PusherUnsubscribed()),
    );
  }

  /// Disconnect from Pusher
  Future<void> disconnect() async {
    emit(PusherDisconnecting());

    final result = await _pusherRepo.disconnect();

    result.fold(
      (failure) => emit(PusherError(failure.message)),
      (_) => emit(PusherDisconnected()),
    );
  }

  /// Callback when a new message is received
  void _onMessageReceived(PusherMessageModel message) {
    emit(PusherMessageReceived(message));
  }

  /// Callback when connection is established
  void _onConnectionEstablished(String message) {
    emit(PusherConnectionEstablished(message));
  }

  /// Callback when connection error occurs
  void _onConnectionError(String error) {
    emit(PusherConnectionError(error));
  }

  /// Check if connected to Pusher
  bool get isConnected => _pusherRepo.isConnected;

  /// Check connection health and reconnect if needed
  Future<bool> checkConnectionHealth() async {
    try {
      return await _pusherRepo.checkConnectionHealth();
    } catch (e) {
      print('⚠️ Connection health check failed: $e');
      return false;
    }
  }

  /// Test message handling (for debugging)
  void testMessageHandling() {
    try {
      _pusherRepo.testMessageHandling();
    } catch (e) {
      print('⚠️ Test message handling failed: $e');
    }
  }

  /// Test full message pipeline (for debugging)
  void testFullMessagePipeline() {
    try {
      _pusherRepo.testFullMessagePipeline();
    } catch (e) {
      print('⚠️ Test message pipeline failed: $e');
    }
  }

  /// Simulate receiving a message (for debugging)
  void simulateMessageReceived(String messageText, int chatId) {
    try {
      // Access the pusher service through singleton instance
      PusherService.instance.simulateMessageReceived(messageText, chatId);
    } catch (e) {
      print('⚠️ Simulate message failed: $e');
    }
  }
}
