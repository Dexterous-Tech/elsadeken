import 'package:elsadeken/features/chat/data/repositories/chat_repo.dart';
import 'package:elsadeken/features/chat/presentation/manager/send_message_cubit/cubit/send_message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageCubit extends Cubit<SendMessagesState> {
  final ChatRepoInterface repo;

  SendMessageCubit(this.repo) : super(SendMessagesInitial());

  Future<void> sendMessages(int receiverId, String message) async {
    emit(SendMessagesLoading());

    final result = await repo.sendMessage(receiverId, message);

    result.fold(
      (error) => emit(SendMessagesError(error.message ?? "حدث خطأ ما")),
      (chatMessages) => emit(SendMessagesLoaded(chatMessages)),
    );
  }
}
