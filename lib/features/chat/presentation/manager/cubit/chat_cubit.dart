import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_message.dart';
import 'package:elsadeken/features/chat/domain/entities/chat_room.dart';
import 'package:elsadeken/features/chat/domain/repositories/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  ChatCubit(this._chatRepository) : super(ChatInitial());

  Future<void> loadChatRooms() async {
    emit(ChatLoading());
    
    try {
      final result = await _chatRepository.getChatRooms();
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (chatRooms) => emit(ChatRoomsLoaded(chatRooms)),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> loadChatMessages(String roomId) async {
    emit(ChatMessagesLoading());
    
    try {
      final result = await _chatRepository.getChatMessages(roomId);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (messages) => emit(ChatMessagesLoaded(messages)),
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage(String roomId, String message) async {
    try {
      final result = await _chatRepository.sendMessage(roomId, message);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) {
          // Reload messages after sending
          loadChatMessages(roomId);
          // Also reload chat rooms to update last message and time
          loadChatRooms();
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> markAsRead(String roomId) async {
    try {
      final result = await _chatRepository.markAsRead(roomId);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) {
          // Reload chat rooms to update unread count
          loadChatRooms();
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> deleteChat(String roomId) async {
    try {
      final result = await _chatRepository.deleteChat(roomId);
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) {
          // Reload chat rooms after deletion
          loadChatRooms();
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final result = await _chatRepository.markAllAsRead();
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) {
          // Reload chat rooms to update unread counts
          loadChatRooms();
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> deleteAllChats() async {
    try {
      final result = await _chatRepository.deleteAllChats();
      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) {
          // Reload chat rooms after deletion
          loadChatRooms();
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void clearError() {
    emit(ChatInitial());
  }
}
