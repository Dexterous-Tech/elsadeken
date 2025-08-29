import '../models/chat_settings_model.dart';
import '../models/chat_settings_request_model.dart';
import '../models/api_response_model.dart';
import '../services/chat_settings_service.dart';

class ChatSettingsRepository {
  final ChatSettingsService _service;

  ChatSettingsRepository(this._service);

  Future<ApiResponseModel<ChatSettingsModel>> getChatSettings() async {
    try {
      return await _service.getChatSettings();
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseModel<void>> updateChatSettings(
    ChatSettingsRequestModel request,
    String settingsId,
  ) async {
    try {
      return await _service.updateChatSettings(request, settingsId);
    } catch (e) {
      rethrow;
    }
  }
}

