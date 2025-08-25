import 'package:elsadeken/features/chat/data/models/chat_conversation_model.dart';

abstract class ChatMessagesState {}

class ChatMessagesInitial extends ChatMessagesState {}

class ChatMessagesLoading extends ChatMessagesState {}

class ChatMessagesLoaded extends ChatMessagesState {
  final ChatMessagesConversation chatMessages;
  ChatMessagesLoaded(this.chatMessages);
}

class ChatMessagesError extends ChatMessagesState {
  final String message;
  ChatMessagesError(this.message);
}
