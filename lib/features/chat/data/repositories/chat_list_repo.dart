import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elsadeken/core/networking/api_error_handler.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/chat/data/datasources/chat_list_data_source.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';

abstract class ChatListRepoInterface {
  Future<Either<ApiErrorModel, ChatListModel>> getAllChatList();
}

class ChatListRepoImpl extends ChatListRepoInterface {
  final ChatListDataSource chatListDataSource;

  ChatListRepoImpl(this.chatListDataSource);
  @override
  Future<Either<ApiErrorModel, ChatListModel>> getAllChatList() async {
    try {
      var response = await chatListDataSource.getAllChatList();
      return Right(response);
    } catch (error) {
      log("error in get all chat list $error");
      if (error is ApiErrorModel) {
        return Left(error);
      }
      return Left(ApiErrorHandler.handle(error));
    }
  }
}
