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
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      messageText: json['message_text'] ?? '',
      messageMedia: json['message_media'],
      createdAt: DateTime.parse(json['created_at']),
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
