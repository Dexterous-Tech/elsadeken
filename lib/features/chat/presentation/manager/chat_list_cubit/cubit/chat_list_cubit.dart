import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/data/repositories/chat_repo.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepoInterface chatListRepo;

  ChatListCubit(this.chatListRepo) : super(const ChatListInitial());

  Future<void> getChatList() async {
    emit(const ChatListLoading());

    final Either<ApiErrorModel, ChatListModel> failureOrData =
        await chatListRepo.getAllChatList();

    failureOrData.fold(
      (failure) => emit(ChatListError(failure.message ?? failure.toString())),
      (data) => emit(ChatListLoaded(data)),
    );
  }
}
