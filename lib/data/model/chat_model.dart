class Chat {
  final int chatId;
  final int mentorId;
  final String firstName;
  final String lastName;
  final String? messageText;
  final String? messageMedia;
  final String? createdAt;
  final String? image;

  Chat({
    required this.firstName,
    required this.lastName,
    this.messageText,
    this.messageMedia,
    required this.chatId,
    required this.mentorId,
    this.createdAt,
    this.image
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      mentorId: json['mentor_id'] ?? 0,
      firstName: json['first_name'] ?? 'Unknown',
      lastName: json['last_name'] ?? 'User',
      chatId: json['chat_id'] ?? 0,
      messageText: json['message_text'] ,
      messageMedia: json['message_media'],
      createdAt: json['created_at'],
      image: json['image'] ?? ''
    );
  }
}
