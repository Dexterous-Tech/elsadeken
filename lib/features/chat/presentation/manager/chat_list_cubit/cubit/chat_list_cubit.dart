import 'package:dartz/dartz.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elsadeken/core/networking/api_error_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/data/repositories/chat_repo.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepoInterface chatListRepo;
  
  // Track deleted chat IDs to prevent them from being restored
  final Set<int> _deletedChatIds = {};

  ChatListCubit(this.chatListRepo) : super(const ChatListInitial());

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
        // Filter out deleted chats to prevent them from being restored
        final filteredData = data.data.where((chat) => !_deletedChatIds.contains(chat.id)).toList();
        final filteredChatList = data.copyWith(data: filteredData);
        
        if (_deletedChatIds.isNotEmpty) {
          print('[ChatListCubit] 🛡️ Filtered out deleted chats: ${_deletedChatIds.toList()}');
          print('[ChatListCubit] 🛡️ Remaining chats: ${filteredData.map((c) => c.id).toList()}');
        }
        
        // Sort the chat list by newest message timestamp
        final sortedData = _sortChatListByNewestMessage(filteredChatList);
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
          print('❌ [ChatListCubit] Failed to refresh chat list: ${failure.message}');
          emit(ChatListError(failure.message ?? failure.toString()));
        },
        (data) {
          // Filter out deleted chats to prevent them from being restored
          final filteredData = data.data.where((chat) => !_deletedChatIds.contains(chat.id)).toList();
          final filteredChatList = data.copyWith(data: filteredData);
          
          if (_deletedChatIds.isNotEmpty) {
            print('🛡️ [ChatListCubit] Force refresh: Filtered out deleted chats: ${_deletedChatIds.toList()}');
            print('🛡️ [ChatListCubit] Force refresh: Remaining chats: ${filteredData.map((c) => c.id).toList()}');
          }
          
          print('✅ [ChatListCubit] Chat list refreshed successfully with ${filteredData.length} chats (${data.data.length - filteredData.length} deleted chats filtered)');
          // Sort the chat list by newest message timestamp
          final sortedData = _sortChatListByNewestMessage(filteredChatList);
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
          // Filter out deleted chats to prevent them from being restored
          final filteredData = data.data.where((chat) => !_deletedChatIds.contains(chat.id)).toList();
          final filteredChatList = data.copyWith(data: filteredData);
          
          if (_deletedChatIds.isNotEmpty) {
            print('🛡️ [ChatListCubit] Silent refresh: Filtered out deleted chats: ${_deletedChatIds.toList()}');
          }
          
          // Only emit loaded state - no loading indicator shown
          // Sort the chat list by newest message timestamp
          final sortedData = _sortChatListByNewestMessage(filteredChatList);
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
      print('🔍 [ChatListCubit] Looking for existing chat room for user ID: $receiverId');
      print('🔍 [ChatListCubit] Current state: ${state.runtimeType}');
      
      final currentState = state;
      if (currentState is ChatListLoaded) {
        print('🔍 [ChatListCubit] Chat list is loaded, checking ${currentState.chatList.data.length} chats');
        
        if (currentState.chatList.data.isEmpty) {
          print('🔍 [ChatListCubit] Chat list is empty - no existing chats');
          return null;
        }
        
        // Debug: Print all chat data to understand the structure
        for (int i = 0; i < currentState.chatList.data.length; i++) {
          final chat = currentState.chatList.data[i];
          print('🔍 [ChatListCubit] Chat $i: ID=${chat.id}, OtherUserID=${chat.otherUser.id}, OtherUserName=${chat.otherUser.name}');
        }
        
        final existingChats = currentState.chatList.data
            .where((chat) {
              final matches = chat.otherUser.id == receiverId;
              print('🔍 [ChatListCubit] Checking chat: ${chat.otherUser.id} vs $receiverId (${matches ? "MATCH" : "no match"})');
              return matches;
            })
            .toList();

        if (existingChats.isNotEmpty) {
          final foundChat = existingChats.first;
          print('✅ [ChatListCubit] Found existing chat: ID=${foundChat.id}, Name=${foundChat.otherUser.name}');
          
          // Convert to ChatRoomModel
          final chatRoomModel = foundChat.toChatRoomModel();
          print('✅ [ChatListCubit] Converted to ChatRoomModel: ID=${chatRoomModel.id}, Name=${chatRoomModel.name}');
          
          return chatRoomModel;
        } else {
          print('❌ [ChatListCubit] No existing chat found for user $receiverId');
          print('🔍 [ChatListCubit] Available user IDs: ${currentState.chatList.data.map((c) => c.otherUser.id).toList()}');
        }
      } else {
        print('⚠️ [ChatListCubit] Chat list not loaded yet. Current state: ${state.runtimeType}');
        
        if (currentState is ChatListError) {
          print('❌ [ChatListCubit] Chat list error: ${currentState.message}');
        } else if (currentState is ChatListLoading) {
          print('⏳ [ChatListCubit] Chat list is still loading...');
        }
      }
      return null;
    } catch (e) {
      print('❌ [ChatListCubit] Error finding existing chat room: $e');
      print('❌ [ChatListCubit] Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Mark all messages as read
  Future<void> markAllMessagesAsRead() async {
    try {
      print('[ChatListCubit] 🚀 Starting mark all messages as read...');
      
      final Either<ApiErrorModel, Map<String, dynamic>> result = 
          await chatListRepo.markAllMessagesAsRead();
      
      result.fold(
        (failure) {
          print('[ChatListCubit] ❌ Mark all as read failed: ${failure.message}');
          // Emit error state to show user feedback
          emit(ChatListError(failure.message ?? 'فشل في وضع علامة مقروء على جميع الرسائل'));
        },
        (success) {
          print('[ChatListCubit] ✅ Mark all as read successful: $success');
          
          // Update the current state to reflect all messages as read
          final currentState = state;
          if (currentState is ChatListLoaded) {
            final chatCount = currentState.chatList.data.length;
            final chatsWithUnread = currentState.chatList.data.where((chat) => chat.unreadCount > 0).length;
            
            print('[ChatListCubit] 📊 Current state: $chatCount total chats, $chatsWithUnread with unread messages');
            
            // Create new chat list with all unread counts set to 0
            final updatedChatList = currentState.chatList.copyWith(
              data: currentState.chatList.data.map((chat) {
                if (chat.unreadCount > 0) {
                  print('[ChatListCubit] 🔄 Clearing unread count for chat ${chat.id}: ${chat.unreadCount} → 0');
                }
                return chat.copyWith(unreadCount: 0);
              }).toList(),
            );
            
            // Sort and emit updated state
            final sortedChatList = _sortChatListByNewestMessage(updatedChatList);
            emit(ChatListLoaded(sortedChatList));
            
            print('[ChatListCubit] 🎉 All unread counts cleared successfully! UI should update immediately');
          } else {
            // If current state is not loaded, refresh the chat list to get updated data
            print('[ChatListCubit] 🔄 Current state not loaded, refreshing chat list to get updated data...');
            getChatList();
          }
        },
      );
    } catch (e) {
      print('[ChatListCubit] 💥 Exception in markAllMessagesAsRead: $e');
      emit(ChatListError('حدث خطأ أثناء وضع علامة مقروء على جميع الرسائل'));
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
  Future<void> deleteOneChat(dynamic chatId) async {
    try {
      print('[ChatListCubit] 🗑️ Starting delete chat operation for chatId: $chatId (type: ${chatId.runtimeType})');
      
      // Convert chatId to int for API call
      int? apiChatId;
      if (chatId is int) {
        apiChatId = chatId;
      } else if (chatId is String) {
        // Handle temporary chat IDs
        if (chatId.startsWith('temp_')) {
          print('[ChatListCubit] ❌ Cannot delete temporary chat: $chatId');
          emit(ChatListError('لا يمكن حذف المحادثة المؤقتة'));
          return;
        }
        // Convert string ID to int
        apiChatId = int.tryParse(chatId);
        if (apiChatId == null) {
          print('[ChatListCubit] ❌ Invalid chat ID format: $chatId');
          emit(ChatListError('معرف المحادثة غير صحيح'));
          return;
        }
      } else {
        print('[ChatListCubit] ❌ Unsupported chat ID type: ${chatId.runtimeType}');
        emit(ChatListError('نوع معرف المحادثة غير مدعوم'));
        return;
      }
      
      print('[ChatListCubit] 🔄 Converted chatId: $chatId → $apiChatId (int)');
      
      // Validate current state and find the chat to be deleted
      final currentState = state;
      if (currentState is ChatListLoaded) {
        // CRITICAL: Find chat by UNIQUE ID, not by position
        ChatData? chatToDelete;
        try {
          chatToDelete = currentState.chatList.data.firstWhere(
            (chat) => chat.id == apiChatId,
            orElse: () => throw Exception('Chat with ID $apiChatId not found in current state'),
          );
        } catch (e) {
          // If not found by converted ID, try original ID (for debugging)
          try {
            chatToDelete = currentState.chatList.data.firstWhere(
              (chat) => chat.id.toString() == chatId.toString(),
              orElse: () => throw Exception('Chat with ID $chatId not found in current state'),
            );
            print('[ChatListCubit] ⚠️ Found chat by original ID, but there might be a type mismatch');
          } catch (e2) {
            print('[ChatListCubit] ❌ Chat not found by either ID: $chatId or $apiChatId');
            print('[ChatListCubit] 🔍 Available chat IDs: ${currentState.chatList.data.map((c) => c.id).toList()}');
            emit(ChatListError('لم يتم العثور على المحادثة المحددة'));
            return;
          }
        }
        
        print('[ChatListCubit] 📋 Found chat to delete: ID=${chatToDelete.id}, Name=${chatToDelete.otherUser.name}');
        print('[ChatListCubit] 📊 Current chat list has ${currentState.chatList.data.length} chats');
        print('[ChatListCubit] 🔍 Chat position in list: ${currentState.chatList.data.indexOf(chatToDelete)}');
        
        // Log all chat IDs for debugging
        print('[ChatListCubit] 🔍 All chat IDs in current state: ${currentState.chatList.data.map((c) => c.id).toList()}');
        
        // STORE THE CHAT TO DELETE BEFORE API CALL
        final chatIdToDelete = chatToDelete.id;
        final chatNameToDelete = chatToDelete.otherUser.name;
        
        final Either<ApiErrorModel, Map<String, dynamic>> result = 
            await chatListRepo.deleteOneChat(apiChatId);
        
        result.fold(
          (failure) {
            print('[ChatListCubit] ❌ Delete chat failed: ${failure.message}');
            // Show error message to user
            emit(ChatListError(failure.message ?? 'فشل في حذف المحادثة'));
          },
          (success) {
            print('[ChatListCubit] ✅ Delete chat successful: $success');
            
            // CRITICAL: Remove chat by UNIQUE ID, not by position
            final chatsBeforeDeletion = currentState.chatList.data.length;
            
            // Use the stored ID to ensure we remove the correct chat
            final updatedChatList = currentState.chatList.copyWith(
              data: currentState.chatList.data.where((chat) => chat.id != chatIdToDelete).toList(),
            );
            final chatsAfterDeletion = updatedChatList.data.length;
            
            print('[ChatListCubit] 📊 Deletion summary: $chatsBeforeDeletion → $chatsAfterDeletion chats');
            print('[ChatListCubit] 🎯 Removed chat with ID: $chatIdToDelete, Name: "$chatNameToDelete"');
            
            if (chatsBeforeDeletion == chatsAfterDeletion) {
              print('[ChatListCubit] ⚠️ WARNING: No chat was removed from state! This might indicate an ID mismatch');
              print('[ChatListCubit] 🔍 Double-checking available chats after deletion attempt...');
              print('[ChatListCubit] 🔍 Remaining chat IDs: ${updatedChatList.data.map((c) => c.id).toList()}');
            } else {
              print('[ChatListCubit] ✅ Chat successfully removed from state');
              
              // VERIFY the deletion was successful
              final chatStillExists = updatedChatList.data.any((chat) => chat.id == chatIdToDelete);
              if (chatStillExists) {
                print('[ChatListCubit] ❌ VERIFICATION FAILED: Chat $chatIdToDelete still exists after removal!');
              } else {
                print('[ChatListCubit] ✅ VERIFICATION SUCCESS: Chat $chatIdToDelete was successfully removed');
              }
            }
            
            // IMPORTANT: Sort AFTER removing the chat to maintain consistency
            final sortedChatList = _sortChatListByNewestMessage(updatedChatList);
            
            // ADD TO DELETION PROTECTION SET to prevent restoration
            _deletedChatIds.add(chatIdToDelete);
            print('[ChatListCubit] 🛡️ Added chat $chatIdToDelete to deletion protection set');
            print('[ChatListCubit] 🛡️ Current protected IDs: ${_deletedChatIds.toList()}');
            
            emit(ChatListLoaded(sortedChatList));
            
            print('[ChatListCubit] 🎉 Chat deletion completed and state updated');
            print('[ChatListCubit] 🔄 List re-sorted after deletion to maintain newest-first order');
          },
        );
      } else {
        print('[ChatListCubit] ❌ Cannot delete chat: Current state is not ChatListLoaded (${currentState.runtimeType})');
        emit(ChatListError('لا يمكن حذف المحادثة في الوقت الحالي'));
      }
    } catch (e) {
      print('[ChatListCubit] 💥 Exception in deleteOneChat: $e');
      emit(ChatListError('حدث خطأ أثناء حذف المحادثة: $e'));
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
    if (chatList.data.isEmpty) {
      print('🔄 [ChatListCubit] No chats to sort');
      return chatList;
    }
    
    final sortedData = List<ChatData>.from(chatList.data);
    
    // Log the sorting process for debugging
    print('🔄 [ChatListCubit] Starting sort of ${sortedData.length} chats...');
    print('🔄 [ChatListCubit] Before sorting: ${sortedData.map((c) => '${c.id}:"${c.otherUser.name}"').toList()}');
    
    sortedData.sort((a, b) {
      // If both have last messages, compare by timestamp
      if (a.lastMessage != null && b.lastMessage != null) {
        final aTime = DateTime.tryParse(a.lastMessage!.createdAt) ?? DateTime(1900);
        final bTime = DateTime.tryParse(b.lastMessage!.createdAt) ?? DateTime(1900);
        final comparison = bTime.compareTo(aTime); // Newest first (descending order)
        
        // Log detailed comparison for debugging
        if (comparison != 0) {
          print('🔄 [ChatListCubit] Comparing: ${a.id}:"${a.otherUser.name}" (${aTime}) vs ${b.id}:"${b.otherUser.name}" (${bTime}) → ${comparison > 0 ? "a first" : "b first"}');
        }
        
        return comparison;
      }
      
      // If only one has last message, prioritize the one with message
      if (a.lastMessage != null && b.lastMessage == null) {
        print('🔄 [ChatListCubit] ${a.id}:"${a.otherUser.name}" has message, ${b.id}:"${b.otherUser.name}" doesn\'t → a first');
        return -1; // a comes first
      }
      if (a.lastMessage == null && b.lastMessage != null) {
        print('🔄 [ChatListCubit] ${a.id}:"${a.otherUser.name}" doesn\'t have message, ${b.id}:"${b.otherUser.name}" does → b first');
        return 1; // b comes first
      }
      
      // If neither has last message, compare by chat creation time
      final aCreated = DateTime.tryParse(a.createdAt) ?? DateTime(1900);
      final bCreated = DateTime.tryParse(b.createdAt) ?? DateTime(1900);
      final comparison = bCreated.compareTo(aCreated); // Newest first
      
      if (comparison != 0) {
        print('🔄 [ChatListCubit] Comparing creation time: ${a.id}:"${a.otherUser.name}" (${aCreated}) vs ${b.id}:"${b.otherUser.name}" (${bCreated}) → ${comparison > 0 ? "a first" : "b first"}');
      }
      
      return comparison;
    });
    
    print('🔄 [ChatListCubit] After sorting: ${sortedData.map((c) => '${c.id}:"${c.otherUser.name}"').toList()}');
    print('🔄 [ChatListCubit] ✅ Sorted ${sortedData.length} chats by newest message');
    
    return chatList.copyWith(data: sortedData);
  }

  /// Handle new message and update chat list accordingly
  void handleNewMessage(int chatId, String messageBody, String timestamp, int senderId) {
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
      
      print('🔄 [ChatListCubit] Updated chat $chatId with new message and re-sorted list');
    }
  }

  /// Clear error state and return to initial state
  void clearError() {
    emit(const ChatListInitial());
  }

  /// Debug method to check current unread counts
  void debugUnreadCounts() {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      final totalChats = currentState.chatList.data.length;
      final chatsWithUnread = currentState.chatList.data.where((chat) => chat.unreadCount > 0).toList();
      
      print('[ChatListCubit] 🔍 DEBUG: Total chats: $totalChats');
      print('[ChatListCubit] 🔍 DEBUG: Chats with unread messages: ${chatsWithUnread.length}');
      
      for (final chat in chatsWithUnread) {
        print('[ChatListCubit] 🔍 DEBUG: Chat ${chat.id} (${chat.otherUser.name}): ${chat.unreadCount} unread');
      }
      
      if (chatsWithUnread.isEmpty) {
        print('[ChatListCubit] 🔍 DEBUG: ✅ All chats have 0 unread messages');
      }
    } else {
      print('[ChatListCubit] 🔍 DEBUG: Current state is not ChatListLoaded: ${currentState.runtimeType}');
    }
  }

  /// Debug method to check current chat list state
  void debugChatListState() {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      print('[ChatListCubit] 🔍 DEBUG: Current chat list state:');
      print('[ChatListCubit] 📊 Total chats: ${currentState.chatList.data.length}');
      
      for (int i = 0; i < currentState.chatList.data.length; i++) {
        final chat = currentState.chatList.data[i];
        print('[ChatListCubit] 🔍 Chat $i: ID=${chat.id}, Name="${chat.otherUser.name}", Unread=${chat.unreadCount}');
      }
    } else {
      print('[ChatListCubit] 🔍 DEBUG: Current state is not ChatListLoaded: ${currentState.runtimeType}');
    }
  }

  /// Debug method to find a specific chat by name or ID
  void debugFindChat(dynamic identifier) {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      print('[ChatListCubit] 🔍 DEBUG: Searching for chat with identifier: $identifier (${identifier.runtimeType})');
      
      // Try to find by ID (int or string)
      int? searchId;
      if (identifier is int) {
        searchId = identifier;
      } else if (identifier is String) {
        if (identifier.startsWith('temp_')) {
          print('[ChatListCubit] 🔍 DEBUG: Identifier is a temporary chat ID');
          return;
        }
        searchId = int.tryParse(identifier);
      }
      
      if (searchId != null) {
        try {
          final chatById = currentState.chatList.data.firstWhere((chat) => chat.id == searchId);
          print('[ChatListCubit] 🔍 DEBUG: Found chat by ID $searchId: ${chatById.otherUser.name}');
        } catch (e) {
          print('[ChatListCubit] 🔍 DEBUG: No chat found with ID $searchId');
        }
      }
      
      // Try to find by name
      try {
        final chatByName = currentState.chatList.data.firstWhere(
          (chat) => chat.otherUser.name.toLowerCase().contains(identifier.toString().toLowerCase()),
        );
        print('[ChatListCubit] 🔍 DEBUG: Found chat by name "$identifier": ID=${chatByName.id}, Name="${chatByName.otherUser.name}"');
      } catch (e) {
        print('[ChatListCubit] 🔍 DEBUG: No chat found with name containing "$identifier"');
      }
      
      // Show all available chats for comparison
      print('[ChatListCubit] 🔍 DEBUG: All available chats:');
      for (final chat in currentState.chatList.data) {
        print('[ChatListCubit] 🔍   ID: ${chat.id}, Name: "${chat.otherUser.name}"');
      }
    } else {
      print('[ChatListCubit] 🔍 DEBUG: Current state is not ChatListLoaded: ${currentState.runtimeType}');
    }
  }

  /// Verify chat deletion by checking if the correct chat was removed
  bool verifyChatDeletion(int chatId, String expectedChatName) {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      // Check if the chat with the specified ID still exists
      final chatStillExists = currentState.chatList.data.any((chat) => chat.id == chatId);
      
      if (chatStillExists) {
        print('[ChatListCubit] ❌ VERIFICATION FAILED: Chat $chatId ("$expectedChatName") still exists after deletion!');
        return false;
      } else {
        print('[ChatListCubit] ✅ VERIFICATION SUCCESS: Chat $chatId ("$expectedChatName") was successfully removed');
        return true;
      }
    }
    return false;
  }

  /// Clear deletion protection set (useful for logout or reset)
  void clearDeletionProtection() {
    print('[ChatListCubit] 🧹 Clearing deletion protection set: ${_deletedChatIds.toList()}');
    _deletedChatIds.clear();
  }

  /// Get current deletion protection status
  Set<int> getDeletedChatIds() {
    return Set<int>.from(_deletedChatIds);
  }

  /// Check if chat list is ready and provide debugging info
  Map<String, dynamic> getChatListStatus() {
    final currentState = state;
    final status = <String, dynamic>{
      'stateType': currentState.runtimeType.toString(),
      'isReady': currentState is ChatListLoaded,
      'deletedChatIds': _deletedChatIds.toList(),
    };
    
    if (currentState is ChatListLoaded) {
      status['chatCount'] = currentState.chatList.data.length;
      status['chatIds'] = currentState.chatList.data.map((c) => c.id).toList();
      status['chatNames'] = currentState.chatList.data.map((c) => c.otherUser.name).toList();
    } else if (currentState is ChatListError) {
      status['error'] = currentState.message;
    }
    
    print('🔍 [ChatListCubit] Chat list status: $status');
    return status;
  }

  /// Remove a specific chat ID from deletion protection (useful for testing or manual override)
  void removeFromDeletionProtection(int chatId) {
    if (_deletedChatIds.contains(chatId)) {
      _deletedChatIds.remove(chatId);
      print('[ChatListCubit] 🧹 Removed chat $chatId from deletion protection set');
      print('[ChatListCubit] 🛡️ Current protected IDs: ${_deletedChatIds.toList()}');
    } else {
      print('[ChatListCubit] ℹ️ Chat $chatId was not in deletion protection set');
    }
  }

  /// Check if a specific chat ID is protected from restoration
  bool isChatProtected(int chatId) {
    final isProtected = _deletedChatIds.contains(chatId);
    print('[ChatListCubit] 🛡️ Chat $chatId protection status: ${isProtected ? "PROTECTED" : "NOT PROTECTED"}');
    return isProtected;
  }
}
