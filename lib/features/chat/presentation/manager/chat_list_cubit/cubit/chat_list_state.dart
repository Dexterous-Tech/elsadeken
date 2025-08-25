import 'package:equatable/equatable.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();
  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {
  const ChatListInitial();
}

class ChatListLoading extends ChatListState {
  const ChatListLoading();
}

class ChatListLoaded extends ChatListState {
  final ChatListModel chatList;
  const ChatListLoaded(this.chatList);

  @override
  List<Object?> get props => [chatList];
}

class ChatListError extends ChatListState {
  final String message;
  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}
