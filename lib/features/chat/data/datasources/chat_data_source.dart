import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/chat/data/models/chat_conversation_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/data/models/send_message_model.dart';

class ChatDataSource {
  final ApiServices _apiServices;

  ChatDataSource(this._apiServices);

  Future<ChatListModel> getAllChatList() async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.getChatsList,
      requiresAuth: true,
    );

    return ChatListModel.fromJson(response.data);
  }

  Future<ChatMessagesConversation> getChatMessages(String chatId) async {
    final response = await _apiServices.get(
      endpoint: ApiConstants.userChat(chatId),
      requiresAuth: true,
    );

    return ChatMessagesConversation.fromJson(response.data);
  }

  Future<SendMessageModel> sendMessage(
    int receiverId,
    String message,
  ) async {
    var response = await _apiServices.post(
      endpoint: ApiConstants.sendMessage,
      requestBody: {
        'receiver_id': receiverId,
        'body': message,
      },
    );

    return SendMessageModel.fromJson(response.data);
  }

  Future<Map<String, dynamic>> markAllMessagesAsRead() async {
    final response = await _apiServices.get(
      endpoint: ApiConstants.markAllMessagesAsRead,
      requiresAuth: true,
    );

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> reportChat(int chatId) async {
    final response = await _apiServices.get(
      endpoint: ApiConstants.reportChatSettings(chatId.toString()),
      queryParameters: {'action': 'report'},
      requiresAuth: true,
    );

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> muteChat(int chatId) async {
    final response = await _apiServices.get(
      endpoint: ApiConstants.muteChatSettings(chatId.toString()),
      queryParameters: {'action': 'toggle'},
      requiresAuth: true,
    );

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteOneChat(int chatId) async {
    final response = await _apiServices.delete(
      endpoint: ApiConstants.deleteOneChatSettings(chatId.toString()),
      requestBody: {},
      requiresAuth: true,
    );

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteAllChats() async {
    final response = await _apiServices.delete(
      endpoint: ApiConstants.deleteAllChatSettings,
      requestBody: {},
      requiresAuth: true,
    );

    return response.data as Map<String, dynamic>;
  }
}
