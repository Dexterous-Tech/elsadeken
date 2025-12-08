import 'package:elsadeken/features/chat/data/models/chat_settings_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_settings_request_model.dart';
import 'package:elsadeken/features/chat/data/repositories/chat_settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

// Events
abstract class ChatSettingsEvent extends Equatable {
  const ChatSettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatSettings extends ChatSettingsEvent {}

class UpdateChatSettings extends ChatSettingsEvent {
  final ChatSettingsRequestModel request;

  const UpdateChatSettings(this.request);

  @override
  List<Object?> get props => [request];
}

// States
abstract class ChatSettingsState extends Equatable {
  const ChatSettingsState();

  @override
  List<Object?> get props => [];
}

class ChatSettingsInitial extends ChatSettingsState {}

class ChatSettingsLoading extends ChatSettingsState {}

class ChatSettingsLoaded extends ChatSettingsState {
  final ChatSettingsModel chatSettings;

  const ChatSettingsLoaded(this.chatSettings);

  @override
  List<Object?> get props => [chatSettings];
}

class ChatSettingsError extends ChatSettingsState {
  final String message;

  const ChatSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatSettingsUpdating extends ChatSettingsState {}

class ChatSettingsUpdated extends ChatSettingsState {
  final String message;

  const ChatSettingsUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatSettingsUpdateError extends ChatSettingsState {
  final String message;

  const ChatSettingsUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ChatSettingsCubit extends Cubit<ChatSettingsState> {
  final ChatSettingsRepository _repository;

  ChatSettingsCubit(this._repository) : super(ChatSettingsInitial());

  Future<void> loadChatSettings({String? errorMessage}) async {
    emit(ChatSettingsLoading());

    try {
      final response = await _repository.getChatSettings();

      if (response.isSuccess) {
        emit(ChatSettingsLoaded(response.data!));
      } else {
        emit(ChatSettingsError(response.message));
      }
    } catch (e) {
      emit(ChatSettingsError(errorMessage ?? 'errorLoadingSettings'));
    }
  }

  Future<void> updateChatSettings(
    ChatSettingsRequestModel request, {
    String? successMessage,
    String? errorMessage,
  }) async {
    // Check if we have current settings
    if (state is! ChatSettingsLoaded) {
      emit(
        ChatSettingsUpdateError(
          errorMessage ?? 'cannotUpdateSettingsBeforeLoading',
        ),
      );
      return;
    }

    final currentState = state as ChatSettingsLoaded;

    // Check if we have a valid settings ID
    if (currentState.chatSettings.id == 0) {
      emit(
        ChatSettingsUpdateError(errorMessage ?? 'noChatSettingsContactSupport'),
      );
      return;
    }

    emit(ChatSettingsUpdating());

    try {
      final stopwatch = Stopwatch()..start();

      // Add timeout to prevent hanging
      final response = await _repository
          .updateChatSettings(request, currentState.chatSettings.id.toString())
          .timeout(
            const Duration(seconds: 15), // 15 second timeout
            onTimeout: () {
              throw TimeoutException(
                'Update request timed out',
                const Duration(seconds: 15),
              );
            },
          );

      stopwatch.stop();

      if (response.isSuccess) {
        // Show success message in Arabic
        emit(ChatSettingsUpdated(successMessage ?? 'dataUpdatedSuccessfully'));
        // Reload settings to get updated data
        await loadChatSettings();
      } else {
        // Show error message from API or default Arabic message
        final errorMessage = response.message.isNotEmpty
            ? response.message
            : 'errorUpdatingSettings';
        emit(ChatSettingsUpdateError(errorMessage));
      }
    } on TimeoutException catch (e) {
      emit(
        ChatSettingsUpdateError(errorMessage ?? 'connectionTimeoutRetry $e'),
      );
    } catch (e) {
      // Provide more specific error messages based on the error type
      String finalErrorMessage = errorMessage ?? 'errorUpdatingSettings';

      if (e.toString().contains('405')) {
        finalErrorMessage = 'requestMethodError';
      } else if (e.toString().contains('401')) {
        finalErrorMessage = 'sessionExpiredRelogin';
      } else if (e.toString().contains('500')) {
        finalErrorMessage = 'serverErrorTryLater';
      } else if (e.toString().contains('timeout')) {
        finalErrorMessage = 'connectionTimeoutCheckInternet';
      } else if (e.toString().contains('404')) {
        finalErrorMessage = 'settingsNotFoundContactSupport';
      }

      emit(ChatSettingsUpdateError(finalErrorMessage));
    }
  }
}
