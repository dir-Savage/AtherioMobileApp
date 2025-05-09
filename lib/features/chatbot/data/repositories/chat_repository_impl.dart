import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/const/api_key.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: geminiApiKey,
  );

  @override
  Future<ChatMessage> sendMessage(String message) async {
    try {
      final response = await model.generateContent([Content.text(message)]);
      return ChatMessage(text: response.text ?? 'No response', isUser: false);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}