class Chat {
  final int chatId;
  final String? firstName;
  final String? lastName;
  final String? messageText;
  final String? messageMedia;
  final String? createdAt;

  Chat({
    this.firstName,
    this.lastName,
    this.messageText,
    this.messageMedia,
    required this.chatId,
    this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      firstName: json['first_name'] ?? 'Unknown',
      lastName: json['last_name'] ?? 'User',
      chatId: json['chat_id'] ?? 0,
      messageText: json['message_text'],
      messageMedia: json['message_media'],
      createdAt: json['created_at'],
    );
  }
}
