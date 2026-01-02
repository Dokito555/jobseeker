class ChatMessage {
  final int id;
  final int jobVacancyId;
  final int senderId;
  final String senderType;
  final String senderName;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.jobVacancyId,
    required this.senderId,
    required this.senderType,
    required this.senderName,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      jobVacancyId: json['job_vacancy_id'],
      senderId: json['sender_id'],
      senderType: json['sender_type'],
      senderName: json['sender_name'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_vacancy_id': jobVacancyId,
      'sender_id': senderId,
      'sender_type': senderType,
      'sender_name': senderName,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class SendMessageRequest {
  final String message;

  SendMessageRequest({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}