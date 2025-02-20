class MessageModel {
  final int id;
  final int chatId;
  final int senderId;
  final String messageText;
  final String? messageMedia;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.messageText,
    this.messageMedia,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      chatId: json['chat_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      messageText: json['message_text'] ?? '',
      messageMedia: json['message_media'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'message_text': messageText,
      'message_media': messageMedia,
      'created_at': createdAt,
    };
  }

  static List<MessageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MessageModel.fromJson(json)).toList();
  }
}
