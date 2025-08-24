import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/errors/failures.dart';
import 'package:elsadeken/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_room.dart';
import 'package:elsadeken/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRooms() async {
    try {
      final chatRooms = await remoteDataSource.getChatRooms();
      return Right(chatRooms);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatMessages(String roomId) async {
    try {
      final messages = await remoteDataSource.getChatMessages(roomId);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String roomId, String message) async {
    try {
      await remoteDataSource.sendMessage(roomId, message);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String roomId) async {
    try {
      await remoteDataSource.markAsRead(roomId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChat(String roomId) async {
    try {
      await remoteDataSource.deleteChat(roomId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllChats() async {
    try {
      await remoteDataSource.deleteAllChats();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
