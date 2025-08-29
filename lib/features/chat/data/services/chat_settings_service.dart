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
      print('[ChatSettingsService] Getting chat settings...');
      
      final response = await _apiServices.get<Map<String, dynamic>>(
        endpoint: ApiConstants.getChatSettings,
      );

      print('[ChatSettingsService] Get successful: ${response.data}');
      
      final result = ApiResponseModel<ChatSettingsModel>.fromJson(
        response.data!,
        (json) => ChatSettingsModel.fromJson(json),
      );
      
      // Log the user's chat settings ID
      print('[ChatSettingsService] Chat settings ID: ${result.data!.id}');
      
      return result;
    } catch (e) {
      print('[ChatSettingsService] Get failed: $e');
      rethrow;
    }
  }

  Future<ApiResponseModel<void>> updateChatSettings(
    ChatSettingsRequestModel request,
    String settingsId,
  ) async {
    try {
      print('[ChatSettingsService] Updating chat settings with ID: $settingsId');
      print('[ChatSettingsService] Request data: ${request.toJson()}');
      print('[ChatSettingsService] Making PUT request to: ${ApiConstants.updateChatSettings(settingsId)}');
      
      final stopwatch = Stopwatch()..start();
      
      final response = await _apiServices.put<Map<String, dynamic>>(
        endpoint: ApiConstants.updateChatSettings(settingsId),
        requestBody: request.toJson(),
      );

      stopwatch.stop();
      print('[ChatSettingsService] Update completed in ${stopwatch.elapsedMilliseconds}ms');
      print('[ChatSettingsService] Update successful: ${response.data}');
      print('[ChatSettingsService] Response status: ${response.statusCode}');
      
      return ApiResponseModel<void>.fromJson(
        response.data!,
        null, // No data to parse for update response
      );
    } catch (e) {
      print('[ChatSettingsService] Update failed: $e');
      print('[ChatSettingsService] Error type: ${e.runtimeType}');
      print('[ChatSettingsService] Error details: ${e.toString()}');
      rethrow;
    }
  }
}
