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
      currentPage: dataObj['current_page'] ?? 1,
      data: (dataObj['data'] as List?)
              ?.map((e) => ChatData.fromJson(e))
              .toList() ??
          [],
      firstPageUrl: dataObj['first_page_url'] ?? '',
      from: dataObj['from'] ?? 1,
      lastPage: dataObj['last_page'] ?? 1,
      lastPageUrl: dataObj['last_page_url'] ?? '',
      links: (dataObj['links'] as List?)
              ?.map((e) => PageLink.fromJson(e))
              .toList() ??
          [],
      nextPageUrl: dataObj['next_page_url'],
      path: dataObj['path'] ?? '',
      perPage: dataObj['per_page'] ?? 15,
      prevPageUrl: dataObj['prev_page_url'],
      to: dataObj['to'] ?? 1,
      total: dataObj['total'] ?? 0,
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? 200,
      showToast: json['showToast'] ?? false,
    );
  }

  ChatListModel copyWith({
    int? currentPage,
    List<ChatData>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    List<PageLink>? links,
    String? nextPageUrl,
    String? path,
    int? perPage,
    String? prevPageUrl,
    int? to,
    int? total,
    String? message,
    String? type,
    int? status,
    bool? showToast,
  }) {
    return ChatListModel(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      firstPageUrl: firstPageUrl ?? this.firstPageUrl,
      from: from ?? this.from,
      lastPage: lastPage ?? this.lastPage,
      lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      links: links ?? this.links,
      nextPageUrl: nextPageUrl ?? this.nextPageUrl,
      path: path ?? this.path,
      perPage: perPage ?? this.perPage,
      prevPageUrl: prevPageUrl ?? this.prevPageUrl,
      to: to ?? this.to,
      total: total ?? this.total,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      showToast: showToast ?? this.showToast,
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
  final bool isFavorite;

  ChatData({
    required this.id,
    required this.lastMessage,
    required this.unreadCount,
    required this.otherUser,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['id'] ?? 0,
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      otherUser: OtherUser.fromJson(json['other_user']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
    );
  }

  /// Get isMuted from last message if available
  bool get isMuted => lastMessage?.isMuted == 1;

  /// Get isReported from last message if available
  bool get isReported => lastMessage?.isReported == 1;

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
      isFavorite: isFavorite, // Use the isFavorite property from ChatData
      receiverId: otherUser.id, // Add receiver ID for sending messages
    );
  }

  ChatData copyWith({
    int? id,
    LastMessage? lastMessage,
    int? unreadCount,
    OtherUser? otherUser,
    String? createdAt,
    String? updatedAt,
    bool? isFavorite,
  }) {
    return ChatData(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      otherUser: otherUser ?? this.otherUser,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class LastMessage {
  final int id;
  final int chatId;
  final int senderId;
  final int receiverId;
  final String body;
  final int isReported;
  final int isMuted;
  final int? reportedByUserId;
  final String createdAt;

  LastMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.body,
    required this.isReported,
    required this.isMuted,
    this.reportedByUserId,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'] ?? 0,
      chatId: json['chat_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      body: json['body'] ?? '',
      isReported: json['is_reported'] ?? 0,
      isMuted: json['is_muted'] ?? 0,
      reportedByUserId: json['reported_by_user_id'],
      createdAt: json['created_at'] ?? '',
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
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
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
      label: json['label'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
