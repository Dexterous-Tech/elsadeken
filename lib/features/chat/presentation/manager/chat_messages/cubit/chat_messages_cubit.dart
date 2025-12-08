import 'dart:async';
import 'package:elsadeken/features/chat/domain/repositories/chat_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final ChatRepoInterface repo;
  Timer? _refreshTimer;

  ChatMessagesCubit(this.repo) : super(ChatMessagesInitial());

  Future<void> getChatMessages(String chatId) async {
    emit(ChatMessagesLoading());

    final result = await repo.getChatMessages(chatId);

    result.fold((error) {
      // If chat is deleted (404 error), show appropriate message
      if (error.statusCode == 404) {
        emit(ChatMessagesError("thisConversationNoLongerExists"));
      } else {
        emit(ChatMessagesError(error.message ?? "errorOccurred"));
      }
    }, (chatMessages) => emit(ChatMessagesLoaded(chatMessages)));
  }

  /// Refresh chat messages without showing loading state
  Future<void> refreshChatMessages(String chatId) async {
    final result = await repo.getChatMessages(chatId);

    result.fold(
      (error) {
        // If chat is deleted (404 error), stop auto-refresh to prevent spam
        if (error.statusCode == 404) {
          stopAutoRefresh();
          emit(ChatMessagesError("thisConversationNoLongerExists"));
        } else {
          emit(ChatMessagesError(error.message ?? "errorOccurred"));
        }
      },
      (chatMessages) {
        emit(ChatMessagesLoaded(chatMessages));
      },
    );
  }

  /// Start auto-refresh timer
  void startAutoRefresh(
    String chatId, {
    Duration interval = const Duration(seconds: 5),
  }) {
    stopAutoRefresh(); // Stop any existing timer

    _refreshTimer = Timer.periodic(interval, (timer) {
      if (state is! ChatMessagesLoading) {
        refreshChatMessages(chatId);
      } else {}
    });
  }

  /// Stop auto-refresh timer
  void stopAutoRefresh() {
    if (_refreshTimer != null) {
      _refreshTimer?.cancel();
      _refreshTimer = null;
    }
  }

  @override
  Future<void> close() {
    stopAutoRefresh();
    return super.close();
  }
}
