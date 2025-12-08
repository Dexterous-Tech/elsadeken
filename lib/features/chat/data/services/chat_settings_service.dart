import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/core/networking/api_constants.dart';
import '../models/chat_settings_model.dart';
import '../models/chat_settings_request_model.dart';
import '../models/api_response_model.dart';

class ChatSettingsService {
  final ApiServices _apiServices;

  ChatSettingsService(this._apiServices);

  Future<ApiResponseModel<ChatSettingsModel>> getChatSettings() async {
    try {
      final response = await _apiServices.get<Map<String, dynamic>>(
        endpoint: ApiConstants.getChatSettings,
      );

      final result = ApiResponseModel<ChatSettingsModel>.fromJson(
        response.data!,
        (json) => ChatSettingsModel.fromJson(json),
      );

      // Log the user's chat settings ID

      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponseModel<void>> updateChatSettings(
    ChatSettingsRequestModel request,
    String settingsId,
  ) async {
    try {
      final stopwatch = Stopwatch()..start();

      final response = await _apiServices.put<Map<String, dynamic>>(
        endpoint: ApiConstants.updateChatSettings(settingsId),
        requestBody: request.toJson(),
      );

      stopwatch.stop();

      return ApiResponseModel<void>.fromJson(
        response.data!,
        null, // No data to parse for update response
      );
    } catch (e) {
      rethrow;
    }
  }
}
