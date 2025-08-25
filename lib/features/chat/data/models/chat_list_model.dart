import 'package:elsadeken/features/chat/data/models/chat_room_model.dart';

class ChatListModel {
  final int currentPage;
  final List<ChatData> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;
  final String message;
  final String type;
  final int status;
  final bool showToast;

  ChatListModel({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'];
    return ChatListModel(
      currentPage: dataObj['current_page'],
      data: (dataObj['data'] as List).map((e) => ChatData.fromJson(e)).toList(),
      firstPageUrl: dataObj['first_page_url'],
      from: dataObj['from'],
      lastPage: dataObj['last_page'],
      lastPageUrl: dataObj['last_page_url'],
      links: (dataObj['links'] as List).map((e) => PageLink.fromJson(e)).toList(),
      nextPageUrl: dataObj['next_page_url'],
      path: dataObj['path'],
      perPage: dataObj['per_page'],
      prevPageUrl: dataObj['prev_page_url'],
      to: dataObj['to'],
      total: dataObj['total'],
      message: json['message'],
      type: json['type'],
      status: json['status'],
      showToast: json['showToast'],
    );
  }
}

class ChatData {
  final int id;
  final LastMessage? lastMessage;
  final int unreadCount;
  final OtherUser otherUser;
  final String createdAt;
  final String updatedAt;

  ChatData({
    required this.id,
    required this.lastMessage,
    required this.unreadCount,
    required this.otherUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['id'],
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'],
      otherUser: OtherUser.fromJson(json['other_user']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  /// Convert ChatData to ChatRoomModel for navigation
  ChatRoomModel toChatRoomModel() {
    return ChatRoomModel(
      id: id.toString(),
      name: otherUser.name,
      image: otherUser.image,
      lastMessage: lastMessage?.body ?? 'لا توجد رسائل',
      lastMessageTime: lastMessage != null 
          ? DateTime.tryParse(lastMessage!.createdAt) ?? DateTime.now()
          : DateTime.now(),
      unreadCount: unreadCount,
      isOnline: false, // TODO: Get from API when available
      isFavorite: false, // TODO: Get from API when available
      receiverId: otherUser.id, // Add receiver ID for sending messages
    );
  }
}

class LastMessage {
  final int id;
  final int chatId;
  final int senderId;
  final int receiverId;
  final String body;
  final int isRead;
  final int isReported;
  final int? reportedByUserId;
  final String createdAt;
  final String updatedAt;

  LastMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.body,
    required this.isRead,
    required this.isReported,
    required this.reportedByUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      body: json['body'],
      isRead: json['is_read'],
      isReported: json['is_reported'],
      reportedByUserId: json['reported_by_user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class OtherUser {
  final int id;
  final String name;
  final String image;

  OtherUser({
    required this.id,
    required this.name,
    required this.image,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) {
    return OtherUser(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    required this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) {
    return PageLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
