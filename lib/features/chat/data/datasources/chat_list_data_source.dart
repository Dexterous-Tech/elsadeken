import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
import 'package:elsadeken/features/chat/data/models/chat_conversation_model.dart';
import 'package:elsadeken/features/chat/data/models/chat_list_model.dart';

class ChatListDataSource {
  final ApiServices _apiServices;

  ChatListDataSource(this._apiServices);

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
}
