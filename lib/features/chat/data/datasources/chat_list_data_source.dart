import 'package:elsadeken/core/networking/api_constants.dart';
import 'package:elsadeken/core/networking/api_services.dart';
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
}
