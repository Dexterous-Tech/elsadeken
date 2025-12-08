import 'package:dartz/dartz.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/domain/repositories/chat_repo.dart';
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
      emit(const ChatListLoading());

      final Either<ApiErrorModel, ChatListModel> failureOrData =
          await chatListRepo.getAllChatList();

      failureOrData.fold(
        (failure) {
          emit(ChatListError(failure.message ?? failure.toString()));
        },
        (data) {
          // Sort the chat list by newest message timestamp
          final sortedData = _sortChatListByNewestMessage(data);
          emit(ChatListLoaded(sortedData));
        },
      );
    } catch (e) {
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
      final currentState = state;
      if (currentState is ChatListLoaded) {
        // Debug: Print all chat data to understand the structure
        for (int i = 0; i < currentState.chatList.data.length; i++) {
          // final chat = currentState.chatList.data[i];
        }

        final existingChats = currentState.chatList.data.where((chat) {
          final matches = chat.otherUser.id == receiverId;
          return matches;
        }).toList();

        if (existingChats.isNotEmpty) {
          final foundChat = existingChats.first;

          try {
            final chatRoomModel = foundChat.toChatRoomModel();
            return chatRoomModel;
          } catch (e) {
            return null;
          }
        } else {}
      } else {}
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Mark all messages as read
  Future<void> markAllMessagesAsRead() async {
    try {
      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.markAllMessagesAsRead();

      result.fold(
        (failure) {
          // You could emit an error state here if needed
        },
        (success) {
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
            final sortedChatList = _sortChatListByNewestMessage(
              updatedChatList,
            );
            emit(ChatListLoaded(sortedChatList));
          }
        },
      );
    } catch (e) {
      // exception
    }
  }

  /// Report a user
  Future<void> reportUser(int userId) async {
    try {
      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.reportChat(userId);

      result.fold(
        (failure) {
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في الإبلاغ عن المستخدم'));
        },
        (success) {
          // Show success message and refresh chat list
          getChatList();
        },
      );
    } catch (e) {
      emit(ChatListError('حدث خطأ أثناء الإبلاغ عن المستخدم'));
    }
  }

  /// Unreport a user
  Future<void> unreportUser(int userId) async {
    try {
      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.unreportChat(userId);

      result.fold(
        (failure) {
          // Show error message to user
          emit(
            ChatListError(
              failure.message ?? 'فشل في إلغاء الإبلاغ عن المستخدم',
            ),
          );
        },
        (success) {
          // Show success message and refresh chat list
          getChatList();
        },
      );
    } catch (e) {
      emit(ChatListError('حدث خطأ أثناء إلغاء الإبلاغ عن المستخدم'));
    }
  }

  /// Mute a user
  Future<void> muteUser(int userId) async {
    try {
      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.muteChat(userId);

      result.fold(
        (failure) {
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في كتم صوت المستخدم'));
        },
        (success) {
          // Show success message and refresh chat list
          getChatList();
        },
      );
    } catch (e) {
      emit(ChatListError('حدث خطأ أثناء كتم صوت المستخدم'));
    }
  }

  /// Delete one chat
  Future<void> deleteOneChat(int chatId) async {
    try {
      // Find and log the chat being deleted for verification
      final currentState = state;
      if (currentState is ChatListLoaded) {
        currentState.chatList.data.firstWhere(
          (chat) => chat.id == chatId,
          orElse: () => throw Exception('Chat not found in current list'),
        );
      }

      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.deleteOneChat(chatId);

      result.fold(
        (failure) {
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في حذف المحادثة'));
        },
        (success) {
          // Remove the deleted chat from the current state
          final currentState = state;
          if (currentState is ChatListLoaded) {
            final updatedChatList = currentState.chatList.copyWith(
              data: currentState.chatList.data
                  .where((chat) => chat.id != chatId)
                  .toList(),
            );

            // Verify the chat was actually removed
            currentState.chatList.data.any((chat) => chat.id == chatId);
            updatedChatList.data.any((chat) => chat.id == chatId);

            // Sort and emit updated state
            final sortedChatList = _sortChatListByNewestMessage(
              updatedChatList,
            );
            emit(ChatListLoaded(sortedChatList));
          }
        },
      );
    } catch (e) {
      emit(ChatListError('حدث خطأ أثناء حذف المحادثة'));
    }
  }

  /// Delete all chats
  Future<void> deleteAllChats() async {
    try {
      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.deleteAllChats();

      result.fold(
        (failure) {
          // Show error message to user
          emit(ChatListError(failure.message ?? 'فشل في حذف جميع المحادثات'));
        },
        (success) {
          // Clear all chats from the current state
          final currentState = state;
          if (currentState is ChatListLoaded) {
            final updatedChatList = currentState.chatList.copyWith(data: []);
            emit(ChatListLoaded(updatedChatList));
          }
        },
      );
    } catch (e) {
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

    return chatList.copyWith(data: sortedData);
  }

  /// Handle new message and update chat list accordingly
  void handleNewMessage(
    int chatId,
    String messageBody,
    String timestamp,
    int senderId,
  ) {
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
              isFavorite: chat.isFavorite ? 1 : 0,
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
    }
  }

  /// Get favorite chat list
  Future<void> getFavoriteChatList() async {
    try {
      // Emit loading state
      emit(const ChatListLoading());

      final Either<ApiErrorModel, ChatListModel> failureOrData =
          await chatListRepo.getFavoriteChatList();

      failureOrData.fold(
        (failure) {
          emit(ChatListError(failure.message ?? 'فشل في جلب قائمة المفضلة'));
        },
        (data) {
          // Sort the chat list by newest message timestamp
          final sortedData = _sortChatListByNewestMessage(data);
          emit(ChatListLoaded(sortedData));
        },
      );
    } catch (e) {
      emit(ChatListError('حدث خطأ أثناء جلب قائمة المفضلة'));
    }
  }

  /// Add chat to favorites
  Future<void> addChatToFavorite(int chatId) async {
    try {
      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.addChatToFavorite(chatId, favourite: 1);

      result.fold(
        (failure) {
          // Show error message to user
          emit(
            ChatListError(
              failure.message ?? 'فشل في إضافة المحادثة إلى المفضلة',
            ),
          );
        },
        (success) {
          // Update the chat locally to show immediate feedback
          _updateChatFavoriteStatus(chatId, true);

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
      emit(ChatListError('حدث خطأ أثناء إضافة المحادثة إلى المفضلة'));
    }
  }

  /// Remove chat from favorites
  Future<void> removeChatFromFavorite(int chatId) async {
    try {
      final Either<ApiErrorModel, Map<String, dynamic>> result =
          await chatListRepo.addChatToFavorite(chatId, favourite: 0);

      result.fold(
        (failure) {
          // Show error message to user
          emit(
            ChatListError(
              failure.message ?? 'فشل في إزالة المحادثة من المفضلة',
            ),
          );
        },
        (success) {
          // Update the chat locally to show immediate feedback
          _updateChatFavoriteStatus(chatId, false);

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
      emit(ChatListError('حدث خطأ أثناء إزالة المحادثة من المفضلة'));
    }
  }

  /// Toggle chat favorite status
  Future<void> toggleChatFavorite(int chatId, bool currentlyFavorite) async {
    if (currentlyFavorite) {
      await removeChatFromFavorite(chatId);
    } else {
      await addChatToFavorite(chatId);
    }
  }

  /// Update chat favorite status locally for immediate UI feedback
  void _updateChatFavoriteStatus(int chatId, bool isFavorite) {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      final updatedChatList = currentState.chatList.copyWith(
        data: currentState.chatList.data.map((chat) {
          if (chat.id == chatId) {
            return chat.copyWith(isFavorite: isFavorite);
          }
          return chat;
        }).toList(),
      );
      // Sort and emit updated state
      final sortedChatList = _sortChatListByNewestMessage(updatedChatList);
      emit(ChatListLoaded(sortedChatList));
    }
  }

  /// Set the current tab index
  void setCurrentTabIndex(int index) {
    _currentTabIndex = index;
  }
}
