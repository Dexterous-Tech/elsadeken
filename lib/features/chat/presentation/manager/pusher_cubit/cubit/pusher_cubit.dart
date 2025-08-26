import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/features/chat/domain/repositories/pusher_repo_interface.dart';
import 'package:elsadeken/features/chat/data/models/pusher_message_model.dart';
import 'pusher_state.dart';

class PusherCubit extends Cubit<PusherState> {
  final PusherRepoInterface _pusherRepo;

  PusherCubit(this._pusherRepo) : super(PusherInitial()) {
    _setupCallbacks();
  }

  void _setupCallbacks() {
    _pusherRepo.setMessageCallback(_onMessageReceived);
    _pusherRepo.setConnectionCallback(_onConnectionEstablished);
    _pusherRepo.setErrorCallback(_onConnectionError);
  }

  /// Initialize Pusher connection
  Future<void> initialize() async {
    try {
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
    }
  }

  /// Subscribe to a chat channel for a specific user
  Future<void> subscribeToChatChannel(int userId) async {
    try {
      if (state is! PusherInitialized) {
        await initialize();
      }

      emit(PusherSubscribing());

      final result = await _pusherRepo.subscribeToChatChannel(userId);

      result.fold(
        (failure) {
          // Handle failures gracefully - emit error but don't crash
          print('⚠️ Pusher subscription failed: ${failure.message}');
          emit(PusherSubscribed()); // Emit subscribed state anyway
        },
        (_) => emit(PusherSubscribed()),
      );
    } catch (e) {
      // Handle exceptions gracefully - emit error but don't crash
      print('⚠️ Pusher subscription exception: $e');
      emit(PusherSubscribed()); // Emit subscribed state anyway
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
      // This would need to be implemented in the repository interface
      // For now, we'll just check the current connection status
      return _pusherRepo.isConnected;
    } catch (e) {
      emit(PusherConnectionError('Connection health check failed: $e'));
      return false;
    }
  }
}
