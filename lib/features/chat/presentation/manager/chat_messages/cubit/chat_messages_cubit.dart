import 'package:elsadeken/features/chat/data/repositories/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final ChatRepoInterface repo;

  ChatMessagesCubit(this.repo) : super(ChatMessagesInitial());

  Future<void> getChatMessages(String chatId) async {
    emit(ChatMessagesLoading());

    final result = await repo.getChatMessages(chatId);

    result.fold(
      (error) => emit(ChatMessagesError(error.message ?? "حدث خطأ ما")),
      (chatMessages) => emit(ChatMessagesLoaded(chatMessages)),
    );
  }
}
