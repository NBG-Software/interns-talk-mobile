class Chat {
  final int? id;
  final int? mentorId;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Chat({
    this.id,
    this.mentorId,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as int?,
      mentorId: json['mentor_id'] as int?,
      userId: json['user_id'] as int?,
      createdAt: DateTime.tryParse(json['created_at']),
      updatedAt: DateTime.tryParse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentor_id': mentorId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
