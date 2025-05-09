import 'package:atherio/features/chatbot/domain/repository/chat_repository.dart';
import '../entities/chat_message.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<ChatMessage> call(String message) async {
    return await repository.sendMessage(message);
  }
}