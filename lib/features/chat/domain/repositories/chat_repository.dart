import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/errors/failures.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_room.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatRoom>>> getChatRooms();
  Future<Either<Failure, List<ChatMessage>>> getChatMessages(String roomId);
  Future<Either<Failure, void>> sendMessage(String roomId, String message);
  Future<Either<Failure, void>> markAsRead(String roomId);
  Future<Either<Failure, void>> deleteChat(String roomId);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteAllChats();
}
