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

    result.fold(
      (error) {
        // If chat is deleted (404 error), show appropriate message
        if (error.statusCode == 404) {
          print('[ChatMessagesCubit] Chat not found (404) during initial load');
          emit(ChatMessagesError("هذه المحادثة لم تعد موجودة"));
        } else {
          emit(ChatMessagesError(error.message ?? "حدث خطأ ما"));
        }
      },
      (chatMessages) => emit(ChatMessagesLoaded(chatMessages)),
    );
  }

  /// Refresh chat messages without showing loading state
  Future<void> refreshChatMessages(String chatId) async {
    print('[ChatMessagesCubit] Refreshing messages for chat $chatId');
    
    final result = await repo.getChatMessages(chatId);

    result.fold(
      (error) {
        print('[ChatMessagesCubit] Error refreshing messages: ${error.message}');
        
        // If chat is deleted (404 error), stop auto-refresh to prevent spam
        if (error.statusCode == 404) {
          print('[ChatMessagesCubit] Chat not found (404) - stopping auto-refresh');
          stopAutoRefresh();
          emit(ChatMessagesError("هذه المحادثة لم تعد موجودة"));
        } else {
          emit(ChatMessagesError(error.message ?? "حدث خطأ ما"));
        }
      },
      (chatMessages) {
        print('[ChatMessagesCubit] Successfully refreshed ${chatMessages.messages.length} messages');
        emit(ChatMessagesLoaded(chatMessages));
      },
    );
  }

  /// Start auto-refresh timer
  void startAutoRefresh(String chatId, {Duration interval = const Duration(seconds: 5)}) {
    stopAutoRefresh(); // Stop any existing timer
    
    print('[ChatMessagesCubit] Starting auto-refresh for chat $chatId every ${interval.inSeconds} seconds');
    
    _refreshTimer = Timer.periodic(interval, (timer) {
      if (state is! ChatMessagesLoading) {
        print('[ChatMessagesCubit] Auto-refresh triggered for chat $chatId');
        refreshChatMessages(chatId);
      } else {
        print('[ChatMessagesCubit] Skipping auto-refresh - already loading');
      }
    });
  }

  /// Stop auto-refresh timer
  void stopAutoRefresh() {
    if (_refreshTimer != null) {
      print('[ChatMessagesCubit] Stopping auto-refresh timer');
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
