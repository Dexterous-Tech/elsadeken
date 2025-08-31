import 'package:elsadeken/features/chat/data/models/chat_online_setting_model.dart';
import 'package:elsadeken/features/chat/domain/repositories/chat_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_online_setting_state.dart';

class ChatOnlineSettingCubit extends Cubit<ChatOnlineSettingState> {
  ChatOnlineSettingCubit(this.chatRepoInterface)
      : super(ChatOnlineSettingInitial());

  final ChatRepoInterface chatRepoInterface;

  void getOnline() async {
    emit(ChatOnlineSettingGetLoading());

    var response = await chatRepoInterface.getOnline();

    response.fold(
        (error) => emit(ChatOnlineSettingGetFailure(error.displayMessage)),
        (chatOnline) => emit(ChatOnlineSettingGetSuccess(chatOnline)));
  }

  void setOnline() async {
    emit(ChatOnlineSettingSetLoading());

    var response = await chatRepoInterface.setOnline();

    response.fold(
        (error) => emit(ChatOnlineSettingSetFailure(error.displayMessage)),
        (chatOnline) => emit(ChatOnlineSettingSetSuccess(chatOnline)));
  }
}
