import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';

abstract class ChatListState {
  const ChatListState();
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
}

class ChatListError extends ChatListState {
  final String message;
  const ChatListError(this.message);
}
