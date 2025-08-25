import 'dart:convert';

/// 🔹 Send Message Response Model
class SendMessageModel {
  final SendMessageData data;
  final String message;
  final String type;
  final int status;
  final bool showToast;

  SendMessageModel({
    required this.data,
    required this.message,
    required this.type,
    required this.status,
    required this.showToast,
  });

  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      data: SendMessageData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? 0,
      showToast: json['showToast'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data.toJson(),
      "message": message,
      "type": type,
      "status": status,
      "showToast": showToast,
    };
  }

  /// handy helper
  static SendMessageModel fromRawJson(String str) =>
      SendMessageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

/// 🔹 Send Message Data Model
class SendMessageData {
  final int chatId;
  final int senderId;
  final int receiverId;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;

  SendMessageData({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  factory SendMessageData.fromJson(Map<String, dynamic> json) {
    return SendMessageData(
      chatId: json['chat_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      body: json['body'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chat_id": chatId,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "body": body,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "id": id,
    };
  }
}
