import 'package:dartz/dartz.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/data/repositories/chat_repo.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepoInterface chatListRepo;

  // Track which tab is currently selected (0: All, 1: Favorites)
  int _currentTabIndex = 0;

  ChatListCubit(this.chatListRepo) : super(const ChatListInitial());

  /// Get the current tab index
  int get currentTabIndex => _currentTabIndex;

  Future<void> getChatList() async {
    // Only show loading if this is a completely fresh start
    if (state is ChatListInitial) {
      emit(const ChatListLoading());
    }

    final Either<ApiErrorModel, ChatListModel> failureOrData =
        await chatListRepo.getAllChatList();

    failureOrData.fold(
      (failure) => emit(ChatListError(failure.message ?? failure.toString())),
      (data) {
        // Sort the chat list by newest message timestamp
        final sortedData = _sortChatListByNewestMessage(data);
        emit(ChatListLoaded(sortedData));
      },
    );
  }

  /// Force refresh chat list and wait for it to be loaded
  Future<void> forceRefreshChatList() async {
    try {
      print('🔄 [ChatListCubit] Force refreshing chat list...');
      emit(const ChatListLoading());

      final Either<ApiErrorModel, ChatListModel> failureOrData =
          await chatListRepo.getAllChatList();

      failureOrData.fold(
        (failure) {
          print(
              '❌ [ChatListCubit] Failed to refresh chat list: ${failure.message}');
          emit(ChatListError(failure.message ?? failure.toString()));
        },
        (data) {
          print(
              '✅ [ChatListCubit] Chat list refreshed successfully with ${data.data.length} chats');
          // Sort the chat list by newest message timestamp
          final sortedData = _sortChatListByNewestMessage(data);
          emit(ChatListLoaded(sortedData));
        },
      );
    } catch (e) {
      print('❌ [ChatListCubit] Exception in forceRefreshChatList: $e');
      emit(ChatListError('حدث خطأ أثناء تحديث قائمة المحادثات'));
    }
  }

  /// Silently refresh chat list in background without showing loading indicator
  Future<void> silentRefreshChatList() async {
    try {
      // Silent operation - minimal logging
      final Either<ApiErrorModel, ChatListModel> failureOrData =
          await chatListRepo.getAllChatList();

      failureOrData.fold(
        (failure) {
          // Silent failure - don't emit error state to avoid UI disruption
        },
        (data) {
          // Only emit loaded state - no loading indicator shown
          // Sort the chat list by newest message timestamp
          final sortedData = _sortChatListByNewestMessage(data);
          emit(ChatListLoaded(sortedData));
        },
      );
    } catch (e) {
      // Silent error handling - don't emit error state to avoid UI disruption
    }
  }

  /// Mark a specific chat as read (silent operation)
  void markChatAsRead(int chatId) {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      // Create updated chat list with this chat marked as read
      final updatedChatList = currentState.chatList.copyWith(
        data: currentState.chatList.data.map((chat) {
          if (chat.id == chatId) {
            return chat.copyWith(unreadCount: 0);
          }
          return chat;
        }).toList(),
      );

      // Sort and emit updated state
      final sortedChatList = _sortChatListByNewestMessage(updatedChatList);
      emit(ChatListLoaded(sortedChatList));
    }
  }

  /// Find an existing chat room by receiver ID
  ChatRoomModel? findExistingChatRoom(int receiverId) {
    try {
      print(
          '🔍 [ChatListCubit] Looking for existing chat room for user ID: $receiverId');
      print('🔍 [ChatListCubit] Current state: ${state.runtimeType}');

      final currentState = state;
      if (currentState is ChatListLoaded) {
        print(
            '🔍 [ChatListCubit] Chat list is loaded, checking ${currentState.chatList.data.length} chats');

        // Debug: Print all chat data to understand the structure
        for (int i = 0; i < currentState.chatList.data.length; i++) {
          final chat = currentState.chatList.data[i];
          print(
              '🔍 [ChatListCubit] Chat $i: ID=${chat.id}, OtherUserID=${chat.otherUser.id}, OtherUserName=${chat.otherUser.name}');
        }

        final existingChats = currentState.chatList.data.where((chat) {
          print(
              '🔍 [ChatListCubit] Checking chat: ${chat.otherUser.id} vs $receiverId (${chat.otherUser.id == receiverId})');
          return chat.otherUser.id == receiverId;
        }).toList();

        if (existingChats.isNotEmpty) {
          print(
              '✅ [ChatListCubit] Found existing chat: ${existingChats.first.id}');
          return existingChats.first.toChatRoomModel();
        } else {
          print(
              '❌ [ChatListCubit] No existing chat found for user $receiverId');
        }
      } else {
        print(
            '⚠️ [ChatListCubit] Chat list not loaded yet. Current state: ${state.runtimeType}');
      }
      return null;
    } catch (e) {
      print('⚠️ [ChatListCubit] Error finding existing chat room: $e');
      return null;
    }
  }

  /// Mark all messages as read
  Future<void> markAllMessagesAsRead() async {
    try {
      print('[ChatListCubit] Marking all messages as read...');

      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.markAllMessagesAsRead();

      result.fold(
        (failure) {
          print('[ChatListCubit] Mark all as read failed: ${failure.message}');
          // You could emit an error state here if needed
        },
        (success) {
          print('[ChatListCubit] Mark all as read successful: $success');

          // Update the current state to reflect all messages as read
          final currentState = state;
          if (currentState is ChatListLoaded) {
            // Create new chat list with all unread counts set to 0
            final updatedChatList = currentState.chatList.copyWith(
              data: currentState.chatList.data
                  .map((chat) => chat.copyWith(unreadCount: 0))
                  .toList(),
            );

            // Sort and emit updated state
            final sortedChatList =
                _sortChatListByNewestMessage(updatedChatList);
            emit(ChatListLoaded(sortedChatList));
          }
        },
      );
    } catch (e) {
      print('[ChatListCubit] Exception in markAllMessagesAsRead: $e');
    }
  }

  /// Report a user
  Future<void> reportUser(int userId) async {
    try {
      print('[ChatListCubit] Reporting user $userId...');

      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.reportChat(userId);

      result.fold(
        (failure) {
          print('[ChatListCubit] Report user failed: ${failure.message}');
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في الإبلاغ عن المستخدم'));
        },
        (success) {
          print('[ChatListCubit] Report user successful: $success');
          // Show success message and refresh chat list
          getChatList();
        },
      );
    } catch (e) {
      print('[ChatListCubit] Exception in reportUser: $e');
      emit(ChatListError('حدث خطأ أثناء الإبلاغ عن المستخدم'));
    }
  }

  /// Mute a user
  Future<void> muteUser(int userId) async {
    try {
      print('[ChatListCubit] Muting user $userId...');

      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.muteChat(userId);

      result.fold(
        (failure) {
          print('[ChatListCubit] Mute user failed: ${failure.message}');
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في كتم صوت المستخدم'));
        },
        (success) {
          print('[ChatListCubit] Mute user successful: $success');
          // Show success message and refresh chat list
          getChatList();
        },
      );
    } catch (e) {
      print('[ChatListCubit] Exception in muteUser: $e');
      emit(ChatListError('حدث خطأ أثناء كتم صوت المستخدم'));
    }
  }

  /// Delete one chat
  Future<void> deleteOneChat(int chatId) async {
    try {
      print('[ChatListCubit] Deleting chat $chatId...');

      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.deleteOneChat(chatId);

      result.fold(
        (failure) {
          print('[ChatListCubit] Delete chat failed: ${failure.message}');
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في حذف المحادثة'));
        },
        (success) {
          print('[ChatListCubit] Delete chat successful: $success');
          // Remove the deleted chat from the current state
          final currentState = state;
          if (currentState is ChatListLoaded) {
            final updatedChatList = currentState.chatList.copyWith(
              data: currentState.chatList.data
                  .where((chat) => chat.id != chatId)
                  .toList(),
            );
            // Sort and emit updated state
            final sortedChatList =
                _sortChatListByNewestMessage(updatedChatList);
            emit(ChatListLoaded(sortedChatList));
          }
        },
      );
    } catch (e) {
      print('[ChatListCubit] Exception in deleteOneChat: $e');
      emit(ChatListError('حدث خطأ أثناء حذف المحادثة'));
    }
  }

  /// Delete all chats
  Future<void> deleteAllChats() async {
    try {
      print('[ChatListCubit] Deleting all chats...');

      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.deleteAllChats();

      result.fold(
        (failure) {
          print('[ChatListCubit] Delete all chats failed: ${failure.message}');
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في حذف جميع المحادثات'));
        },
        (success) {
          print('[ChatListCubit] Delete all chats successful: $success');
          // Clear all chats from the current state
          final currentState = state;
          if (currentState is ChatListLoaded) {
            final updatedChatList = currentState.chatList.copyWith(
              data: [],
            );
            emit(ChatListLoaded(updatedChatList));
          }
        },
      );
    } catch (e) {
      print('[ChatListCubit] Exception in deleteAllChats: $e');
      emit(ChatListError('حدث خطأ أثناء حذف جميع المحادثات'));
    }
  }

  /// Sort chat list by newest message timestamp
  ChatListModel _sortChatListByNewestMessage(ChatListModel chatList) {
    final sortedData = List<ChatData>.from(chatList.data);

    sortedData.sort((a, b) {
      // If both have last messages, compare by timestamp
      if (a.lastMessage != null && b.lastMessage != null) {
        final aTime =
            DateTime.tryParse(a.lastMessage!.createdAt) ?? DateTime(1900);
        final bTime =
            DateTime.tryParse(b.lastMessage!.createdAt) ?? DateTime(1900);
        return bTime.compareTo(aTime); // Newest first (descending order)
      }

      // If only one has last message, prioritize the one with message
      if (a.lastMessage != null && b.lastMessage == null) {
        return -1; // a comes first
      }
      if (a.lastMessage == null && b.lastMessage != null) {
        return 1; // b comes first
      }

      // If neither has last message, compare by chat creation time
      final aCreated = DateTime.tryParse(a.createdAt) ?? DateTime(1900);
      final bCreated = DateTime.tryParse(b.createdAt) ?? DateTime(1900);
      return bCreated.compareTo(aCreated); // Newest first
    });

    print(
        '🔄 [ChatListCubit] Sorted ${sortedData.length} chats by newest message');

    return chatList.copyWith(data: sortedData);
  }

  /// Handle new message and update chat list accordingly
  void handleNewMessage(
      int chatId, String messageBody, String timestamp, int senderId) {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      // Find the chat and update its last message
      final updatedChatList = currentState.chatList.copyWith(
        data: currentState.chatList.data.map((chat) {
          if (chat.id == chatId) {
            // Create a new last message
            final newLastMessage = LastMessage(
              id: chat.lastMessage?.id ?? 0,
              chatId: chatId,
              senderId: senderId,
              receiverId: chat.otherUser.id,
              body: messageBody,
              isReported: 0,
              isMuted: 0,
              createdAt: timestamp,
            );

            // Update unread count if message is from other user
            final newUnreadCount = senderId != chat.otherUser.id
                ? chat.unreadCount + 1
                : chat.unreadCount;

            return chat.copyWith(
              lastMessage: newLastMessage,
              unreadCount: newUnreadCount,
            );
          }
          return chat;
        }).toList(),
      );

      // Sort and emit updated state
      final sortedChatList = _sortChatListByNewestMessage(updatedChatList);
      emit(ChatListLoaded(sortedChatList));

      print(
          '🔄 [ChatListCubit] Updated chat $chatId with new message and re-sorted list');
    }
  }

  /// Get favorite chat list
  Future<void> getFavoriteChatList() async {
    try {
      print('[ChatListCubit] Getting favorite chat list...');

      // Emit loading state
      emit(const ChatListLoading());

      final Either<ApiErrorModel, ChatListModel> failureOrData =
          await chatListRepo.getFavoriteChatList();

      failureOrData.fold(
        (failure) {
          print(
              '[ChatListCubit] Get favorite chat list failed: ${failure.message}');
          emit(ChatListError(failure.message ?? 'فشل في جلب قائمة المفضلة'));
        },
        (data) {
          print(
              '[ChatListCubit] Get favorite chat list successful with ${data.data.length} chats');
          // Sort the chat list by newest message timestamp
          final sortedData = _sortChatListByNewestMessage(data);
          emit(ChatListLoaded(sortedData));
        },
      );
    } catch (e) {
      print('[ChatListCubit] Exception in getFavoriteChatList: $e');
      emit(ChatListError('حدث خطأ أثناء جلب قائمة المفضلة'));
    }
  }

  /// Add chat to favorites
  Future<void> addChatToFavorite(int chatId) async {
    try {
      print('[ChatListCubit] Adding chat $chatId to favorites...');

      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.addChatToFavorite(chatId);

      result.fold(
        (failure) {
          print('[ChatListCubit] Add to favorite failed: ${failure.message}');
          // Show error message to user
          emit(ChatListError(
              failure.message ?? 'فشل في إضافة المحادثة إلى المفضلة'));
        },
        (success) {
          print('[ChatListCubit] Add to favorite successful: $success');
          // Refresh the appropriate list based on current tab
          if (_currentTabIndex == 0) {
            // We're on "All" tab, refresh all chats list
            getChatList();
          } else if (_currentTabIndex == 1) {
            // We're on "Favorites" tab, refresh favorites list
            getFavoriteChatList();
          }
        },
      );
    } catch (e) {
      print('[ChatListCubit] Exception in addChatToFavorite: $e');
      emit(ChatListError('حدث خطأ أثناء إضافة المحادثة إلى المفضلة'));
    }
  }

  /// Set the current tab index
  void setCurrentTabIndex(int index) {
    print('[ChatListCubit] Setting current tab index to: $index');
    _currentTabIndex = index;
  }
}
