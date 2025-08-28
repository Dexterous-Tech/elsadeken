import 'package:dartz/dartz.dart';
import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';
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

  /// Find an existing chat room by receiver ID
  ChatRoomModel? findExistingChatRoom(int receiverId) {
    try {
      print('🔍 [ChatListCubit] Looking for existing chat room for user ID: $receiverId');
      print('🔍 [ChatListCubit] Current state: ${state.runtimeType}');
      
      final currentState = state;
      if (currentState is ChatListLoaded) {
        print('🔍 [ChatListCubit] Chat list is loaded, checking ${currentState.chatList.data.length} chats');
        
        final existingChats = currentState.chatList.data
            .where((chat) {
              print('🔍 [ChatListCubit] Checking chat: ${chat.otherUser.id} vs $receiverId');
              return chat.otherUser.id == receiverId;
            })
            .toList();

        if (existingChats.isNotEmpty) {
          print('✅ [ChatListCubit] Found existing chat: ${existingChats.first.id}');
          return existingChats.first.toChatRoomModel();
        } else {
          print('❌ [ChatListCubit] No existing chat found for user $receiverId');
        }
      } else {
        print('⚠️ [ChatListCubit] Chat list not loaded yet. Current state: ${state.runtimeType}');
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
              data: currentState.chatList.data.map((chat) => 
                chat.copyWith(unreadCount: 0)
              ).toList(),
            );
            
            // Emit updated state
            emit(ChatListLoaded(updatedChatList));
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
              data: currentState.chatList.data.where((chat) => chat.id != chatId).toList(),
            );
            emit(ChatListLoaded(updatedChatList));
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

}
