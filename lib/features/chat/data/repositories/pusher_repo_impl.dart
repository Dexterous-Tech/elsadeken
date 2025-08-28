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
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToChatChannel(int userId) async {
    try {
      await _pusherService.subscribeToChatChannel(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromChatChannel() async {
    try {
      _pusherService.unsubscribeFromChatChannel();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      _pusherService.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  void setMessageCallback(Function(PusherMessageModel) callback) {
    _pusherService.onMessageReceived = callback;
  }

  @override
  void setConnectionCallback(Function(String) callback) {
    _pusherService.onConnectionEstablished = callback;
  }

  @override
  void setErrorCallback(Function(String) callback) {
    _pusherService.onConnectionError = callback;
  }

  @override
  bool get isConnected => _pusherService.isConnected;

  @override
  Future<bool> checkConnectionHealth() async {
    try {
      return await _pusherService.checkConnectionHealth();
    } catch (e) {
      print('⚠️ Connection health check failed: $e');
      return false;
    }
  }
}
