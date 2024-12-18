import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/blocs/auth/auth_bloc.dart';
import 'package:shop/blocs/chat/chat_bloc.dart';
import 'package:shop/models/models.dart';
import 'package:shop/utils/chat.dart';
import 'package:shop/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "chat";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      final defaultMessage = args?['defaultMessage'] as String?;

      if (defaultMessage != null) {
        final chatBloc = context.read<ChatBloc>();
        final selectedChat = chatBloc.state.selectedChat;
        if (selectedChat != null) {
          final chatMessage = ChatMessage(
            user: context.read<AuthBloc>().state.user!.toChatUser,
            text: defaultMessage,
            createdAt: DateTime.now(),
          );
          chatBloc.add(SendMessage(selectedChat.id, chatMessage));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.read<ChatBloc>();
    final authBloc = context.read<AuthBloc>();

    return StartUpContainer(
      onInit: () {
        chatBloc.add(const GetChatMessage());
        if (chatBloc.state.selectedChat != null) {
          // listenChatChannel(chatBloc.state.selectedChat!);
        }
      },
      onDisposed: () {
        chatBloc.add(const ChatReset());
        chatBloc.add(const ChatStarted());
      },
      child: Scaffold(
        appBar: AppBar(
          title: BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state.selectedChat != null) {
                // listenChatChannel(state.selectedChat!);
              }
            },
            listenWhen: (previous, current) =>
                previous.selectedChat != current.selectedChat,
            builder: (context, state) {
              final chat = state.selectedChat;
              return Text(
                chat == null
                    ? "N/A"
                    : getChatName(
                        chat.participants,
                        authBloc.state.user!,
                      ),
              );
            },
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return DashChat(
              currentUser: authBloc.state.user!.toChatUser,
              onSend: (ChatMessage chatMessage) {
                chatBloc.add(SendMessage(
                  state.selectedChat!.id,
                  chatMessage,
                ));
              },
              messages: state.uiChatMessages,
              messageListOptions: MessageListOptions(
                onLoadEarlier: () async {
                  chatBloc.add(const LoadMoreChatMessage());
                },
              ),
            );
          },
        ),
      ),
    );
  }
}