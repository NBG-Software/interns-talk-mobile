class Chat {
  final int id;
  final int? chatId;
  final String? firstName;
  final String? lastName;
  final String? messageText;
  final String? messageMedia;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    required this.id,
    this.firstName,
    this.lastName,
    this.messageText,
    this.messageMedia,
    this.chatId,
    this.createdAt,
    this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      firstName: json['first_name'] ?? 'Unknown',
      lastName: json['last_name']?? 'User',
      chatId: json['chat_id'] as int?,
      messageText: json['message_text'] ?? 'Sent a message',
      messageMedia: json['message_media'] ?? 'Sent a photo',
      createdAt: DateTime.tryParse(json['created_at']),
      updatedAt: DateTime.tryParse(json['updated_at']),
    );
  }
}
