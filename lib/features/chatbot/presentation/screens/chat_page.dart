import 'package:atherio/features/chatbot/presentation/blocs/chat_bloc.dart';
import 'package:atherio/features/chatbot/presentation/blocs/chat_event.dart';
import 'package:atherio/features/chatbot/presentation/blocs/chat_state.dart';
import 'package:atherio/features/chatbot/presentation/widgets/animation_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/chat_bubble.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    if (_controller.text.isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(_controller.text));
      _controller.clear();
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gemini AI Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: LoadingAnimation());
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return FadeTransition(
                        opacity: _animation,
                        child: ChatBubble(
                          message: message.text,
                          isUser: message.isUser,
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const Center(child: Text('Start chatting!'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(context),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}