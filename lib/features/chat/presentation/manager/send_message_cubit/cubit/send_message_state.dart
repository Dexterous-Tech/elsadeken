import 'package:elsadeken/features/chat/data/models/send_message_model.dart';

abstract class SendMessagesState {}

class SendMessagesInitial extends SendMessagesState {}

class SendMessagesLoading extends SendMessagesState {}

class SendMessagesLoaded extends SendMessagesState {
  final SendMessageModel sendMessageModel;
  SendMessagesLoaded(this.sendMessageModel);
}

class SendMessagesError extends SendMessagesState {
  final String message;
  SendMessagesError(this.message);
}
