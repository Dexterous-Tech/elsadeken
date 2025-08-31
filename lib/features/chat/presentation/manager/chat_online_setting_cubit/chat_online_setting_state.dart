part of 'chat_online_setting_cubit.dart';

@immutable
sealed class ChatOnlineSettingState {}

final class ChatOnlineSettingInitial extends ChatOnlineSettingState {}

final class ChatOnlineSettingGetLoading extends ChatOnlineSettingState {}

final class ChatOnlineSettingGetFailure extends ChatOnlineSettingState {
  final String error;

  ChatOnlineSettingGetFailure(this.error);
}

final class ChatOnlineSettingGetSuccess extends ChatOnlineSettingState {
  final ChatOnlineSettingModel chatOnlineSettingModel;

  ChatOnlineSettingGetSuccess(this.chatOnlineSettingModel);
}

final class ChatOnlineSettingSetLoading extends ChatOnlineSettingState {}

final class ChatOnlineSettingSetFailure extends ChatOnlineSettingState {
  final String error;

  ChatOnlineSettingSetFailure(this.error);
}

final class ChatOnlineSettingSetSuccess extends ChatOnlineSettingState {
  final ChatOnlineSettingModel chatOnlineSettingModel;

  ChatOnlineSettingSetSuccess(this.chatOnlineSettingModel);
}
