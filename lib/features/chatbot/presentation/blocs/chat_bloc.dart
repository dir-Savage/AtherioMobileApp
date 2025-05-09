import 'package:atherio/features/chatbot/domain/entities/chat_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final List<ChatMessage> _messages = [];

  ChatBloc(this.sendMessageUseCase) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      _messages.add(ChatMessage(text: event.message, isUser: true));
      final response = await sendMessageUseCase(event.message);
      _messages.add(response);
      emit(ChatLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}