import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({required super.text, required super.isUser});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
    };
  }
}