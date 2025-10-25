import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/chat/data/models/chat_conversation_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_online_setting_model.dart';
import 'package:elsadeken/features/chat/data/models/send_message_model.dart';

class ChatDataSource {
  final ApiServices _apiServices;

  ChatDataSource(this._apiServices);

  Future<ChatListModel> getAllChatList() async {
    print('🌐 [ChatDataSource] Calling getAllChatList API...');
    var response = await _apiServices.get(
      endpoint: ApiConstants.getChatsList,
      queryParameters: {'favorite': '0'}, // Only get non-favorite chats
      requiresAuth: true,
    );

    // Debug: Print raw API response
    print('🌐 [ChatDataSource] Raw API response: ${response.data}');

    final chatList = ChatListModel.fromJson(response.data);
    print(
        '🌐 [ChatDataSource] getAllChatList response: ${chatList.data.length} chats');

    // Debug: Print all chat IDs and names with favorite status
    for (int i = 0; i < chatList.data.length; i++) {
      final chat = chatList.data[i];
      print(
          '🌐 [ChatDataSource] Chat $i: ID=${chat.id}, Name=${chat.otherUser.name}, isFavorite=${chat.isFavorite}');
    }

    return chatList;
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
      requiresAuth: true,
    );

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> unreportChat(int chatId) async {
    final response = await _apiServices.get(
      endpoint: ApiConstants.reportChatSettings(chatId.toString()),
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
    final timestamp = DateTime.now().toIso8601String();
    print(
        '🌐 [ChatDataSource] Calling delete API for chat ID: $chatId at $timestamp');
    print(
        '🌐 [ChatDataSource] Endpoint: ${ApiConstants.deleteOneChatSettings(chatId.toString())}');

    final response = await _apiServices.delete(
      endpoint: ApiConstants.deleteOneChatSettings(chatId.toString()),
      requestBody: {},
      requiresAuth: true,
    );

    print('🌐 [ChatDataSource] Delete API response: ${response.data}');
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

  Future<ChatListModel> getFavoriteChatList() async {
    // Get favorite chats using the main endpoint with favorite=1 parameter
    var response = await _apiServices.get(
      endpoint: ApiConstants.getChatsList,
      queryParameters: {'favorite': '1'}, // Correct parameter name
      requiresAuth: true,
    );

    return ChatListModel.fromJson(response.data);
  }

  Future<Map<String, dynamic>> addChatToFavorite(int chatId,
      {int favourite = 1}) async {
    final response = await _apiServices.get(
      endpoint: ApiConstants.addChatToFavorite(chatId),
      queryParameters: {
        'favourite': favourite, // 1 = add to favorite, 0 = remove from favorite
      },
      requiresAuth: true,
    );

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> removeChatFromFavorite(int chatId) async {
    return await addChatToFavorite(chatId, favourite: 0);
  }

  Future<ChatOnlineSettingModel> getOnline() async {
    var response = await _apiServices.get(
      endpoint: ApiConstants.getOnline,
      requiresAuth: true,
    );

    return ChatOnlineSettingModel.fromJson(response.data);
  }

  Future<ChatOnlineSettingModel> setOnline() async {
    var response = await _apiServices.post(
      endpoint: ApiConstants.setOnline,
      requestBody: null,
      requiresAuth: true,
    );

    return ChatOnlineSettingModel.fromJson(response.data);
  }
}
