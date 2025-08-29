import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import '../../data/models/chat_settings_model.dart';
import '../../data/models/chat_settings_request_model.dart';
import '../../data/repositories/chat_settings_repository.dart';
import '../../data/models/api_response_model.dart';

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

  Future<void> loadChatSettings() async {
    print('[ChatSettingsCubit] loadChatSettings called');
    emit(ChatSettingsLoading());
    
    try {
      print('[ChatSettingsCubit] Calling repository getChatSettings...');
      final response = await _repository.getChatSettings();
      print('[ChatSettingsCubit] Repository response: ${response.isSuccess} - ${response.message}');
      
      if (response.isSuccess) {
        print('[ChatSettingsCubit] Settings loaded successfully, ID: ${response.data!.id}');
        emit(ChatSettingsLoaded(response.data!));
      } else {
        print('[ChatSettingsCubit] Failed to load settings: ${response.message}');
        emit(ChatSettingsError(response.message));
      }
    } catch (e) {
      print('[ChatSettingsCubit] Exception in loadChatSettings: $e');
      emit(const ChatSettingsError('حدث خطأ أثناء تحميل الإعدادات'));
    }
  }

  Future<void> updateChatSettings(ChatSettingsRequestModel request) async {
    print('[ChatSettingsCubit] updateChatSettings called with request: ${request.toJson()}');
    
    // Check if we have current settings
    if (state is! ChatSettingsLoaded) {
      print('[ChatSettingsCubit] Error: No current settings loaded');
      emit(const ChatSettingsUpdateError('لا يمكن تحديث الإعدادات قبل تحميلها'));
      return;
    }

    final currentState = state as ChatSettingsLoaded;
    print('[ChatSettingsCubit] Current settings ID: ${currentState.chatSettings.id}');
    
    // Check if we have a valid settings ID
    if (currentState.chatSettings.id == 0) {
      print('[ChatSettingsCubit] No valid settings ID - user has no chat settings yet');
      emit(const ChatSettingsUpdateError('لا توجد إعدادات محادثة - يرجى التواصل مع الدعم الفني'));
      return;
    }
    
    emit(ChatSettingsUpdating());
    
    try {
      print('[ChatSettingsCubit] Calling repository updateChatSettings...');
      final stopwatch = Stopwatch()..start();
      
      // Add timeout to prevent hanging
      final response = await _repository.updateChatSettings(
        request, 
        currentState.chatSettings.id.toString(),
      ).timeout(
        const Duration(seconds: 15), // 15 second timeout
        onTimeout: () {
          print('[ChatSettingsCubit] Update request timed out after 15 seconds');
          throw TimeoutException('Update request timed out', const Duration(seconds: 15));
        },
      );
      
      stopwatch.stop();
      print('[ChatSettingsCubit] Repository call completed in ${stopwatch.elapsedMilliseconds}ms');
      print('[ChatSettingsCubit] Response received: ${response.isSuccess} - ${response.message}');
      
      if (response.isSuccess) {
        print('[ChatSettingsCubit] Update successful, emitting ChatSettingsUpdated');
        // Show success message in Arabic
        emit(ChatSettingsUpdated('تم تحديث الإعدادات بنجاح'));
        // Reload settings to get updated data
        print('[ChatSettingsCubit] Reloading settings...');
        await loadChatSettings();
        print('[ChatSettingsCubit] Settings reloaded successfully');
      } else {
        print('[ChatSettingsCubit] Update failed with message: ${response.message}');
        // Show error message from API or default Arabic message
        final errorMessage = response.message.isNotEmpty 
            ? response.message 
            : 'حدث خطأ أثناء تحديث الإعدادات';
        emit(ChatSettingsUpdateError(errorMessage));
      }
    } on TimeoutException catch (e) {
      print('[ChatSettingsCubit] Timeout exception: $e');
      emit(const ChatSettingsUpdateError('انتهت مهلة الاتصال - يرجى المحاولة مرة أخرى'));
    } catch (e) {
      print('[ChatSettingsCubit] Exception occurred: $e');
      print('[ChatSettingsCubit] Exception type: ${e.runtimeType}');
      // Provide more specific error messages based on the error type
      String errorMessage = 'حدث خطأ أثناء تحديث الإعدادات';
      
      if (e.toString().contains('405')) {
        errorMessage = 'خطأ في طريقة الطلب - يرجى المحاولة مرة أخرى';
      } else if (e.toString().contains('401')) {
        errorMessage = 'انتهت صلاحية الجلسة - يرجى إعادة تسجيل الدخول';
      } else if (e.toString().contains('500')) {
        errorMessage = 'خطأ في الخادم - يرجى المحاولة لاحقاً';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'انتهت مهلة الاتصال - يرجى التحقق من الإنترنت';
      } else if (e.toString().contains('404')) {
        errorMessage = 'الإعدادات غير موجودة - يرجى التواصل مع الدعم الفني';
      }
      
      print('[ChatSettingsCubit] Emitting error: $errorMessage');
      emit(ChatSettingsUpdateError(errorMessage));
    }
  }
}
