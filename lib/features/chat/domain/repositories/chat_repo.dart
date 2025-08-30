import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/chat/data/datasources/chat_data_source.dart';
import 'package:elsadeken/features/chat/data/models/chat_conversation_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/data/models/send_message_model.dart';

abstract class ChatRepoInterface {
  Future<Either<ApiErrorModel, ChatListModel>> getAllChatList();
  Future<Either<ApiErrorModel, ChatMessagesConversation>> getChatMessages(
      String chatId);

  Future<Either<ApiErrorModel, SendMessageModel>> sendMessage(
    int receiverId,
    String message,
  );

  Future<Either<ApiErrorModel, Map<String, dynamic>>> markAllMessagesAsRead();
  Future<Either<ApiErrorModel, Map<String, dynamic>>> reportChat(int chatId);
  Future<Either<ApiErrorModel, Map<String, dynamic>>> muteChat(int chatId);
  Future<Either<ApiErrorModel, Map<String, dynamic>>> deleteOneChat(int chatId);
  Future<Either<ApiErrorModel, Map<String, dynamic>>> deleteAllChats();
  Future<Either<ApiErrorModel, ChatListModel>> getFavoriteChatList();
  Future<Either<ApiErrorModel, Map<String, dynamic>>> addChatToFavorite(
      int chatId, {int favourite = 1});
  Future<Either<ApiErrorModel, Map<String, dynamic>>> removeChatFromFavorite(
      int chatId);
}

