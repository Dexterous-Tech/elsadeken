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
      int chatId);
}

class ChatRepoImpl extends ChatRepoInterface {
  final ChatDataSource chatDataSource;

  ChatRepoImpl(this.chatDataSource);
  @override
  Future<Either<ApiErrorModel, ChatListModel>> getAllChatList() async {
    try {
      var response = await chatDataSource.getAllChatList();
      return Right(response);
    } catch (error) {
      log("error in get all chat list $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, ChatMessagesConversation>> getChatMessages(
      String chatId) async {
    try {
      final response = await chatDataSource.getChatMessages(chatId);
      return Right(response);
    } catch (error) {
      log("error in getChatMessages: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, SendMessageModel>> sendMessage(
    int receiverId,
    String message,
  ) async {
    try {
      final response = await chatDataSource.sendMessage(receiverId, message);
      return Right(response);
    } catch (error) {
      log("error in sendMessage: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, Map<String, dynamic>>>
      markAllMessagesAsRead() async {
    try {
      final response = await chatDataSource.markAllMessagesAsRead();
      return Right(response);
    } catch (error) {
      log("error in markAllMessagesAsRead: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, Map<String, dynamic>>> reportChat(
      int chatId) async {
    try {
      final response = await chatDataSource.reportChat(chatId);
      return Right(response);
    } catch (error) {
      log("error in reportChat: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, Map<String, dynamic>>> muteChat(
      int chatId) async {
    try {
      final response = await chatDataSource.muteChat(chatId);
      return Right(response);
    } catch (error) {
      log("error in muteChat: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, Map<String, dynamic>>> deleteOneChat(
      int chatId) async {
    try {
      final response = await chatDataSource.deleteOneChat(chatId);
      return Right(response);
    } catch (error) {
      log("error in deleteOneChat: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, Map<String, dynamic>>> deleteAllChats() async {
    try {
      final response = await chatDataSource.deleteAllChats();
      return Right(response);
    } catch (error) {
      log("error in deleteAllChats: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, ChatListModel>> getFavoriteChatList() async {
    try {
      final response = await chatDataSource.getFavoriteChatList();
      return Right(response);
    } catch (error) {
      log("error in getFavoriteChatList: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ApiErrorModel, Map<String, dynamic>>> addChatToFavorite(
      int chatId) async {
    try {
      final response = await chatDataSource.addChatToFavorite(chatId);
      return Right(response);
    } catch (error) {
      log("error in addChatToFavorite: $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
